km.out <- kmeans(new_df[-1], centers = 2, nstart = 20)
summary(km.out)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
km.out$cluster


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
km.out

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- km.out$cluste
pred <- rep("HCC",nrow(new_df))
pred[probs == probs[length(probs)]] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df$type=factor(new_df$type,labels=c(2,1))
plot(new_df[-1][1:10], col = km.out$cluster)
plot(new_df[-1][1:10], col = new_df$type)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
wss <- 0

# For 1 to 15 cluster centers
for (i in 1:15) {
  km.out <- kmeans(new_df[-1], centers = i, nstart = 20)
  # Save total within sum of squares to wss variable
  wss[i] <- km.out$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
km.out <- kmeans(new_df[-1], centers = 3, nstart = 20)
km.out$cluster
plot(new_df[-1][1:10], col = km.out$cluster)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- km.out$cluster
pred <- rep("HCC",nrow(new_df))
pred[probs == probs[length(probs)]] <- "normal"
pred
t = confusionMatrix(as.factor(pred), reference=factor(new_df$type,labels=c('HCC','normal')))
t