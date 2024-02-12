random = randomForest(type~.,data=new_df,mtry = sqrt(ncol(new_df)-1), importance = T, ntree = 1000)
bagging = randomForest(type~.,data=new_df,mtry=ncol(new_df)-1,importance=T,ntree=1000)
plot(random)
plot(bagging)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
oob.err.data <- data.frame(
  Trees = rep(1:nrow(bagging$err.rate), 3), 
  Type = rep(c("OOB","normal","HCC"), each = nrow(bagging$err.rate)),
  Error = c(bagging$err.rate[,"OOB"], bagging$err.rate[,"normal"], bagging$err.rate[,"HCC"]))

ggplot(data = oob.err.data, aes(x = Trees, y= Error)) + geom_line(aes(color = Type))
print(bagging)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
oob.err.data <- data.frame(
  Trees = rep(1:nrow(random$err.rate), 3), 
  Type = rep(c("OOB","normal","HCC"), each = nrow(random$err.rate)),
  Error = c(random$err.rate[,"OOB"], random$err.rate[,"normal"], random$err.rate[,"HCC"]))

ggplot(data = oob.err.data, aes(x = Trees, y= Error)) + geom_line(aes(color = Type))
print(random)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
t <- tuneRF(new_df[,-1], new_df[,1],
       stepFactor = 0.5,
       mtryStart=2,
       plot = TRUE,
       ntreeTry = 50,
       trace = TRUE,
       improve = 1e-5,doBest=TRUE)
oob.err.data <- data.frame(
  Trees = rep(1:nrow(t$err.rate), 3), 
  Type = rep(c("OOB","normal","HCC"), each = nrow(t$err.rate)),
  Error = c(t$err.rate[,"OOB"], t$err.rate[,"normal"], t$err.rate[,"HCC"]))

ggplot(data = oob.err.data, aes(x = Trees, y= Error)) + geom_line(aes(color = Type))
print(t)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
hist(treesize(t),
     main = "No. of Nodes for the Trees",
     col = "green")


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
varImpPlot(t,sort = T,n.var = 10,main = "Top 10 - Variable Importance")
importance(t)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
partialPlot(t, new_df,X205019_s_at,'HCC')
partialPlot(t, new_df,X205019_s_at,'normal')
partialPlot(t, new_df,X215330_at ,'HCC')
partialPlot(t, new_df,X215330_at ,'normal')


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
t <- tuneRF(new_df[,-1], new_df[,1],
       stepFactor = 0.5,
       mtryStart=2,
       plot = TRUE,
       ntreeTry = 50,
       trace = TRUE,
       improve = 1e-5,doBest=TRUE,proximity=TRUE)
MDSplot(t, new_df$type)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
control <- trainControl(method="cv", number=10,returnResamp="all")
caret_res <- train(type ~., data=new_df, method="rf", metric="Accuracy", ntree = 100, trControl=control)

df = data.frame(caret_res$resample,test="caret")


ggplot(df,aes(x=mtry,y=Accuracy,col=test))+
stat_summary(fun.data=mean_se,geom="errorbar",width=0.2) +
stat_summary(fun=mean,geom="line") + facet_wrap(~test)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
cf=cforest(type ~ ., data=new_df, controls=cforest_control(mtry=4, mincriterion=0))
pt <- party:::prettytree(cf@ensemble[[1]], names(cf@data@get("input")))
pt
