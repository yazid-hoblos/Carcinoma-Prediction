library(dplyr)
library(leaps)
library(caret)
library(ggplot2)
library(pROC)
library(MASS)
require(nnet)
library(glmnet)

df = read.csv("Liver cancer.csv")
View(df)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df %>% ggplot()+
  geom_bar(aes(type,fill=type))


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df_S = df
df_S[3:ncol(df_S)] <-  scale(df_S[3:ncol(df_S)],center = TRUE, scale = TRUE)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df_M = df[1:2]
normalize <- function(x, na.rm = TRUE) {
    return((x- min(x)) /(max(x)-min(x)))
}

df_M [3:ncol(df)] = lapply(df[3:ncol(df)], normalize)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df_R = df[1:2]
robust_scalar<- function(x){(x- median(x)) /(quantile(x,probs = .75)-quantile(x,probs = .25))}
df_R[3:ncol(df)] = lapply(df[3:ncol(df)], robust_scalar)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
summary(df[1:10])
summary(df_S[1:10])
summary(df_M[1:10])
summary(df_R[1:10])


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df)){
  var[i] = var(df[,i]) #overall variance
  var1[i] = var(df[1:181,i]) #variance over HCC cases
  var2[i] = var(df[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
v=cbind(var,var1,var2)
as.data.frame(v) %>% ggplot()+
  geom_density(aes(var),fill='blue',alpha=0.4)+
  geom_density(aes(var1),fill='red',alpha=0.4)+
  geom_density(aes(var2),fill='green',alpha=0.4)

as.data.frame(v) %>% ggplot()+
  geom_density(aes(var),fill='blue')
as.data.frame(v) %>% ggplot()+
   geom_density(aes(var1),fill='red')
as.data.frame(v) %>% ggplot()+
  geom_density(aes(var2),fill='green')
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
boxplot(v[,1:3],col=c('blue','red','green'),names=c('overall var','HCC var', 'Normal var'))
as.data.frame(v) %>% ggplot()+
  geom_boxplot(aes(var),fill='blue')+
  geom_boxplot(aes(var1),fill='red')+
  geom_boxplot(aes(var2),fill='green')


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
count=0
for (i in 3:ncol(df)){
  if(var(df[i])>6){
    count=count+1
  }
}
count


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for (i in 3:ncol(df)){
  if(var(df[i])>6){
  print(colnames(df)[i])
  print(var[i])
  print(var1[i])
  print(var2[i])
  print("")
  }
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df=df[1:2]
current=3
for (i in 3:ncol(df)){
  if(var(df[i])>6){
    mut_df=cbind(mut_df,df[,i])
    colnames(mut_df)[current]=colnames(df[i])
      current=current+1
  }
}
ncol(mut_df)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
for(i in 3:29){
  print(mut_df %>% ggplot()+
   geom_density(aes(mut_df[,i],group=type,fill=type,alpha=0.5))+
    labs(y='density',x=colnames(df)[i]) )
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pairs(mut_df[3:20])
pairs(mut_df[21:29])









