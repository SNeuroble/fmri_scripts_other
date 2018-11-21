
nperm<-1000
y<-sample(1:8,20,replace=T)
x<-sample(1:6,20,replace=T)
t<-sample(x,length(x))
head(x)

xperm<-matrix(NA, ncol=2, nrow=nperm)
perms2=0

for(i in 1:nperm) {
	xp<-sample(x,length(x))
	perm_slms<-lm(y~xp)
	t2<-coef(perm_slms)
	perms2[i]<-t2['xp']
}

# testsub$ftest=factor(testsub$ftest)


plot(density(perms2)) # this plots all data in 1st column
dev.new()
hist(perms2)
#plot(density(perm_slms[,2])) # this plots all data in 2nd column
test_stat=1
print(sum(perms2>test_stat))

