#Libraries----
#install.packages("profvis")
#install.packages("bench")
#install.packages("tidyverse")
#install.packages("reshape2")
library(profvis)
library(bench)
library(tidyverse)
library(reshape2)

#Load data----
iris<- read.csv('~/code_club_curriculum/Session_1X/iris.csv')
iris<- rbind(iris, iris[rep(1:nrow(iris), 15), ])
iris_n<-data.frame(matrix(NA, nrow = nrow(iris), ncol = ncol(iris)))

#Revisit For-loops
'For-Loops are used to repeat a specific block of code.
Sample Syntax of a for-loop:
for (val in sequence){
statement
}
'
#Example 1 for-loop
x <- c(2,5,3,9,8,11,6)
for (val in x) {
  print(val)
}

#Example 2 for-loop
x <- 'ACTGCAGTAAA'
for (val in x) {
  print(val)
}

#Example 3 for-loop
x <- strsplit('ACTGCAGTAAA',split = "")[[1]]
for (val in x) {
  print(val)
}




#Available Time Benchmarks
'system.time- built in function
profvis- must install
bench- must install'

#Horrible Code example----
#Divides each individual observation by their respective column mean
for (i in 1:4){
  centered_mean<-mean(iris[,i])
  print(centered_mean)
  for (j in 1:nrow(iris)){
    iris_n[j,i] <- iris[j,i]/centered_mean
  }
}

#Running each benchark
system.time(
for (i in 1:4){
  centered_mean<-mean(iris[,i])
  #print(centered_mean)
  for (j in 1:nrow(iris)){
    iris_n[j,i] <- iris[j,i]/centered_mean
  }
})

bench<-bench::mark(
for (i in 1:4){
  centered_mean<-mean(iris[,i])
  #print(centered_mean)
  for (j in 1:nrow(iris)){
    iris_n[j,i] <- iris[j,i]/centered_mean
  }
})

profvis(
for (i in 1:4){
  centered_mean<-mean(iris[,i])
  #print(centered_mean)
  for (j in 1:nrow(iris)){
    iris_n[j,i] <- iris[j,i]/centered_mean
  }
})

#Exercise 1----
'Minimizing nesting loops'
bench1<-bench::mark({
for (i in 1:4){
  centered_mean<-mean(iris[,i])
  iris_n[,i] <- iris[,i]/centered_mean
}})

#Exercise 2----
'Minimizing assignments within loops and creating them outside of the loops'
bench2<-bench::mark({
centered_mean<-colMeans(iris[,1:4])
for (i in 1:4){
  iris_n[,i] <- iris[,i]/centered_mean[i]
}})

#Exercise 3----
'Utilizing the apply and sweep function'
bench4<-bench::mark({
  centered_mean<-apply(iris_n[,1:4],2,mean)
  iris_n[,1:4] <- sweep(iris_n[,1:4], 2, centered_mean,"/")
})


#Exercise 4----
'Vectorizing code'
bench3.1<-bench::mark({
iris_n[,1]<- iris[,1]/centered_mean[1]
iris_n[,2]<- iris[,2]/centered_mean[2]
iris_n[,3]<- iris[,3]/centered_mean[3]
iris_n[,4]<- iris[,4]/centered_mean[4]
})

bench3.2<-bench::mark({
  centered_mean<-colMeans(iris[,1:4])
  iris_n[1:4]<- iris[1:4]/centered_mean

})

#Exercise 5----
'Changing functions'
'read_csv v.s read.csv'
bench5.1<-bench::mark({
  iris<- read_csv('~/code_club_curriculum/Session_1X/iris.csv')
})
bench5.2<-bench::mark({
  iris<- read.csv('~/code_club_curriculum/Session_1X/iris.csv')
})

'pivot v.s melt'
bench5.3<-bench::mark({
  pivot_longer(iris,1:4)
})

bench5.4<-bench::mark({
  melt(iris)
})



