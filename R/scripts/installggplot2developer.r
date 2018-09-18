# install devtools
install.packages('devtools')

# install dependency of scales package
install.packages(c("RColorBrewer", "stringr", "dichromat", "munsell", "plyr", "colorspace"))

# load devtools
library(devtools)

# move to development mode
# scales and ggplot2 are installed in "~/R-dev" directory, so official version of ggplot2 are not removed.
dev_mode(TRUE)

install_github("hadley/scales")
# main branch of development
install_github("ggplot2", "hadley", "develop")
#install_github("ggplot2", "kohske", "feature/new-guides-with-gtable")

# load development version of ggplot2
library(ggplot2)
