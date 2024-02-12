model = glmnet(as.matrix(df[-1:-2]),df[,2],family=binomial(),alpha=1,lambda=NULL)
model


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(model,label=TRUE,xvar='norm')
plot(model,label=TRUE,xvar='dev')
plot(model,label=TRUE,xvar='lambda')


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
model.cv = cv.glmnet(as.matrix(df[-1:-2]),df[,2],family=binomial(),alpha=1,nfolds=5)
x=coef(model.cv,s='lambda.min')
for(i in 2:length(x)){
  if(x[i]!=0){
   print(colnames(df)[i+1])
  }
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(model.cv)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
model.cv$lambda.min


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(model.cv, newx = as.matrix(df[-1:-2]), s = "lambda.min")
contrasts(df$type)


pred <- rep("HCC",nrow(df))
pred[probs > 0.5] <- "normal"
pred
t = confusionMatrix(as.factor(pred), reference=as.factor(df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs = predict(model, as.matrix(df[-1][-1]), s = 0.3)
pred <- rep("HCC",nrow(df))
pred[probs > 0.5] <- "normal"
pred
t = confusionMatrix(as.factor(pred), reference=as.factor(df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df = df%>%
  mutate(id=row_number())

training = df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)

probs <- predict(model.cv, newx = as.matrix(testing[-1:-2]), s = "lambda.min")
pred <- rep("HCC",nrow(testing))
pred[probs > 0.5] <- "normal"
pred

t = confusionMatrix(as.factor(pred), reference=as.factor(testing$type))
t
df = df[-ncol(df)]


## ----eval=FALSE--------------------------------------------------------------------------------------------------------------------------------------------------------
## library(logistf)
## model4 <- logistf(type~.,df[2:100], family = binomial(),control=logistf.control(maxit=2000))
## summary(model4)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mod = glm(type~.,mut_df[-1],family=binomial())


