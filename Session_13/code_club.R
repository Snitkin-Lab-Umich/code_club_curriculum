#install.packages("tidyverse")
library(tidyverse)

source("read_matrix.R")
#MATRIX
#matrix
dist_matrix <- read_matrix("mice_simple.braycurtis.dist")
dist_matrix
str(dist_matrix)
#matrix[row number,column number]
dist_matrix[1,]
dist_matrix[,1]
dist_matrix[1,1]
dist_matrix[1]
#matrix[row name,column name]
dist_matrix['F3D11',]
dist_matrix[,'F3D125']
dist_matrix['F3D11','F3D125']

#distance matrix
dist_dist <- as.dist(dist_matrix)
dist_dist
str(dist_dist)
#matrix[name] is not work in distance matrix
dist_dist['F3D11',]
dist_dist[,'F3D125']
dist_dist['F3D11']
#matrix[number] work in distance matrix but the result is different.
dist_dist[1]
dist_dist[5]
#however, add comma before or after number, also not work.
dist_dist[1,]
dist_dist[,1]

#DATAFRAME
#A list of vectors where all the vectors are the same length and the position
#in each vector corresponds to the same sample.
dist_df <- as.data.frame(dist_matrix)
dist_df 
str(dist_df)
#Can use '$' to select a list in the data frame
#dataframe$list
dist_df$F3D11
#Not work in matrix
dist_matrix$F3D11
#matrix[row name,column name] also work in data frame
dist_df['F3D11',]
dist_df[,'F3D11']
#Two other way to select a specific list from data frame
dist_df[['F3D11']]
dist_df['F3D11']
#Ways to add a column at the end of data frame:
samples <- row.names(dist_df)
dist_df$sample1 <- samples
dist_df
dist_df[,'sample2'] <- samples
dist_df
dist_df['sample3'] <- samples
dist_df
dist_df[['sample4']] <- samples
dist_df
#Ways to add a column at the start of data frame:
dist_df <- cbind(samples,dist_df)
dist_df
dist_df <- cbind(row.names(dist_df),dist_df)
dist_df
#Change dataframe column's name when add it
dist_df <- cbind(sample5 = row.names(dist_df), dist_df)
dist_df

#TIBBLE
dist_tbl <- as_tibble(dist_matrix, rowname='samples')
dist_tbl
str(dist_tbl)
#Cannot use tibble[rowname,]
dist_tbl['F3D11',]
#Rest of them are very similar ti data frame
dist_tbl$F3D11
dist_tbl[,'F3D11']
dist_tbl[['F3D11']]
dist_tbl['F3D11']

#Show more rows and columns if the data is huge.
dist_matrix <- read_matrix("mice.braycurtis.dist")
dist_tbl <- as_tibble(dist_matrix, rowname='samples')
dist_tbl
#Show more columns
print(dist_tbl, width=20)
print(dist_tbl, width=200)
print(dist_tbl, width=Inf)
#Show more rows
print(dist_tbl, n=20)
print(dist_tbl, n=200)
print(dist_tbl, n=Inf)
