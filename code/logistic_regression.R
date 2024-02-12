mut_df$type = as.factor(mut_df$type)
unique(mut_df$type)
model1 = glm(type~.,mut_df[-1],family=binomial())
summary(model1)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df = mut_df[-29]
mut_df = mut_df[-24]
mut_df = mut_df[-22]
mut_df = mut_df[-21]
mut_df=mut_df[-3]
mut_df$type = as.factor(mut_df$type)
model2 = glm(type~.,mut_df[-1],family=binomial())
summary(model2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
model2 = glm(type~X205695_at +X207608_x_at+X206727_at+X214677_x_at+X206561_s_at+X220491_at+X209614_at+X207201_s_at+X206727_at,mut_df[-1],family=binomial())
summary(model2)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
model3 = glm(type~X205695_at +X214677_x_at+X209614_at+X206561_s_at+X220491_at,mut_df[-1],family=binomial())
summary(model3)


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
mut_df %>% ggplot()+
   geom_density(aes(mut_df$X205695_at,group=type,fill=type,alpha=0.5))
mut_df %>% ggplot()+
   geom_density(aes(mut_df$X214677_x_at,group=type,fill=type,alpha=0.5))
mut_df %>% ggplot()+
   geom_density(aes(mut_df$X209614_at,group=type,fill=type,alpha=0.5))
mut_df %>% ggplot()+
   geom_density(aes(mut_df$X220491_at,group=type,fill=type,alpha=0.5))
mut_df %>% ggplot()+
   geom_density(aes(mut_df$X206561_s_at,group=type,fill=type,alpha=0.5))


## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
probs <- predict(model3, type = "response")
contrasts(mut_df$type)

pred <- rep("HCC",nrow(mut_df))
pred[probs > 0.5] <- "normal"
t = confusionMatrix(as.factor(pred), reference=as.factor(mut_df$type))
t
