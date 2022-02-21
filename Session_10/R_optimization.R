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
#Repeats data 15 times
iris<- rbind(iris, iris[rep(1:nrow(iris), 15), ])
#Makes an empty data.frame from current iris dimensions
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
#Try running system.time multiple times
system.time(
  for (i in 1:4){
    centered_mean<-mean(iris[,i])
    print(centered_mean)
    for (j in 1:nrow(iris)){
      iris_n[j,i] <- iris[j,i]/centered_mean
    }
  })

#Bench mark runs through the chunk of code 10 times, and outputs the mean runtime
bench<-bench::mark(
  for (i in 1:4){
    centered_mean<-mean(iris[,i])
    print(centered_mean)
    for (j in 1:nrow(iris)){
      iris_n[j,i] <- iris[j,i]/centered_mean
    }
  }
)

#Profvis provides an interactive output window
profvis(
  for (i in 1:4){
    centered_mean<-mean(iris[,i])
    print(centered_mean)
    for (j in 1:nrow(iris)){
      iris_n[j,i] <- iris[j,i]/centered_mean
    }
  })

#Exercise 1----
'Minimizing nesting loops'
#Try modifying the horrible code to have one less for loop
bench1<- bench::mark(
for (i in nrow(iris)){
  centered_means<-colMeans(iris[,1:4])
  iris_n[i,1:4] <- iris[i,1:4]/centered_means
}
)
#Exercise 2----
'Minimizing assignments within loops and creating them outside of the loops'
#Modify your code from the previous exercise
bench2<- bench::mark({
  centered_means<-colMeans(iris[,1:4])
  for (i in nrow(iris)){
    iris_n[i,1:4] <- iris[i,1:4]/centered_means
  }
})
#Exercise 3----
'Vectorizing code'
#Don't use for-loops at all
bench3.1<- bench::mark({
iris_n[,1] <- iris[,1]/centered_means[1]
iris_n[,2] <- iris[,2]/centered_means[2]
iris_n[,3] <- iris[,3]/centered_means[3]
iris_n[,4] <- iris[,4]/centered_means[4]
})
#Or
bench3.2<- bench::mark({
  iris_n[,1:4] <- iris[,1:4]/centered_means
})

#Exercise 4----
'Utilizing the apply and sweep function'
#Don't use for-loops
iris_n[,1:4]<-sweep(iris[,1:4], MARGIN = 2, STATS= colMeans(iris[,1:4]), FUN = '/')


#Exercise 5----
'Changing functions'
#Other parts of your code can be optimized, such as loading in code, and applying different functions
'read_csv v.s read.csv'

'pivot v.s melt'
