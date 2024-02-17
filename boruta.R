library(dplyr)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(tidyverse)
library(Boruta)
library(caret)
library(party)
library(randomForest)
library(pROC)
library(remotes)
library(devtools)
library(ggfortify)
library(cli)
library(ggbiplot)
library(e1071)
library(Rfast)
library(kernlab)
library(factoextra)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df = read.csv("Liver Cancer.csv")


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
df$type=as.factor(df$type)
boruta <- Boruta(y=df[,2], x =df[,3:ncol(df)], doTrace = 2, maxRuns = 200)
print(boruta)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
count=1
d = df[2]
for (i in 3:ncol(df)){
  if((as.numeric(boruta$finalDecision[i])==1|| as.numeric(boruta$finalDecision[i])==2 || as.numeric(boruta$finalDecision[i])==3) & count<300){
  count=count+1
  d=cbind(d,df[,i])
  colnames(d)[count]=colnames(df)[i]
  }}
b = Boruta(y=d[,1], x =d[,2:ncol(d)], doTrace = 2, maxRuns = 200)
plot(b,las=2,ces.axis=0.7)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plotImpHistory(boruta)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta.bank <- TentativeRoughFix(boruta)
print(boruta.bank)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
list = getSelectedAttributes(boruta, withTentative = F)
new_df=as.data.frame(df$type)
v=c()
current=2
for (i in 1:ncol(df)){
  for(j in 1:length(list)){
  if(colnames(df)[i]==list[j]){
    new_df=cbind(new_df,df[,i])
    v=cbind(v,colnames(df)[i])
    colnames(new_df)[current]=colnames(df)[i]
    current=current+1
    break
  }
}
}
colnames(new_df)[1]='type'
ncol(new_df)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta2 <- Boruta(y=as.factor(new_df[,1]), x =new_df[,2:ncol(new_df)], doTrace = 2, maxRuns = 200)
print(boruta2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(boruta2,las = 2, cex.axis = 0.7)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
m=glm(type~X218002_s_at,df,family=binomial())
summary(m)
m=glm(type~X209560_s_at,df,family=binomial())
summary(m)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
df %>% ggplot()+
   geom_density(aes(X218002_s_at,group=type,fill=type,alpha=0.5))
df %>% ggplot()+
   geom_density(aes(X220114_s_at,group=type,fill=type,alpha=0.5))
df %>% ggplot()+
   geom_density(aes(X218061_at,group=type,fill=type,alpha=0.5))
df %>% ggplot()+
   geom_density(aes(X220148_at,group=type,fill=type,alpha=0.5))


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
m=glm(type~X220148_at,df,family=binomial())
summary(m)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(m, type = "response")
pred <- rep("HCC",nrow(df))
pred[probs > 0.5] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
m=glm(type~X218002_s_at+X220114_s_at,df,family=binomial())
summary(m)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(m, type = "response")
pred <- rep("HCC",nrow(df))
pred[probs > 0.5] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(df$type))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pairs(new_df[2:20])


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
b_S = Boruta(y=as.factor(df_S[,2]), x =df_S[,3:ncol(df_S)], doTrace = 2, maxRuns = 200)
b_M = Boruta(y=as.factor(df_M[,2]), x =df_M[,3:ncol(df_M)], doTrace = 2, maxRuns = 200)
b_R = Boruta(y=as.factor(df_R[,2]), x =df_R[,3:ncol(df_R)], doTrace = 2, maxRuns = 200)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
print(b_S)
print(b_R)
print(b_M)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Takes as arguments the selected genes vectors of 2 Boruta runs 
common_genes <- function(d1,d2) { #return the fraction of the genes selected as important 2 distinct Boruta runs / max of d1 and d2
  c = 0
  v=c()
  for (i in d1){
    for(j in d2){
      if(i==j){
        c=c+1
        break
      }
    }
    if(j==d2[length(d2)]){ #extract the genes that are not common
      v=cbind(v,i[1])
    }
  }
  return (list((c/min(length(d1),length(d2))),as.list(v)))
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(b_S),getSelectedAttributes(b_M))[1]
common_genes(getSelectedAttributes(b_S),getSelectedAttributes(b_R))[1]
common_genes(getSelectedAttributes(b_R),getSelectedAttributes(b_M))[1]
common_genes(getSelectedAttributes(boruta),getSelectedAttributes(b_R))[1]
common_genes(getSelectedAttributes(boruta),getSelectedAttributes(b_M))[1]
common_genes(getSelectedAttributes(boruta),getSelectedAttributes(b_S))[1]


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
boruta3 <- Boruta(y=as.factor(mut_df[,2]), x =mut_df[,3:ncol(mut_df)], doTrace = 2, maxRuns = 200)
print(boruta3)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(boruta3,las=2,cex.axis=0.7)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(boruta), getSelectedAttributes(boruta3))[1]
common_genes(getSelectedAttributes(boruta2), getSelectedAttributes(boruta3))[1]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df)){
  var[i] = var(df[,i]) #overall variance
  var1[i] = var(df[1:181,i]) #variance over HCC cases
  var2[i] = var(df[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df=df[1:2]
current=3
for (i in 3:ncol(df)){
  if(var[i]>5.2 & var2[i]<1){
    mut_df=cbind(mut_df,df[,i])
    colnames(mut_df)[current]=colnames(df[i])
    current=current+1
  }
}
ncol(mut_df)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta3 <- Boruta(y=as.factor(mut_df[,2]), x =mut_df[,3:ncol(mut_df)], doTrace = 2, maxRuns = 200)
print(boruta3)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(boruta3),getSelectedAttributes(boruta))[1]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df_S)){
  var[i] = var(df_S[,i]) #overall variance
  var1[i] = var(df_S[1:181,i]) #variance over HCC cases
  var2[i] = var(df_S[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df2=df[1:2]
current=3
for (i in 3:ncol(df)){
  if(var1[i]<0.25){
    mut_df2=cbind(mut_df2,df_S[,i])
    colnames(mut_df2)[current]=colnames(df[i])
      current=current+1
  }
}
ncol(mut_df2)

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta4 <- Boruta(y=as.factor(mut_df2[,2]), x =mut_df2[,3:ncol(mut_df2)], doTrace = 2, maxRuns = 200)
print(boruta4)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(boruta4),getSelectedAttributes(boruta))[1]
common_genes(getSelectedAttributes(boruta4),getSelectedAttributes(boruta3))[1]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
var=var1=var2=c(0,0)
for(i in 3:ncol(df)){
  var[i] = var(df_M[,i]) #overall variance
  var1[i] = var(df_M[1:181,i]) #variance over HCC cases
  var2[i] = var(df_M[182:357,i]) #variance over normal patients
}


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_M=df[1:2]
current=3
v2 =c()
for (i in 3:ncol(df)){
  if(var[i]>0.09){
    mut_df_M=cbind(mut_df_M,df_M[,i])
    colnames(mut_df_M)[current]=colnames(df[i])
    v2=cbind(v2,colnames(df_M[i]))
    current=current+1
  }
}
ncol(mut_df_M)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta5 <- Boruta(y=as.factor(mut_df_M[,2]), x =mut_df_M[,3:ncol(mut_df_M)], doTrace = 2, maxRuns = 200)
print(boruta5)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(boruta5),getSelectedAttributes(boruta))[1]
common_genes(getSelectedAttributes(boruta3),getSelectedAttributes(boruta5))[1]


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df_M=df[1:2]
current=3
v2 =c()
for (i in 3:ncol(df)){
  if(var[i]>0.08 & var2[i]<0.02){
    mut_df_M=cbind(mut_df_M,df_M[,i])
    colnames(mut_df_M)[current]=colnames(df[i])
    v2=cbind(v2,colnames(df_M[i]))
    current=current+1
  }
}
ncol(mut_df_M)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
boruta5 <- Boruta(y=as.factor(mut_df_M[,2]), x =mut_df_M[,3:ncol(mut_df_M)], doTrace = 2, maxRuns = 200)
print(boruta5)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
common_genes(getSelectedAttributes(boruta5),getSelectedAttributes(boruta))[1]
common_genes(getSelectedAttributes(boruta3),getSelectedAttributes(boruta5))[1]