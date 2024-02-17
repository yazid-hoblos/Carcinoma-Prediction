hclust.out <- hclust(dist(new_df[-1]))
summary(hclust.out)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(hclust.out)
abline(h = 30, col = "red")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Cut by height
c=cutree(hclust.out, h = 30)
c


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df$type = factor(new_df$type,labels=('HCC','normal'))
pred <- rep("HCC",nrow(new_df))
pred[c == c[length(c)]] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Cut by number of clusters
c=cutree(hclust.out, k = 3)
c


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pred <- rep("HCC",nrow(new_df))
pred[c == c[length(c)]] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
c=cutree(hclust.out, k = 7)
c
pred <- rep("HCC",nrow(new_df))
pred[c == c[length(c)]] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Cluster using complete linkage: hclust.complete
hclust.complete <- hclust(dist(new_df[-1]), method = "complete")

# Cluster using average linkage: hclust.average
hclust.average <- hclust(dist(new_df[-1]), method = "average")

# Cluster using single linkage: hclust.single
hclust.single <- hclust(dist(new_df[-1]), method = "single")

# Cluster using single linkage: hclust.centroid
hclust.centroid <- hclust(dist(new_df[-1]), method = "centroid")



## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(hclust.complete, main = "Complete")
plot(hclust.average, main = "Average")
plot(hclust.single, main = "single")
plot(hclust.centroid, main = "centroid")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
apply(new_df[-1],2,sd)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for (i in 2:8){
km.out <- kmeans(new_df[-1], centers = i, nstart = 20)
cut <- cutree(hclust.out, k = i)
print(i-1) #iteration number
print(table(km.out$cluster, cut)) #comparing the clusters of the 2 approaches
print("kmeans")
print(table(km.out$cluster, new_df$type)) #comparing the clusters of k-means to actual classes
print("hierarchical")
print(table(cut, new_df$type)) #comparing the clusters of hierarchical to actual classes
}