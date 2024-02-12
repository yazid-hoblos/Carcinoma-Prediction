step.model <- stepAIC(mod, direction = "both", 
                      trace = FALSE)
summary(step.model)


