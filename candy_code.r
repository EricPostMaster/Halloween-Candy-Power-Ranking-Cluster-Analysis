#####################################################
###############  Halloween Candy Analysis
#####################################################


###############  Getting Started

### Load data and packages

# install.packages("PerformanceAnalytics")
# install.packages("GGally")
library(skimr)
library(DataExplorer)
library(GGally)
library(ggplot2)
library(PerformanceAnalytics)
library(RColorBrewer)

candy = read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/candy-power-ranking/candy-data.csv")

candy$winpercent = candy$winpercent/100  # Change winpercent to match other percent variable formats

### Take an initial look at the data

# Both of these provide correlation plots
# I chose the second because it includes histograms along the diagonal by default

# ggpairs(candy[,11:13])+ theme_bw()
chart.Correlation(candy[,11:13], histogram=TRUE, pch=19)



#####################################################
###############  Principal Components Analysis
#####################################################


# Create principal components
candy.pca = prcomp(candy[,2:13], scale=F)
summary(candy.pca)

# Screeplot
plot(candy.pca$sdev^2)

# Cumulative Percent Variance Explained
plot(cumsum(candy.pca$sdev^2)/sum(candy.pca$sdev), ylab="Percent Variance Explained", xlab="Number of Components")

# Plotting principal components
par(mfrow=c(3,2), mar=c(4,4,1,1))
plot(candy.pca$x[,1],candy.pca$x[,2])
plot(candy.pca$x[,1],candy.pca$x[,3])
plot(candy.pca$x[,1],candy.pca$x[,4])
plot(candy.pca$x[,2],candy.pca$x[,3])
plot(candy.pca$x[,2],candy.pca$x[,4])
plot(candy.pca$x[,3],candy.pca$x[,4])



#####################################################
###############  k-Means Clustering
#####################################################

# Run the kmeans clustering algorithm
cluster_qty = 3
clusters1 = kmeans(candy.pca$x[,1:4], cluster_qty)

candy$clusters1 = clusters1$cluster

# Cluster colors for plotting
colors = c("#af231c", "#eeb007", "#7b4931")

candy$clustercolor = ifelse(candy$clusters1 == 1, colors[1],
                            ifelse(candy$clusters1 == 2, colors[2], colors[3]))

# Plot three clusters based on principal components 1 and 2
par(mfrow=c(1,1))
plot(candy.pca$x[,1:2], col= alpha(candy$clustercolor, 0.7) , pch=19, cex=1.8, xlab="Principal Component 1",
     ylab="Principal Component 2")
title(main="Halloween Candy Power Ranking Clusters", mar=c(1,0,0,0))
legend("topleft", title="Legend", legend= c("Chocolate Bars", "Fruity Candy", "Chocolatey Pieces") , col=colors, pch=19)



#####################################################
###############  Cluster Profile Function
#####################################################


# I didn't write this awesome function, I got it from Shaina Race, PhD.  Comments are my own.
# (https://directory.ncsu.edu/directory//moreinfo.php?username=slrace)


# Adjusted the function to create fewer bins (chubby bars)
clusterProfile = function(df, clusterVar, varsToProfile){
  k = max(df[,clusterVar])  # k is the largest number in the cluster column, which is the total number of clusters
  for(j in varsToProfile){  # for each variable that we want to profile...
    if(is.numeric(df[,j])){ # if the variable is numeric,
      for(i in 1:k){        # repeat this loop for each cluster
        hist(as.numeric(df[df[,clusterVar]==i ,j ]), breaks=5, freq=F, col=rgb(1,0,0,0.5),  # Create histogram of cluster number i in terms of variable j
             xlab=paste( tools::toTitleCase(j)), ylab="Density", main=paste("Cluster",i, 'vs All Data'))
        hist(as.numeric(df[,j ]), breaks=5,freq=F, col=rgb(0,0,1,0.5), xlab="", ylab="Density", add=T)  # Overlay histogram of variable j distribution in total population
        
        legend("topright", bty='n',legend=c(paste("cluster",i),'all observations'), col=c(rgb(1,0,0,0.5),rgb(0,0,1,0.5)), pt.cex=2, pch=15 )
        }
    }
    if(is.factor(df[,j])&length(levels(df[,j]))<5){
      (counts = table( df[,j],df[,clusterVar]))
      (counts = counts%*%diag(colSums(counts)^(-1)))
      barplot(counts, main=paste(j, 'by cluster'),
              xlab=paste(j), legend = rownames(counts), beside=TRUE)
    }
  }
}



###########################################################
###############  Cluster Profiling to Get the Full Story
###########################################################

varsToProfile = c("chocolate", "fruity", "caramel", "peanutyalmondy", "nougat",
                  "crispedricewafer", "hard", "bar", "pluribus", "sugarpercent",
                  "pricepercent", "winpercent")

par(mfrow=c(1,1))  # Change this to c(3,3) if you want a grid
clusterProfile(df=candy, clusterVar = 'clusters1', varsToProfile)


###########################################################
###############  Cluster Profiling Winners and Losers
###########################################################


losers = candy[which(candy$winpercent < .5),]
winners = candy[which(candy$winpercent >= .5),]


###############  Cluster Profiling - Losers

# Create principal components
losers.pca = prcomp(losers[,2:13], scale=F)
summary(losers.pca)

# Screeplot
par(mfrow=c(1,1))
plot(losers.pca$sdev^2)

# Cumulative Percent Variance Explained
par(mfrow=c(1,1))
plot(cumsum(losers.pca$sdev^2)/sum(losers.pca$sdev), ylab="Percent Variance Explained (Losers)",
     xlab="Number of Components", main = "Percent Variance Explained (Losers)")

# Plotting principal components
par(mfrow=c(3,2), mar=c(4,4,1,1))
plot(losers.pca$x[,1],losers.pca$x[,2])
plot(losers.pca$x[,1],losers.pca$x[,3])
plot(losers.pca$x[,1],losers.pca$x[,4])
plot(losers.pca$x[,2],losers.pca$x[,3])
plot(losers.pca$x[,2],losers.pca$x[,4])
plot(losers.pca$x[,3],losers.pca$x[,4])


# Run the kmeans clustering algorithm
cluster_qty = 3
clusters1 = kmeans(losers.pca$x[,1:4], cluster_qty)

losers$clusters1 = clusters1$cluster

par(mfrow=c(1,1))
plot(losers.pca$x[,1:2], col=losers$clusters1 )


# Cluster Profiling
varsToProfile = c("chocolate", "fruity", "caramel", "peanutyalmondy", "nougat",
                  "crispedricewafer", "hard", "bar", "pluribus", "sugarpercent",
                  "pricepercent", "winpercent")
par(mfrow=c(3,3))
clusterProfile(df=losers, clusterVar = 'clusters1', varsToProfile)


# Overall Cluster Plot
losers$clustercolor = ifelse(losers$clusters1 == 1, colors[3],
                            ifelse(losers$clusters1 == 2, colors[2], colors[1]))

# Plot three clusters based on principal components 1 and 2
par(mfrow=c(1,1))
plot(losers.pca$x[,1:2], col= alpha(losers$clustercolor, 0.7) , pch=19, cex=1.8, xlab="Principal Component 1",
     ylab="Principal Component 2")
title(main='Halloween Candy Clusters - "Losers"', mar=c(1,0,0,0))
legend("topright", title="Legend", legend= c("Chocolatey Pieces", "Fruity Candy", "Chocolate Bars") , col=colors, pch=19, cex=.8)





###############  Cluster Profiling - Winners

# Create principal components
winners.pca = prcomp(winners[,2:13], scale=F)
summary(winners.pca)

# Screeplot
par(mfrow=c(1,1))
plot(winners.pca$sdev^2)

# Cumulative Percent Variance Explained
par(mfrow=c(1,1))
plot(cumsum(winners.pca$sdev^2)/sum(winners.pca$sdev), ylab="Percent Variance Explained (Winners)",
     xlab="Number of Components", main = "Percent Variance Explained (Winners)")

# Plotting principal components
par(mfrow=c(3,2), mar=c(4,4,1,1))
plot(winners.pca$x[,1],winners.pca$x[,2])
plot(winners.pca$x[,1],winners.pca$x[,3])
plot(winners.pca$x[,1],winners.pca$x[,4])
plot(winners.pca$x[,2],winners.pca$x[,3])
plot(winners.pca$x[,2],winners.pca$x[,4])
plot(winners.pca$x[,3],winners.pca$x[,4])

# Run the kmeans clustering algorithm
cluster_qty = 2
clusters1 = kmeans(winners.pca$x[,1:4], cluster_qty)

winners$clusters1 = clusters1$cluster

par(mfrow=c(1,1))
plot(winners.pca$x[,1:2], col=winners$clusters1 )


# Cluster Profiling
varsToProfile = c("chocolate", "fruity", "caramel", "peanutyalmondy", "nougat",
                  "crispedricewafer", "hard", "bar", "pluribus", "sugarpercent",
                  "pricepercent", "winpercent")
par(mfrow=c(3,2))
clusterProfile(df=winners, clusterVar = 'clusters1', varsToProfile)


# Overall Cluster Plot
winners$clustercolor = ifelse(winners$clusters1 == 1, colors[1], colors[2])

# Plot three clusters based on principal components 1 and 2
par(mfrow=c(1,1))
plot(winners.pca$x[,1:2], col= alpha(winners$clustercolor, 0.7) , pch=19, cex=1.8, xlab="Principal Component 1",
     ylab="Principal Component 2")
title(main='Halloween Candy Clusters - "Winners"', mar=c(1,0,0,0))
legend("topright", title="Legend", legend= c("Pieces (Choc&Fruit)", "Chocolate Bars") , col=colors, pch=19, cex=.8)





###########################################################
###############  Cheapest Winners - Give to avoid pranks
###########################################################

cheap_win = winners[order(winners$winpercent),]
cheap_win[1:3,]
# Almond Joy, Haribo Sour Bears, Air Heads



###########################################################
###############  Biggest Losers - Give to your enemies
###########################################################

big_losers = losers[order(losers$winpercent),]
big_losers[1:3,]
# Nik L Nip (waxy juice bottles), Boston Baked Beans, Chiclets



###########################################################
###############  Cheap Losers - Affordable trash
###########################################################

cheap_lose = losers[order(losers$pricepercent),]
cheap_lose[1:3,]
# Tootsie Roll Midgies, Pixie Sticks, Dum Dums



###########################################################
###############  Expensive Losers - Avoid at all costs
###########################################################

expensive_loser = losers[order(-losers$pricepercent),]
expensive_loser[1:3,]
# Nik L Nip, Nestle Smarties, Ring Pop (yeah, Ring Pops are lame)



###########################################################
###############  Favorites - Buy for Yourself
###########################################################

favorites = winners[order(-winners$winpercent),]
favorites[1:3,]
# Reese's Peanut Butter Cup, Reese's Miniatures, Twix



###########################################################
###############  Other Important Questions
###########################################################

# Are popular candies more expensive?
# Is price significantly different between winners and losers?
t.test(losers$pricepercent,winners$pricepercent)  # p-value .0006
# Avg Losers cost: $0.37, Avg Winners cost: $0.58 - wow!


# Are candies with more sugar more likely to be popular?
t.test(losers$sugarpercent,winners$sugarpercent)  # p-value .09
# No significant difference

# Are pluribus candies more common among winners or losers?
t.test(losers$pluribus, winners$pluribus)  # p-value .17
# No significant difference

# Are there more chocolate candies in the winners?
t.test(losers$chocolate, winners$chocolate)  # p-value <.0001
# There are a lot more chocolates in the winners group

# Are there more fruity candies in the winners?
t.test(losers$fruity, winners$fruity)  # p-value .004
# Lots more fruity candies in the losers group

# Are there more peanut butter/almond candies in the winners?
t.test(losers$peanutyalmondy, winners$peanutyalmondy)  # p-value .002
# There are a lot more winners with almonds or peanut butter