require('FactoMineR')
require('rgl')

setwd('/home/gerard/Documents/ADM/paper1')

# read the data
shuttle.trn <- read.table(file = "shuttle.trn", header=FALSE, sep=" ")
shuttle.tst <- read.table(file = "shuttle.tst", header=FALSE, sep=" ")
summary(shuttle.trn)
summary(shuttle.tst)

hist.trn <- hist(shuttle.trn$V10, nclass=7)
hist.tst <- hist(shuttle.tst$V10, nclass=7)

hist.trn$counts
hist.tst$counts

hist.trn$density
hist.tst$density

# We expect new observations in real world to follow the classes density distribution of the train set. Hence, we want our test
# set to follow a similar distribution to the one of the train set. (For example, if we were testing with a uniformly distributed
# test set: a model that predicts poorly class 1 could have an accuracy near 5/6 in our test set, while in real world would be much worst).

# Use the chi-square test to check if the distribution of classes is similar in both train and test dataset.

# From the distribution density of classes in the train dataset,
# calculate the expected number of observations of each class in the test dataset.
hist.tst.expected_class_counts <- hist.trn$density * nrow(shuttle.tst)

# Combine frequencies
freqsTable <- data.frame(hist.tst$counts, hist.tst.expected_class_counts);

# Plot combined histograms
par(mfrow=c(1,1))
barplot(t(as.matrix(freqsTable)), ylab='Count', xlab='Categories', beside=TRUE, col=c('green', 'yellow'));

# Chi square test
# p-value greater than significance level = .05 (at a confidence of .95) => can't reject null hipothesys that the distributions are the same
chisq.test(freqsTable, correct=FALSE)

# Visualizing the data usign PCA. More than 50% of the variance is explained by first two dimensions
shuttle.PCA <- PCA(shuttle.trn, quali.sup=c(10))

# more than 67% of the variance is explained by 3 first dimensions
shuttle.PCA$eig

# Variable contributions to PCA's dimensions
# Variable 9 doesn't practically contribute to any dimension. That may happen because another variable is already explaining its variance.
# Looking at the PCA correlation graph we can see a correlation between V8 and V9. 
shuttle.PCA$var$contrib

# Check that V8 and V9 are actually correlated
cor(shuttle.trn$V8, shuttle.trn$V9)

# Plot individuals with it's classes in PCA's dimensions
# The individuals in each class seem to conform a more or less compact cluster (or separated but still compact sub-clusters) in the PCA dimension space. 
# A neural network with one hidden layer and not a lot of hidden newrons should work.
plot(shuttle.PCA, axes = c(1, 2), habillage=10, title="Plot of individuals", xlim=c(-10,10), ylim=c(-10,10), labels=c())

Psi = shuttle.PCA$ind$coord
plot3d(Psi[,1], Psi[,2], Psi[,3], col=shuttle.trn$V10,"Dim1", "Dim2", "Dim3",main="Crabs Data", pch=20,
       xlim=c(-5,5), ylim=c(-5,5), zlim=c(-5,5))

