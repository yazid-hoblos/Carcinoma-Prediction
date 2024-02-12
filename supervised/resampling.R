mut_df = mut_df%>%
  mutate(id=row_number())

set.seed(123,sample.kind='Rejection') 

training = mut_df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(mut_df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)

model3 = glm(type~.,training[-1],family=binomial())

probs <- predict(model3, newdata = testing,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs > 0.5] <- "normal"

t = confusionMatrix(as.factor(pred), reference=as.factor(testing$type))
t
mut_df=mut_df[-ncol(mut_df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_M = mut_df[1:2]
mut_df_M [3:ncol(mut_df)] = lapply(mut_df[3:ncol(mut_df)], normalize)
ncol(mut_df_M)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for(i in 3:24){
  print(mut_df_M %>% ggplot()+
   geom_density(aes(mut_df_M[,i],group=type,fill=type,alpha=0.5))+
    labs(y='density',x=colnames(mut_df_M)[i]) )
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_M$type = as.factor(mut_df_M$type)
model = glm(type~.,mut_df_M[-1],family=binomial())
summary(model)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_S=mut_df
mut_df_S[3:ncol(mut_df_S)] <-  scale(mut_df_S[3:ncol(mut_df_S)],center = TRUE, scale = TRUE)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for(i in 3:24){
  print(mut_df_S %>% ggplot()+
   geom_density(aes(mut_df_S[,i],group=type,fill=type,alpha=0.5))+
    labs(y='density',x=i) )
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_S$type = as.factor(mut_df_S$type)
model = glm(type~.,mut_df_S[-1],family=binomial())
summary(model)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df$type=as.factor(df$type)
mod = glm(df$type~.,df[-1][1:10],family=binomial())
summary(mod)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df$type=as.factor(df$type)
m = glm(df$type~.,df[-1][1:80],family=binomial())
summary(m)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df = df%>%
  mutate(id=row_number())

df$type=as.factor(df$type)
mod = glm(df$type~.,df[-1][ncol(df)-1],family=binomial())
summary(mod)
df = df[-ncol(df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(m, type = "response")
contrasts(df$type)

pred <- rep("HCC",nrow(df))
pred[probs > 0.5] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(mut_df$type))
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

m = glm(type~.,training[-1][1:80],family=binomial())

probs <- predict(m, newdata = testing,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs > 0.5] <- "normal"

t = confusionMatrix(as.factor(pred), reference=as.factor(testing$type))
t
df = df[-ncol(df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df_S)){
  var[i] = var(df_S[,i]) #overall variance
  var1[i] = var(df_S[1:181,i]) #variance over HCC cases
  var2[i] = var(df_S[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
as.data.frame(v) %>% ggplot()+
  geom_density(aes(var1),fill='red',alpha=0.4)+
  geom_density(aes(var2),fill='green',alpha=0.4)

max=0
for (i in var){
  if(i>max){
    max=i
  }
}
print(max)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(var1~var2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
boxplot(v[-1:-2,],col=c('blue','red','green'),names=c('overall var','HCC var', 'Normal var'))
as.data.frame(v[-1:-2,]) %>% ggplot()+
  geom_boxplot(aes(var),fill='blue',alpha=0.6)+
  geom_boxplot(aes(var1),fill='red',alpha=0.6)+
  geom_boxplot(aes(var2),fill='green',alpha=0.6)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df)){
  var[i] = var(df_M[,i]) #overall variance
  var1[i] = var(df_M[1:181,i]) #variance over HCC cases
  var2[i] = var(df_M[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(var1~var2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
as.data.frame(v) %>% ggplot()+
  geom_density(aes(var),fill='blue',alpha=0.4)+
  geom_density(aes(var1),fill='red',alpha=0.4)+
  geom_density(aes(var2),fill='green',alpha=0.4)

max=0
for (i in var){
  if(i>max){
    max=i
  }
}
print(max)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
boxplot(v[-1:-2,],col=c('blue','red','green'),names=c('overall var','HCC var', 'Normal var'))
as.data.frame(v[-1:-2,]) %>% ggplot()+
  geom_boxplot(aes(var),fill='blue',alpha=0.6)+
  geom_boxplot(aes(var1),fill='red',alpha=0.6)+
  geom_boxplot(aes(var2),fill='green',alpha=0.6)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df_R)){
  var[i] = var(df_R[,i]) #overall variance
  var1[i] = var(df_R[1:181,i]) #variance over HCC cases
  var2[i] = var(df_R[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(var1~var2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
as.data.frame(v) %>% ggplot()+
  geom_density(aes(var),fill='blue',alpha=0.4)+
  geom_density(aes(var1),fill='red',alpha=0.4)+
  geom_density(aes(var2),fill='green',alpha=0.4)

max=0
for (i in var){
  if(i>max){
    max=i
  }
}
print(max)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
boxplot(v[-1:-2,],col=c('blue','red','green'),names=c('overall var','HCC var', 'Normal var'))
as.data.frame(v[-1:-2,]) %>% ggplot()+
  geom_boxplot(aes(var),fill='blue',alpha=0.6)+
  geom_boxplot(aes(var1),fill='red',alpha=0.6)+
  geom_boxplot(aes(var2),fill='green',alpha=0.6)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for(i in 1:length(var)){
  if (var[i]>40){
    print(colnames(df)[i])
  }
}
df %>% ggplot()+
  geom_density(aes(X214218_s_at,fill=type),df)
ggplot(aes(df$X214218_s_at),fill=type)+geom_density()


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df = mut_df%>%
  mutate(id=row_number())

set.seed(123,sample.kind='Rejection') 

training = mut_df%>%
  slice_sample(prop=0.7)
nrow(training)

testing = anti_join(mut_df,training,by='id')
nrow(testing)

training = training%>%
  dplyr::select(-id)
testing = testing%>%
  dplyr::select(-id)

model = glm(type~.,training[-1],family=binomial())

probs <- predict(model, newdata = testing,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs > 0.5] <- "normal"

t = confusionMatrix(as.factor(pred), reference=as.factor(testing$type))
t
mut_df=mut_df[-ncol(mut_df)]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

train_control <- trainControl(method = "LOOCV")

model <- train(type ~., mut_df[-1],
			method = "glm",
			trControl = train_control)

print(model)



## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "cv",
                              number = 10)
 
model <- train(type ~., mut_df[-1],
			method = "glm",
			trControl = train_control)
 

print(model)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "repeatedcv",
                            number = 10, repeats = 3)

model <- train(type ~., mut_df[-1],
			method = "glm",
			trControl = train_control)
 

print(model)
