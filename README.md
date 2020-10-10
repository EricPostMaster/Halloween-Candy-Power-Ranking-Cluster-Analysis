# Analyzing the Ultimate Halloween Candy Power Ranking

<p align="center">
<img src="https://github.com/EricPostMaster/Halloween-Candy-Power-Ranking-Cluster-Analysis/blob/master/Analysis_Featured_Image.png" width=60% height=60%>
</p>

Like everything else in 2020, this Halloween will be different from any other year.  That doesn’t have to be a negative thing, though.  Fewer trick-or-treaters means you get to keep more of the candy bowl to yourself.  I am celebrating early this year with an analysis of FiveThirtyEight’s Ultimate Halloween Candy Power Ranking dataset.

My biggest takeaway: If you want to make everyone happy, chocolate and peanut butter is the undisputed winning combination.  All Reese’s products were winners.  If you’re feeling budget-conscious but still want to hand out winners to trick-or-treaters, then go for Almond Joy, Sour Haribo Gummy Bears, and AirHeads.

I should also point out that winning candies are more than 50% more expensive than loser candies on average, so you might be tempted to go cheap.  However, if it means a difference of pacifying the juvenile zombie hordes or waking up to a 24-pack of TP strewn in your trees, then it might just be worth the splurge.

## The Data

In 2017, FiveThirtyEight created an online candy voting challenge for 85 different fun-sized candies that are commonly handed out to trick-or-treaters on Halloween. The task was simple: the voter would be shown two pictures (e.g. a Snickers bar and a Butterfinger), and they had to choose which one they would prefer.  More than 8,000 people participated, voting on over 269,000 candy match-ups. (#SweetTooth)

The final Power Ranking dataset is composed of 85 fun-sized candies and 12 descriptive variables. There are nine descriptive binary variables, including chocolate, fruity, and pluribus (multiple candies in a pack, like Skittles or M&Ms); two continuous percentile variables ranking candies by sugar content and price; and a continuous variable tracking the overall win percentage for each candy from the 269,000 match-ups.

## Methodology & Analysis
To better understand the preferences of mask-clad tricksters that may come knocking at my door, I performed a cluster analysis on the rankings and did some hypothesis testing to determine whether candies with certain characteristics were more likely to be in the “Winners” category or the “Losers” category.

I decided to use principal components analysis and k-Means clustering to reduce noise in the overall dataset and make it possible to plot the clusters in two dimensions.  The first two principal components captured 56.7% of the variance in the dataset, so I was confident I would be able to identify some useful clusters.

After a bit of trial and error and consulting the scree plot for PCA, I settled on three clusters for the group.  One of the best parts about clustering is getting to know the stories behind each cluster.  I used Dr. Race’s ClusterProfile function in R (Thanks, Dr. Race!) to plot histograms of each cluster’s variable composition compared to histograms of the overall dataset composition (see example below).  In the plots below, the salmon-colored bars represent the variable composition of the cluster, and the purple bars represent variable composition of the overall dataset.

<p align="center">
<img src="https://github.com/EricPostMaster/Halloween-Candy-Power-Ranking-Cluster-Analysis/blob/master/cluster_profiles_updated.png" width=60% height=60%>
</p>

After coding each of the clusters into a profile group, the final principal component plot included Chocolate Bars, Fruity Candy, and Chocolately Pieces clusters.

<p align="center">
<img src="https://github.com/EricPostMaster/Halloween-Candy-Power-Ranking-Cluster-Analysis/blob/master/cluster_plot.png" width=60% height=60%>
</p>

To continue investigating, I subdivided the full dataset into “Winners” and “Losers” datasets based on whether the candies’ win percentages were above or below 50%.  I repeated the PCA and cluster analysis with the following results.

<p align="center">
<img src="https://github.com/EricPostMaster/Halloween-Candy-Power-Ranking-Cluster-Analysis/blob/master/win_lose_plots.png" width=80% height=80%>
</p>

As you can see, the cluster characteristics of the Losers group are similar to those of the overall dataset.  In the Winners group, there were very few fruity candies, so there were only two major clusters: chocolate bars and pieces (both chocolate and fruit).

I also conducted several hypothesis tests (alpha=.05) comparing Winners and Losers.  Here are some of the most interesting results:

* Winners are significantly more expensive than Losers (p=.0006)
* Chocolate is much more common among the Winners (p=<.0001)
* Peanut butter/almonds is more common among the Winners (p=.002)
* Fruity candies are more common in the Losers group (p=.004)
* There is no significant difference in sugar content between Winners and Losers (p=.09)

## Recommendations
From the cluster analysis, it’s clear that if you want to make everyone happy, you should stick with chocolate bars, especially anything with peanut butter.  The most popular sweets overall were Reese’s Peanut Butter Cups, Reese’s Miniatures, and Twix.  Almond Joy and AirHeads are cheaper Winner options.  On the other end of the spectrum, the most expensive losers, which should be avoided if at all possible, were Smarties, Ring Pops, and <a href="https://en.wikipedia.org/wiki/Nik-L-Nip" target="_blank">Nik-L-Nip</a> (I had to google that one).

## Learnings & Conclusion
The best part of this project (besides thinking about my own favorite candies) was reviewing the cluster profile histograms to discover the story in each cluster.  An algorithm can detect clusters numerically, but it’s my job to extract the story.  This was a great project to practice on because the dataset was not so large that I couldn’t double check my interpretation, and now I will feel much more confident in the future when interpreting similar cluster profile histograms.

From a technical standpoint, I decided to use this project to sharpen my R skills.  I have done PCA before, but this was my first time using it in combination with clustering.  I learned Python before I started R, so I tend to try Python first, but PCA and clustering in R are so easy!








