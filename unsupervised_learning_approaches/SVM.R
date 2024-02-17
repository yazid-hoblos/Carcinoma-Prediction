new_df$type=factor(new_df$type,labels=c(0,1))

classifier = svm(formula = type ~.,
                 data = new_df,
                 type = 'C-classification',
                 kernel = 'linear',scale=TRUE)
print(classifier)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(classifier, newdata = new_df,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs ==1] <- "normal"
t = confusionMatrix(as.factor(pred), reference=factor(new_df$type,labels=c('HCC','normal')))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df = new_df %>%
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
classifier = svm(formula = type ~.,
                 data = training,
                 type = 'C-classification',
                 kernel = 'linear',scale=TRUE)
probs <- predict(classifier, newdata = testing,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs ==1] <- "normal"
t = confusionMatrix(as.factor(pred), reference=factor(testing$type,labels=c('HCC','normal')))
t

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "repeatedcv")

model <- train(type ~., new_df,
            method = "svmLinear",
            trControl = train_control)

print(model)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
classifier$SV


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
d = as.data.frame(list(new_df$type,new_df$X218002_s_at,new_df$X220114_s_at))
colnames(d)[1]='type'
colnames(d)[2]='gene1'
colnames(d)[3]='gene2'


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
c = svm(type~.,d,cost=2)
length(c$SV)/2 # the number of support vectors
plot(c,d)
c = svm(type~.,d,cost=100)
length(c$SV)/2
plot(c,d)
c = svm(type~.,d,cost=100000000)
length(c$SV)/2
plot(c,d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
kernfit <- ksvm(type~.,data=d, type = "C-svc", C = 10)
plot(kernfit,data=d)
kernfit <- ksvm(type~.,data=d, type = "C-svc", C = 100)
plot(kernfit,data=d)
kernfit <- ksvm(type~.,data=d, type = "C-svc", C = 100000000)
plot(kernfit,data=d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
kernfit <- ksvm(type~.,data=d[1:(nrow(d)-100),], type = "C-svc", C = 2)
plot(kernfit,data=d)
kernfit <- ksvm(type~.,data=d[1:(nrow(d)-99),], type = "C-svc", C = 2)
plot(kernfit,data=d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
kernfit <- ksvm(type~.,data=d[1:(nrow(d)-100),1:3], type = "C-svc", C = 100000000)
plot(kernfit,data=d[1:3])
kernfit <- ksvm(type~.,data=d[1:(nrow(d)-99),1:3], type = "C-svc", C = 100000000)
plot(kernfit,data=d[1:3])


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
tune.out <- tune(svm, type~., data = new_df, kernel = "radial",
                 ranges = list(cost = c(0.1,1,2,5,10,100,1000,10000),
                 gamma = c(0.5,1,2,3,4)))
# show best model
tune.out$best.model


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
new_df = new_df %>%
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
classifierN = svm(formula = type ~.,
                 data = training,
                 type = 'C-classification',
                 kernel = 'radial',scale=TRUE,cost=2)
probs <- predict(classifier, newdata = testing,type='response')
pred <- rep("HCC",nrow(testing))
pred[probs ==1] <- "normal"
t = confusionMatrix(as.factor(pred), reference=factor(testing$type,labels=c('HCC','normal')))
t


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
train_control <- trainControl(method = "repeatedcv")

model <- train(type ~., new_df,
            method = "svmRadial",
            trControl = train_control)

print(model)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pca <- prcomp(new_df[-1],scale=T)
c1 = as.data.frame(get_pca_ind(pca)[1])[1]
c2 = as.data.frame(get_pca_ind(pca)[1])[2]
d = cbind(new_df[1],c1,c2)
colnames(d)[2]='PC1'
colnames(d)[3]='PC2'


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pc = svm(formula = type ~.,
                 data = d,
                 type = 'C-classification',
                 kernel = 'radial',scale=TRUE,cost=2)
plot(pc,d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pc = svm(formula = type ~.,
                 data = d,
                 type = 'C-classification',
                 kernel = 'radial',scale=TRUE,cost=100000)
plot(pc,d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pc = svm(formula = type ~.,
                 data = d,
                 type = 'C-classification',
                 kernel = 'linear',scale=TRUE)
plot(pc,d)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pc = svm(formula = type ~.,
                 data = d,
                 type = 'C-classification',
                 kernel = 'linear',scale=TRUE,cost=100000)
plot(pc,d)
