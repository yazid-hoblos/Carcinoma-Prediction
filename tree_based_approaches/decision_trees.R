tree <- rpart(formula = type~.,new_df, method = "class")
rpart.plot(tree,type=4)
tree


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
printcp(tree)
plotcp(tree)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
tree <- rpart(formula = type~.,new_df, method = "class",cp=0.0000000001)
rpart.plot(tree,type=4)
printcp(tree)
plotcp(tree)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df = new_df%>%
  dplyr::mutate(id=row_number())

training = new_df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(new_df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)
new_df=new_df[-ncol(new_df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
tree <- rpart(formula = type~.,training, method = "class")
rpart.plot(tree,type=4)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
p <- predict(tree, testing, type = 'class')
confusionMatrix(p, reference=as.factor(testing$type), positive="HCC")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
p <- predict(tree, testing, type = 'prob')
p <- p[,2]
r <- multiclass.roc(testing$type, p, percent = TRUE)
roc <- r[['rocs']]
r <- roc[[1]]
plot.roc(r,
         print.auc=TRUE,
         auc.polygon=TRUE,
         grid=c(0.1, 0.2),
         grid.col=c("green", "red"),
         max.auc.polygon=TRUE,
         auc.polygon.col="lightblue",
         print.thres=TRUE,
         main= 'ROC Curve')
