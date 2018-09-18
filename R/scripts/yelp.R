# Yelp project

setwd('Documents/data/yelp_training_set')
user_data=read.csv('yelp_training_set_user.csv')
rev_data=read.csv('yelp_training_set_review.csv')

# central Q: can I predict what my rating will be given other people's ratings and my previous ratings?

########################################################
## Exploring, mainly review counts
# use dplyr
# subsetting w R: https://www.statmethods.net/management/subset.html
########################################################

#summary(review_count)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#1.00    2.00    7.00   38.86   23.00 5807.00 

#sum(review_count>1000)  # 26k users with <10 reviews, 100 with >1k
#user_data[user_data$review_count>2000,]  # user # 1834 is an outlier (~6k) - only one >2000 

attach(user_data)
ids=(review_count>10) & (review_count<1000)
user_subset=user_data[ids,]
hist(user_subset$review_count, breaks=100)
#plot(density(review_count, breaks=10))
# exp decay - should prob weight ppl with more reviews and votes

## Votes
# cor(votes_cool,votes_funny) # high correlation btw vote types (= 0.97)
tot_votes<-user_data$votes_cool+user_data$votes_funny+user_data$votes_useful
ids=tot_votes<1000 & tot_votes>0
hist(tot_votes[ids], breaks=100)
# user_subset=user_data[ids,] # 38k voted users; even 1k users have > 1k votes

# another way:
votes<-summarise(by_user,
                 votes_total=sum(votes_cool,votes_funny,votes_useful),
                 mean_cool=mean(votes_cool),
                 mean_funny=mean(votes_funny),
                 mean_useful=mean(votes_useful))
# also an outlier here
ids=votes$votes_total>1000
hist(votes$votes_total[ids], breaks=100)

## Business
sum(rev_data$business_id=="9yKzy9PApeiPPOUJEtnvkg")


########################################################
# Collaborative Filtering
# https://cran.r-project.org/web/packages/recosystem/vignettes/introduction.html
########################################################
library(recosystem)

flag_select=0 # most experienced users
min_rev=0
max_rev=1000
min_votes=1
max_votes=1000
prop_train=0.8

if (flag_select) {
  tot_votes<-user_data$votes_cool+user_data$votes_funny+user_data$votes_useful
  ids=tot_votes>=min_votes & tot_votes<=max_votes
  #ids=(user_data$review_count>=min_rev) & (user_data$review_count<=max_rev)
  user_ids_select=user_data$user_id[ids]
  ids_select=which(user_ids_select %in% rev_data$user_id)
  d=rev_data[ids_select,c(7,1,4)]
} else {
  d=rev_data[,c(7,1,4)]
}


d$user_id=as.numeric(d$user_id)
d$business_id=as.numeric(d$business_id)
n_train=ceiling(length(d$user_id)*prop_train)
d_shuf=d[sample(nrow(d)),]
train=d_shuf[1:n_train,]
test=d_shuf[(n_train+1):nrow(d),]

write.table(test,"test.txt",row.names = FALSE, col.names = FALSE)
write.table(train,"train.txt",row.names = FALSE, col.names = FALSE)
train_set = data_file("train.txt")
test_set = data_file("test.txt")
r = Reco()
opts = r$tune(train_set, opts = list(dim = c(10, 20, 30), lrate = c(0.1, 0.2),
                                     costp_l1 = 0, costq_l1 = 0,
                                     nthread = 1, niter = 10))
r$train(train_set, opts = c(opts$min, nthread = 1, niter = 20))
pred_file = tempfile()
r$predict(test_set, out_file(pred_file))
#print(scan(pred_file, n = 10))
pred_rvec = r$predict(test_set, out_memory())
r_prediction=cor(pred_rvec,test$stars)

## Learning strategies:
# ML type: gradient boosting + random forest; maybe pca python
# user info (cluster)
# 	different businesses reviewed
# 	different categories reviewed
#	avg useful vote (cluster)
#	user groups (w vote data, no vote data, private)
#review info
#	using user’s findings: length of test, caps, paragraphs, punctuation marks
#	words, # sentences, url, # numbers
#	month review made and age,
#	1-4 grams (continuous words)
# maybe add
#	words like great/good/bad, # complex/long words
#	meta reviews that mention “review” - other ppl’s reviews
#	sort words/punctuation
# for each business, sum # reviews, avg review, sd

