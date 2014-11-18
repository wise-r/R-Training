# Answer for Assignment 03

With some acquaintance of the basic data structures in the R language, you can start to work with real data. This assignment aims to guide you to notice the different aspects of issues in data management and manipulation.

## Subsetting

1. On which objects one can perform `[` operation? How about `[[`? Are they functions in R? What's the difference between the two? In what cases they can be used interchangeably? In what cases they cannot be used interchangeably? In what cases they might easily be confused with one another? How to avoid these possible confusions?

**Notes:** We can operate `[` to subset all objects except functions. But if the elements of objects have multiple types, `[[` can be used to extract the 'value' instead the sublist of a list. What needs notice is that although dataframe is a special case of list, but since all columns are required to have same length just like the characteristic of a matrix, hence all subsetting methods which are worked for matrix are appropriate for dataframes. To avoid confusion on dataframe, we can use `$` in place of `[[` when we extract values.


2. When assignment expressions such as `x[1] <- 5` are evaluated, what function is actually called upon `x`? Answer similar questions in `1`.

**Notes:** 

```r
vector<-1:8  # for a vector
vector[1]<-5 #change the first element to 5
vector
```

```
## [1] 5 2 3 4 5 6 7 8
```

```r
martix<-matrix(1:8,2,4) #for a matrix
martix[1]<-5 #change the matrix[1,1] into 5 
martix
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    5    3    5    7
## [2,]    2    4    6    8
```

```r
array<-array(1:24,c(2,6,2)) #for an array
array[1]<-5 #change the array[1,1,1] into 5
array
```

```
## , , 1
## 
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]    5    3    5    7    9   11
## [2,]    2    4    6    8   10   12
## 
## , , 2
## 
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]   13   15   17   19   21   23
## [2,]   14   16   18   20   22   24
```

```r
########            case for dataframe and list              #######
dataframe<-data.frame(x=c("cat","dog"),y=c(1,1),z=c(FALSE, TRUE),d=c(Sys.time(),as.POSIXct(strptime("1991-06-28 05:30:00",'%Y-%m-%d %H:%M:%S')))) # for a dataframe
dataframe[1]<-5  #change the dataframe$x into 5 
```

3. Compare `subset` function in `base` and data-manipulation functions such as `select` and `filter` in `dplyr` in terms of their usage, syntax, performance, etc. 

```r
########          subset function in base package           ########
#subset(dataframe,`condition` for filter row, select=c(columns names))
subset(dataframe, z==FALSE, select=c(x,d))
```

```
##   x                   d
## 1 5 2014-11-18 06:43:31
```

```r
########        select and filter in dplyr package          ########
#filter extracts the elements of a vector for which a predicate (logical) function gives true.
library(dplyr)
df.test<-data.frame(x=1:4,y=c("one","two","three","four"),z=c("good","fine","pass","fail"))
filter(df.test,x>=3)
```

```
##   x     y    z
## 1 3 three pass
## 2 4  four fail
```

```r
#select the corresponding columns
select(df.test,x,y)
```

```
##   x     y
## 1 1   one
## 2 2   two
## 3 3 three
## 4 4  four
```
I believe the major advantage of `dplyr` package is ''Using efficient data storage backends, so that you spend as little time waiting for the computer as possible.''

4. Investigate the usage of subsetting operation on `data.table`. Compare the subsetting facilities in `data.table` with data-manipulation functions in `dplyr` in terms of their usage, syntax, performance, etc. Furthermore, compare the subsetting operations in `base`, `data.table`, `dplyr` with SQL provided by `sqldf`. What are those things that can be easily done using one package yet hard using another package?

```r
#########                using data.table                  ##########
library(data.table)
DT<-data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=runif(9))
#subsetting rows
DT[2,]
```

```
##          x y      z
## 1: 0.02852 a 0.4333
```

```r
DT[DT$y=="a",]
```

```
##          x y      z
## 1: 0.19896 a 0.2474
## 2: 0.02852 a 0.4333
## 3: 0.99161 a 0.6532
```

```r
DT[c(2,3)]
```

```
##          x y      z
## 1: 0.02852 a 0.4333
## 2: 0.99161 a 0.6532
```

```r
#calculating values for variables with expression
DT[,list(mean(x),sum(z))]
```

```
##        V1    V2
## 1: -0.122 4.176
```

```r
#adding new columns
DT[,w:=z^2]
```

```
##           x y       z        w
## 1:  0.19896 a 0.24744 0.061226
## 2:  0.02852 a 0.43328 0.187728
## 3:  0.99161 a 0.65316 0.426613
## 4: -0.77114 b 0.30006 0.090038
## 5: -1.40753 b 0.05157 0.002659
## 6: -0.60739 b 0.61256 0.375236
## 7: -0.06047 c 0.61290 0.375643
## 8: -1.13220 c 0.58700 0.344573
## 9:  1.66201 c 0.67807 0.459779
```

```r
#multiple operations
DT[,m:={temp<-(x+z);log2(temp+5)}]
```

```
##           x y       z        w     m
## 1:  0.19896 a 0.24744 0.061226 2.445
## 2:  0.02852 a 0.43328 0.187728 2.449
## 3:  0.99161 a 0.65316 0.426613 2.732
## 4: -0.77114 b 0.30006 0.090038 2.179
## 5: -1.40753 b 0.05157 0.002659 1.866
## 6: -0.60739 b 0.61256 0.375236 2.323
## 7: -0.06047 c 0.61290 0.375643 2.473
## 8: -1.13220 c 0.58700 0.344573 2.155
## 9:  1.66201 c 0.67807 0.459779 2.876
```

```r
#plyr like operations
DT[,a:=x>0]
```

```
##           x y       z        w     m     a
## 1:  0.19896 a 0.24744 0.061226 2.445  TRUE
## 2:  0.02852 a 0.43328 0.187728 2.449  TRUE
## 3:  0.99161 a 0.65316 0.426613 2.732  TRUE
## 4: -0.77114 b 0.30006 0.090038 2.179 FALSE
## 5: -1.40753 b 0.05157 0.002659 1.866 FALSE
## 6: -0.60739 b 0.61256 0.375236 2.323 FALSE
## 7: -0.06047 c 0.61290 0.375643 2.473 FALSE
## 8: -1.13220 c 0.58700 0.344573 2.155 FALSE
## 9:  1.66201 c 0.67807 0.459779 2.876  TRUE
```

```r
DT[,b:=mean(x+w),by=a]
```

```
##           x y       z        w     m     a       b
## 1:  0.19896 a 0.24744 0.061226 2.445  TRUE  1.0041
## 2:  0.02852 a 0.43328 0.187728 2.449  TRUE  1.0041
## 3:  0.99161 a 0.65316 0.426613 2.732  TRUE  1.0041
## 4: -0.77114 b 0.30006 0.090038 2.179 FALSE -0.5581
## 5: -1.40753 b 0.05157 0.002659 1.866 FALSE -0.5581
## 6: -0.60739 b 0.61256 0.375236 2.323 FALSE -0.5581
## 7: -0.06047 c 0.61290 0.375643 2.473 FALSE -0.5581
## 8: -1.13220 c 0.58700 0.344573 2.155 FALSE -0.5581
## 9:  1.66201 c 0.67807 0.459779 2.876  TRUE  1.0041
```

```r
#count the number of each elememt in a variable
DTcount<-data.table(x=sample(letters[1:3],1E4,TRUE))
DTcount[,.N,by=x]
```

```
##    x    N
## 1: c 3388
## 2: b 3255
## 3: a 3357
```

```r
#grouping by "Keys"
DTkey<-data.table(x=rep(c("a","b","c"),each=100),y=rnorm(300))
setkey(DTkey,x)
head(DTkey['a'])
```

```
##    x       y
## 1: a -0.5249
## 2: a  0.9337
## 3: a -0.5233
## 4: a -1.0427
## 5: a -1.4877
## 6: a -0.4912
```

```r
#joins
DTjoin1<-data.table(x=c("a","a","b","1"),y=1:4)
DTjoin2<-data.table(x=c("a","b","2"),z=5:7)
setkey(DTjoin1,x)
setkey(DTjoin2,x)
merge(DTjoin1,DTjoin2)
```

```
##    x y z
## 1: a 1 5
## 2: a 2 5
## 3: b 3 6
```
There are several advantages using `data.table` format.

1.  all function that accept `data.frame` work on `data.table`.
2.  written in C so it is much faster
3.  much faster in subsetting group and updating.

**Notes:** Since I have little knowledge about Structured Query Language, there is a long way to go for mastering its uasge in different systems, say `base`, `data.table`, `dplyr`. I sincerely invite instructor to give a lecture about this.


## Missing Values

1. Do missing values usually arise in your working scenario? If so, what are the typical methods of dealing with them? What are the implicit assumptions that you actually impose when you use each of them? What are the advantages and disadvantages of each of these methods? 

**Notes:**  Before we analyze data, we usually need to get and clear data at first. In reality, the samples we collect often have missing value. Here is some skills to deal with the missing value.

    read.table("file",na.strings = "NA")      #definite the missing value  
    good<-complete.cases(object1,object2)     #select the sample which are complete   
    object1[good]                              #both in object1 and object2.  
    object2[good]         
    na.omit(object)     #remove the rows which have missing value    
    na.locf(object)     #Generic function for replacing each NA with the most recent non-NA prior to it 
      `fromLast`     which substitutes the missing value with the most recent non-NA after it.

When we omit the missing values, we discard some information in data. If the data has limited size, perhaps we should replace the missing values with the mean or median calculated by the non-missing value of this variable.

2. Try all `NA`-related methods such as `na.omit` in `stats` and `na.locf` in `zoo`, and consider the cases where each method might be appropriate.

In my opinion, if the missing data only account for a little percent of the whole sample size, such as 5% data is missing, then we can use `na.omit` to ignore these part of sample. But if the missing part is comparatively large and it may result in a bias when we just omit these part of sample, we should inplement a reasonale method to fix these uncompleted sample data.
 
3. Model-based methods such as `Expectation - Maximization algorithm` are sometimes powerful when appropriately used. Investigate the basic idea and methodology behind this algorithm.

**Notes:** Here is the link to a instruction of [`EM algorithm`](http://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) on wiki.

Based on my understanding, `EM algorithm` is a iterated algorithm which transforms the question of maximizing the log-likelihood function to a queation of maximizing  expected value of the log likelihood function, with respect to the conditional distribution of latend variables **Z**(a set of unobserved latent data or missing values) given sample data under the current estimate of the parameters in every interated E step. And in M step, the algorithm find the paramter that maximizes the objective function obtained in the E step.  
The main difference between EM algorithm and the optimization algorithms based on Gradient descent method is that the gradient descent method require the evalution of first and second derivatives of the likelihood function.


4. In various cases, data-driven methods have better performance than model-based methods in dealing with missing values. Study the `Collaborative Filtering algorithm`, whose vairants are widely used in `Recommendation Systems`, and try to explain why this algorithm might lead to better recommendations for users than other algorithms that attempt to statistically model the purchasing behavior of users. 

**Notes:** Here is the link to a instruction of [`Collaborative Filtering algorithm`](http://en.wikipedia.org/wiki/Collaborative_filtering) on wiki.

In general sense, collaborative filtering is the process of filtering for information or patterns using techniques involving collaboration among multiple agents, viewpoints, data sources, etc. In the newer, narrower sense, collaborative filtering is a method of making automatic predictions (filtering) about the interests of a user by collecting preferences or taste information from many users (collaborating).   
The motivation for collaborative filtering comes from the idea that people often get the best recommendations from someone with similar tastes to themselves. Collaborative filtering explores techniques for matching people with similar interests and making recommendations on this basis. Collaborative filtering systems have many forms, but many common systems can be reduced to two steps:

1. Look for users who share the same rating patterns with the active user (the user whom the prediction is for).
2. Use the ratings from those like-minded users found in step 1 to calculate a prediction for the active user.

The specific algorithms are often based on some data mining models,machine learning algorithms to find patterns based on training data.


## Data Import/Export

1. When dealing with a large `csv` file (possibly > 1GB), `read.csv` is very slow. Try `fread` in `data.table` and compare the usage and performance between the two functions. Are these functions equivalent in terms of their functionality? That is, is the functionality of `fread` a superset of `read.csv` under all circumstances? 

**Notes:** Similar to read.table but faster and more convenient. All controls such as sep, colClasses and nrows are automatically detected. Comparison about the speed between them is given in the following instance.

```r
big.df<-data.frame(x=rnorm(1E6),y=rnorm(1E6))
file<-tempfile()
write.csv(big.df,file=file,row.names=FALSE,sep="\t",quote=FALSE)
```

```
## Warning: attempt to set 'sep' ignored
```

```r
system.time(fread(file))
```

```
##    user  system elapsed 
##   0.450   0.014   0.466
```

```r
system.time(read.csv(file,header=TRUE,sep="\t"))
```

```
##    user  system elapsed 
##  21.883   0.165  22.273
```

***Question:*** Is the functionality of `fread` a superset of `read.csv` under all circumstances? 

2. Another way of dealing with large text data is to compress it into `gz` files. Investigate the `gzfile` connection in the R language and try reading and writing compressed text data. Do the same to `RData` using `load` and `save`.


```r
############     reading and writing compressed text data   #################
zz <- gzfile("ex.gz", "w")  #open a connection link to compressed file 'ex.gz','w' denote the mode of open is writing.
cat("TITLE extra line", "2 3 5 7", "", "11 13 17", file = zz, sep = "\n")#write some text into ex.gz
close(zz)#close the connection
readLines(zz <- gzfile("ex.gz"))#read the file-'ex.gz' and print the content on the console
```

```
## [1] "TITLE extra line" "2 3 5 7"          ""                
## [4] "11 13 17"
```

```r
close(zz)
unlink("ex.gz")#delete the 'ex.gz' file
############             load and save Rdata                #################
x<-runif(20)
y<- list(a = 1, b = TRUE, c = "oops")
save(x,y,file='xy.Rdata') #save the file,"xy.data"
rm(list=ls()) #remove all objects in global environment
load("xy.Rdata")  #load the xy.Rdata
unlink("xy.Rdata") #delete the xy.Rdata
```
