pca <- prcomp(new_df[-1], scale = T, center = T)
summary(pca)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pca$center
pca$scale
pca$rotation
head(pca$x,10)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
biplot(pca)
autoplot(pca,data=new_df,colour='type')


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
ggbiplot(pca, obs.scale = 2, var.scale =1 , ellipse = TRUE, circle = TRUE,groups=new_df$type) +
  scale_color_discrete(name = '') +
  theme(legend.direction = 'horizontal', legend.position = 'top')


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Getting proportion of variance for a scree plot
pca.var <- pca$sdev^2
pve <- pca.var / sum(pca.var)

# Plot variance explained for each principal component
plot(pve, 
     xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     ylim = c(0,1), 
     type = "b")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pve
# Plot cumulative proportion of variance explained
plot(cumsum(pve), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
get_pca_var(pca)[2]
get_pca_var(pca)[4]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pca <- prcomp(new_df[-1], scale = F, center = T)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
autoplot(pca,data=new_df,colour='type')