var=var1=var2=c(0,0)
for(i in 3:ncol(df_S)){
  var[i] = var(df_S[,i]) #overall variance
  var1[i] = var(df_S[1:181,i]) #variance over HCC cases
  var2[i] = var(df_S[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
total=0
for (i in 1:ncol(df_S)){
  if(var2[i]<0.06){
    total=total+1
  }
}
print(total)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df=df_S[1:2]
current=3
for (i in 3:ncol(df_S)){
  if(var2[i]<0.06){
    new_df=cbind(new_df,df_S[,i])
    colnames(new_df)[current]=colnames(df_S[i])
      current=current+1
  }
}
ncol(new_df)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
model1 <- lda(type~., new_df[-1])

model2 <- qda(type~., new_df[-1])


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pred = predict(model1,type="response")
t = confusionMatrix(as.factor(pred$class), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df = new_df%>%
  mutate(id=row_number())

new_df$type = factor(new_df$type,labels=c(0,1))
training = new_df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(new_df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)

model1 = lda(type~.,training[-1])

probs <- predict(model1, newdata = testing,type="category")

t = confusionMatrix(as.factor(probs$class), reference=as.factor(testing$type))
t
new_df=new_df[-ncol(new_df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "repeatedcv",
                            number = 10, repeats = 3)

model <- train(type ~., new_df[-1],
			method = "lda",
			trControl = train_control)
 

print(model)



## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "loocv")

model <- train(type ~., new_df[-1],
			method = "lda",
			trControl = train_control)
 

print(model)



## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
roc_lda = roc(response = as.vector(testing$type), predictor = as.vector(probs$posterior[,2]))
auc(roc_lda)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pred = predict(model2,type="response")
pred$class=factor(pred$class,labels=c(0,1))
t = confusionMatrix(as.factor(pred$class), reference=as.factor(new_df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df = new_df%>%
  mutate(id=row_number())

new_df$type = factor(new_df$type,labels=c(0,1))
training = new_df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(new_df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)

model2 = qda(type~.,training[-1])

probs <- predict(model2, newdata = testing,type="category")

t = confusionMatrix(as.factor(probs$class), reference=as.factor(testing$type))
t
new_df=new_df[-ncol(new_df)]

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "repeatedcv",
                            number = 5, repeats = 3)

model <- train(type ~., new_df[-1],
			method = "qda",
			trControl = train_control)
 

print(model)



## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "loocv")

model <- train(type ~., new_df[-1],
			method = "qda",
			trControl = train_control)
 

print(model)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
roc_qda = roc(response = testing$type, predictor = probs$posterior[,2])
auc(roc_qda)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

ggroc(list(lda=roc_lda, qda=roc_qda))