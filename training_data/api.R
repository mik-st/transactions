
# you need to trigger this file using the trigger_api.Rmd file


rm(list = ls())

library(openxlsx)
library(caret)
library(nnet)         # for multinom
library(randomForest) # for random forest
library(rpart)        # for decision tree
library(class)        # for KNN
library(randomForest)
library(caret)
library(xgboost)
library(pROC)
library(MLmetrics)
library(dplyr)
library(ranger)





# Read the Excel file
df <- read.xlsx("ai_traininig_df_final.xlsx", sheet = 1) 
 
country_levels <- levels( as.factor( df$country))

education_levels <- levels(as.factor( df$education_level))
profession_levels = levels (as.factor( df$profession))

library(plumber)

# Load models when API starts
m1 <- readRDS("m1.rds")
m4 <- readRDS("m4.rds")
m5 <- readRDS("m5.rds")
m6 <- readRDS("m6.rds")
m7 <- readRDS("m7.rds")
m8<- readRDS("m8.rds")
 



 
# Predict with Random Forest
#* @post /predict_m1
function(  age= 65, gender='male' , country='Germany') {
  input_data =   data.frame(age=as.integer(age), 
             gender=  factor(gender , levels=c('male','female'))   ,
             country =  factor(country , levels= country_levels ) )
  pred <- predict(m1,   input_data)
  return( (pred[1]))
}

#
#
#* @post /predict_m4
function(  age= 65, gender="male" , country='Germany', profession='Architect') {
  print(  profession %in% profession_levels )
   
  input_data =data.frame(age=as.integer(age), 
                         gender=  factor(gender , levels=c('male','female'))   ,
                         country =  factor(country , levels= country_levels ) ,
                         profession =factor( profession  , levels= profession_levels ) )
  
  pred <- predict(m4,  input_data)
  return( (pred[1]))
}


#* @post /predict_m5
function(  age= 65, gender ='male', country='Germany', profession='Electrical Engineer', years_experience=10) {
  
  input_data <- data.frame(
    age = as.numeric(age),
    gender = gender,
    country = country,
    profession = profession,
                        years_experience = as.integer(years_experience)                  
                        )
  
  pred <- predict(m5 ,  data=input_data)
  return( (pred[1]))
}

 

#* @post /predict_m6
function(    gender='male' , country='Germany', profession='Electrical Engineer', years_experience=10) {
  
  input_data <- data.frame(
     
    gender = gender,
    country = country,
    profession =  profession,
    years_experience = as.integer(years_experience)                  
  )
  
  pred <- predict(m6 ,  newdata=input_data)
  return( (pred[1]))
}


  

#* @post /predict_m7
function(   salary_eur,working,education_level='Postgraduate', gender='male' , country='Germany', profession='Electrical Engineer', years_experience=10) {
  
  input_data <- data.frame(
    salary_eur = as.integer(salary_eur) ,
    working =working,
    education_level = education_level ,
    gender =gender,
    country =  country,
    profession = profession,
    years_experience = as.integer(years_experience)                  
  )
  
  pred <- predict(m7 ,  newdata=input_data)
  return( (pred[1]))
}

 
#* @post /predict_m8
function(   balance_eur=20000,working='1',education_level='Postgraduate', gender ='male', country='Germany', profession='Electrical Engineer' ) {
  
  input_data <- data.frame(
    balance_eur = as.integer(balance_eur) ,
    working =working,
    education_level =education_level,
    gender = gender,
    country = country,
    profession = profession
    # years_experience = as.integer(years_experience)                  
  )
  
  pred <- predict(m8,   data=input_data)
  return( (pred[1]))
}







 