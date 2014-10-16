# Answer for Assignment 02

Mastery of the R Programming Language and general data-oriented problem solving technics requires in-depth understanding of the data structures and rich experience of manipulation of those building blocks.

## Vectors

1. Define several atomic vectors of different types and lengths, and use `object.size` function to investigate the number of bytes these vector objects take in memory.  

```r
integer.1<-1L
numeric.1<-1
character.1<-"one"
logical.1<-TRUE
list.1<-list(1L,1,"one",TRUE)
list.2<-list(c(1L,2L),c(1,2),rep("one",2),c(TRUE,FALSE))
list.3<-list(rep(1L,3),rep(1,3),rep("three",3),rep(TRUE,3))
list.4<-list(rep(1L,4),rep(1,4),rep("three",4),rep(TRUE,4))
list.5<-list(rep(1L,5),rep(1,5),rep("three",5),rep(TRUE,5))
list.6<-list(rep(1L,6),rep(1,6),rep("three",6),rep(TRUE,6))
```
 the object size corresponding to atomic vectors of different type is:

```r
size.1<-sapply(list.1,object.size)
size.2<-sapply(list.2,object.size)
size.3<-sapply(list.3,object.size)
size.4<-sapply(list.4,object.size)
size.5<-sapply(list.5,object.size)
size.6<-sapply(list.6,object.size)
size.summary<-matrix(rbind(size.1,size.2,size.3,size.4,size.5,size.6),6,4)
rownames(size.summary)<-c("length1","length2","length3","length4","length5","length6")
colnames(size.summary)<-c("integer","numeric","character","logical")
print(size.summary)
```

```
##         integer numeric character logical
## length1      48      48        96      48
## length2      48      56       104      48
## length3      56      72       120      56
## length4      56      72       120      56
## length5      72      88       136      72
## length6      72      88       136      72
```

* How does the object size of logical vector increase as the number of entries of a logical vector increases?  How about numeric vectors?  Why in your opinion do they behave differently?   
**Notes:** It seems that the size of a logical vector increases every two elements. But the size of numeric vector increase in a less order way. My opinion is this needing more test. 

test on how does the size of numeric vector increase

```r
num.size<-apply(matrix(1:100,1,100),2,function(i) object.size(rnorm(i)))
print(num.size)
```

```
##   [1]  48  56  72  72  88  88 104 104 168 168 168 168 168 168 168 168 176
##  [18] 184 192 200 208 216 224 232 240 248 256 264 272 280 288 296 304 312
##  [35] 320 328 336 344 352 360 368 376 384 392 400 408 416 424 432 440 448
##  [52] 456 464 472 480 488 496 504 512 520 528 536 544 552 560 568 576 584
##  [69] 592 600 608 616 624 632 640 648 656 664 672 680 688 696 704 712 720
##  [86] 728 736 744 752 760 768 776 784 792 800 808 816 824 832 840
```
test on how does the size of logical  vector increase

```r
logi.size<-apply(matrix(1:100,1,100),2,function(i) object.size(rep(TRUE,i)))
print(logi.size)
```

```
##   [1]  48  48  56  56  72  72  72  72  88  88  88  88 104 104 104 104 168
##  [18] 168 168 168 168 168 168 168 168 168 168 168 168 168 168 168 176 176
##  [35] 184 184 192 192 200 200 208 208 216 216 224 224 232 232 240 240 248
##  [52] 248 256 256 264 264 272 272 280 280 288 288 296 296 304 304 312 312
##  [69] 320 320 328 328 336 336 344 344 352 352 360 360 368 368 376 376 384
##  [86] 384 392 392 400 400 408 408 416 416 424 424 432 432 440 440
```
**Notes:** Now, the pattern of the size of numeric and logical vector is clear. For the numeric vector, its size increases 8 bytes for adding an element after the vector including more than 16 elements. For the logical vector, its size in increases 8 bytes for adding every two elements after the vector size reaching 168 bytes. What's more, both of their size begin increasing in its own regular way after they have 168 bytes. 

***Question: Why does the size of logical vector increase in this way?***

* Refer to `The R language definition`, see how this depends on the architecture of the CPU (32-bit or 64-bit), and what the largest in-memory allocation is allowed for such vector types is?

**Notes:** *In every computer language variables provide a means of accessing the data stored in memory. R  does not provide direct access to the computer’s memory but rather provides a number of specialized data structures we will refer to as objects. These objects are referred to through symbols or variables. In R, however, the symbols are themselves objects and can be manipulated in the same way as any other object. This is different from many other languages and has wide ranging effects.  -- cited form [R Language Definition](http://cran.r-project.org/doc/manuals/R> -lang.html#Vector-objects)*

After I search some information via Internet, although I can't answer the question exactly, I think the following information may be helpful if our computing is limited by the size of memory.

command related to managing memory

    memory.limit()  #check the maximum memory allocated to R
    memory.size(F)  #check how much memory has R used.
    memory.size(T) #check how much memory did operation system allocate to R; note that the                   
                    memory that R used is different from the memory that has been allocated   
                    for R. For example, when we clear some objects in R, the memory that R 
                    used diminishes but the memory that has been allocated to R remains the   
                    same.
    memory.limit(2000)         #set the maximum memory used for R to 2G
    storage.mode(x)<-"integer" #change the mode of storage to integer. If the integer are 
                               stored as numeric mode, the memory used by storing this vector   
                               will be double.
    rm(x)           #remove objects
Also, there are many other tips for saving memory. For instance, if we would like to use a vector to store some results got for a loop, we'd better declare the vector initially instead of letting R "re-open" a new vector during each loop. Besides, if we must handle some real huge dataset, we can require the package `bigmemory`.  
Since we step into the era of "big data", the long vector in R language supports the ability of storing at most $2^{52}$ elements in a vector for the 64-bit CPU after the version 3.0.0.
    
                    
2. Design an experiment to determine whether a numeric vector is copied in memory when its entries are modified (use `tracemem` function to trace a given object in memory). Does this happen to other atomic vector types? What's the implication for very large atomic vectors?

```r
integer.o<-rep(1L,10) #define the original integer vector 
integer.m<-integer.o[1]+1L #define the modified integer vector
numeric.o<-rnorm(10)
numeric.m<-numeric.o+1
character.o<-rep("cat",10)
character.m<-paste(character.o,"dog")
logical.o<-rep(TRUE,10)
logical.m<-!logical.o
temp1<-c("integer"=tracemem(integer.o)==tracemem(integer.m))   # Question: how to seperate
temp2<-c("numeric"=tracemem(numeric.o)==tracemem(numeric.m))   # the long code into two                                                       
temp3<-c("character"=tracemem(character.o)==tracemem(character.m)) #line in Rmarkdown for the 
temp4<-c("logical"=tracemem(logical.o)==tracemem(logical.m))   #sake of full display
print(c(temp1,temp2,temp3,temp4))
```

```
##   integer   numeric character   logical 
##     FALSE     FALSE     FALSE     FALSE
```

**Notes:** From the result, we can see that no matter what class of the atomic vector is, once its elements are modified, it will be copied in memory. When it comes to large atomic vectors, I guess that modification of an elements in this vector will call for huge memory space and the speed of computation will be slow.  

* How about lists? Can you figure out a method to determine whether the whole list or only the part that are being modified is copied when its members are mutated? Refer to `The R language definition` and describe the `copy on write` mechanism. What are the advantages and disadvantages of this language design?

```r
list.o<-mtcars
list.m<-list.o
list.m$mpg<-list.m$mpg+1
temp.11<-c("whole.list"=tracemem(list.o)==tracemem(list.m))
temp.22<-c("modified.mem"=tracemem(list.o$mpg)==tracemem(list.m$mpg))
print(c(temp.11,temp.22))
```

```
##   whole.list modified.mem 
##        FALSE        FALSE
```
**Notes:** From the result, it seems that both memory of the whole list and the modified member have been copied. I can't figure out the advantage of this mechanism, but I think the advantage, need for large memory, is obvious.

3. What operations would one usually perform on logical vectors? (`sum`, `!`, `|`, `&`, `any`, `all`, `which`)What about numeric vectors(*all mathematical operations*, `which`, `sort`, `max`, `min`, `sample`, `is.na`, `complete.case`, `factorial`, `ceiling`, `floor`, `round`, `signif`, `polyroot`) and character vectors(`paste`, `cat`, `message`, `sprinf`, `toupper`, `tolower`, `nchar`, `substr`, `strsplit`)? What about lists(`lapply`, `tapply`, `split`, `subset`, `$`)? Give as many cases as you can where atomic vectors should be used instead of lists, where lists should be used instead of atomic vectors, and where both atomic vectors and lists can be used interchangeably(`is.na`). **Notes:** content from learn R

4. Coercion of atomic vectors is often implicitly done and thus causing unexpected results in type-sensitive operations. Try `as` functions such as `as.numeric` on objects of other vector types and use `storage.mode`, `mode`, and `class` to query the data type associated with the converted objects, and refer to `The R language definition` on the internal working of atomic vector types as evidenced by `storage.mode`, `mode`, and `class`. Then try `+` on different combinations of atomic vector types and see in what cases the  operation is valid and in what cases is not, and in the former cases what coercion is performed and whether it is always desirable.

```r
print(c(1,2,3,"cat","dog")) #numeric->character
```

```
## [1] "1"   "2"   "3"   "cat" "dog"
```

```r
print(c(TRUE,FALSE,1,2,3))  #logical->numeric
```

```
## [1] 1 0 1 2 3
```

```r
print(c(TRUE,FALSE,"cat","dog","pig")) #logical->character
```

```
## [1] "TRUE"  "FALSE" "cat"   "dog"   "pig"
```

```r
print(class(c(1L,2L,3,4,5))) #integer->numeric
```

```
## [1] "numeric"
```

5. Vectorization is computationally efficient and semantically elegant way of doing arithmetics. Perform `+` and `*` on two vectors of the same length by vectorization and by entry-wise iteration with `for` loop and use `system.time` to compare the computing time for each approach respectively. Similarly, try math functions such as `sin`, `log`, and furthermore, `pmax`, `pmin`, `ifelse`. In view of the advantages of vectorization, in what cases is vectorization not appropriate, and why? **Notes:** Sorry, I can't give an example which is more appropriate to ues loop instead of vectorization.

```r
vet1<-rnorm(10000) #time used by computing in a vectorized way
vet2<-rpois(10000,1)
print(rbind("time+"=system.time( vet1+vet2), "time*"=system.time(vet1*vet2)))
```

```
##       user.self sys.self elapsed user.child sys.child
## time+         0        0       0          0         0
## time*         0        0       0          0         0
```

```r
result<-numeric(10000) 
`time+`<-system.time(for (i in 1:10000) {result[i]<-vet1[i]+vet2[i]})
`time*`<-system.time(for (i in 1:10000) {result[i]<-vet1[i]*vet2[i]})
print(rbind(`time+`,`time*`))#time used by computing in loop 
```

```
##       user.self sys.self elapsed user.child sys.child
## time+     0.019    0.002   0.021          0         0
## time*     0.016    0.002   0.017          0         0
```
From the result, we can easily see that vectorization saves time.

6. Manipulation of vectors and lists can often be reduced to combination of several higher-order functions. The most basic ones are the `apply` family. Carefully differentiate between `apply`, `lapply`, `sapply`, `vapply`, `tapply`, `mapply`, `rapply`, and `eapply`.  
**Notes:** Perhaps, xiaojun has offered us the perfect answer in the [project_1_solution](https://github.com/XiaojunSun/wise-r-club/blob/master/src/r_project_1_solution.Rmd)

* Also, try another family, the "Common Higher-Order Functions in Functional Programming Languages": `Reduce`, `Filter`, `Find`, `Map`, `Negate`, and `Position`. Furthermore, get to know the functions in `rlist` package. What's the benefit of using higher-order functions? Refer to wikipedia and contrast functional programming to other paradigms.  
**Notes:** These seem to be a bunch of "looping" function.

```r
######             Reduce               ######
## Reduce uses a binary function to successively combine the elements of a given vector
## and a possibly given initial value.  
cfrac <- function(x) Reduce(function(u, v) u + 1 / v, x, right = TRUE) 
`1+1/2`<-cfrac(1:2) 
`1+1/(2+1/3)`<-cfrac(1:3)
`1+1/(2+1/(3+1/4))`<-cfrac(1:4) 
```


```r
######            Filter                ######
## Filter extracts the elements of a vector for which a predicate (logical) function
##  gives true.
funs <- Filter(is.function, sapply(ls(baseenv()),get,baseenv()))#A list of all functions 
                                                               #in the base environment
# is.function justify whether the object is a function
# ls(baseenv()) list all names of the objects in base environment
# get searches by name for an object
# funs includes all the functions of base environment
names(Filter(function(f) length(formals(args(f))) > 10, funs))#Functions in base with
```

```
## [1] "format.default"   "formatC"          "merge.data.frame"
## [4] "prettyNum"        "scan"             "source"
```

```r
                                                              #more than 10 arguments
```


```r
# Find and Position give the first or last such element and its position in the vector,
# respectively. 
Find(function(x) x>50, seq(1,100,1))# the same as Position
```

```
## [1] 51
```


```r
#  Map applies a function to the corresponding elements of given vectors.
t(Map(function(x) x^2, 1:10))
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,] 1    4    9    16   25   36   49   64   81   100
```


```r
# Negate creates the negation of a given function.
names(Filter(Negate(is.function),  sapply(ls(baseenv()), get, baseenv())))
```

```
##  [1] "F"                "letters"          "LETTERS"         
##  [4] "month.abb"        "month.name"       "pi"              
##  [7] "R.version"        "R.version.string" "T"               
## [10] "version"
```

```r
# this gives the names of object which are not function in base environment
```

## Matrices and arrays

Do similar tasks in `Vector` section on matrices and arrays.
**Notes:** **:<** **:(**

## Data frames

1. When is it more appropriate to use lists than data frames and when data frames than lists?  
**Notes:** Generally speaking, data frame is a specific situation of list, which can contain objects/variables of different class and different length. But vectors in data frame must have same length. Here is a [better explaination](http://www.zhihu.com/question/23119559) for the difference between them.
 
2. Experiment the `copy on write` behavior of data frames and see it is more like the behavior of a list or of a matrix.

**Notes:** Perhaps the test on the list is wrong in the Vector section. Because based on the test above, since, when we modify an member in a list, the entire list will be copied,so there is no difference between them. But since data frame is a special case of list, it may much more like list in the behavior of copying on write.

***Question:Hope instructor can offer exact explaionation for this question***

3. "Growing" an object is usually not an efficient way of dynamically storing data. Compare the computing time of growing a data frame row by row or column by column. Is there any significant difference in computing time in these two practices? Why or why not, in your opinion? 

```r
x<-mtcars[1,]  
time.by.row<-system.time(for (i in 2:nrow(mtcars)) x<-rbind(x,mtcars[i,]))
y<-mtcars[,1]  
time.by.col<-system.time(for (i in 2:ncol(mtcars)) y<-cbind(y,mtcars[,i]))
print(rbind(time.by.row,time.by.col))
```

```
##             user.self sys.self elapsed user.child sys.child
## time.by.row     0.013        0   0.014          0         0
## time.by.col     0.000        0   0.001          0         0
```
Yes, there is significant different in computing this by row or by columns. Obviously, computing by columns can save time than computing by rows. I guess that the reason for this is that the class of elements in columns is single, but when we add data by rows, the class can be multiple in rows. 

* Can you avoid growing a data frame by pre-allocating one of a size large enough?  
(`as.data.frame(matrix(numeric(30),5,6))`) What do you do if the size actually needed cannot be known in advance?(***sorry, need help***) Is growing a list indeed less efficient than pre-allocating enough members?(***This question is related to whether new memory is needed when we modify the list everyytime. The answer I get is pre-allocating is more efficient than growing a list according to the test before, but I think this needs instructor's analysis further more. Besides, I recommend the data.table package for you.***)

4. Get to know the functionality and design principles of `plyr` and `dplyr`. Try examples provided in the packages and make conclusions on the commonality of the tasks, ease of use of the higher-order functions developed, and performance benchmarked by your own solution of similar tasks.  
**Notes:**  **package:plyr**  
*Title:* Tools for splitting, applying and combining data  
*Description:* plyr is a set of tools that solves a common
    set of problems: you need to break a big problem down
    into manageable pieces, operate on each pieces and then
    put all the pieces back together.  For example, you
    might want to fit a model to each spatial location or
    time point in your study, summarise data by panels or
    collapse high-dimensional arrays to simpler summary
    statistics. The development of plyr has been generously
    supported by BD (Becton Dickinson). 
    
Here are some examples: Manipulating Data with plyr    
  

```r
library(plyr)#function select(), filter(), arrange(), mutate(), and summarize()
library(dplyr)
```


```r
#########              subset columns using select()             #############
cran<-tbl_df(mtcars) # first read the data frame"mydf" into tal_df
select1<-select(cran, mpg, cyl, disp)     #select only the mpg,cyl and disp 
                                          #variables from the cran dataset.
select2<-select(cran,mpg:drat)#select all columns from mpg to drat.
                                    # also, use "-mpg" can remove country columns.
#########              subset rows using filter()             #############
filter1<-filter(cran, cyl== 6)#elect all rows  cyl variable is 6.
                                        #Note that logical operators can be used.
###arrange() order the rows according to the values of a particular variable####
arr<-arrange(cran, mpg)#order the ROWS of cran so that mpg is in ascending order
                     #desc(mpgves the descending order,more variables is allowed
# mutate()creates a new variable based on the value of variables already in a dataset.#
mu<-mutate(cran, mpg2 = mpg^2)
######         summarize() collapses the dataset to a single row         #######
summarize(cran, mean_mpg= mean(mpg))#gives us the mean size and label the result 'mean_mpg'
```

```
## Source: local data frame [1 x 1]
## 
##   mean_mpg
## 1    20.09
```

```r
df1<-data.frame(id=sample(1:10),x=rnorm(10))#merge multiple dataframes
df2<-data.frame(id=sample(1:10),x=rnorm(10))
df3<-data.frame(id=sample(1:10),x=rnorm(10))
dlist<-list(df1,df2,df3)
head(join_all(dlist),n=3)
```

```
## Joining by: id, x
## Joining by: id, x
```

```
##   id       x
## 1  9 -1.0434
## 2  7 -0.3492
## 3 10  1.5794
```
Here are some examples: Grouping and Chaining with dplyr

```r
### group_by()break up dataset into groups of rows based on the values of variables ###
by_cyl<-group_by(cran,cyl)
#any operation we apply to the grouped data will take place on a per package basis
summarize(by_cyl,count = n(),unique = n_distinct(hp),mean_mpg =mean(mpg) )
```

```
## Source: local data frame [3 x 4]
## 
##   cyl count unique mean_mpg
## 1   4    11     10    26.66
## 2   6     7      4    19.74
## 3   8    14      9    15.10
```
**Notes:** Chaining allows you to string together multiple function calls in a way that is compact and readable, while still accomplishing the desired result. %>%,allows us to chain the function calls in a linear fashion. The code to the right of %>% operates on the result from the code to the left of %>%.

```r
cran%>%group_by(cyl)%>%summarize(count = n(),unique = n_distinct(hp),mean_mpg =mean(mpg))
```

```
## Source: local data frame [3 x 4]
## 
##   cyl count unique mean_mpg
## 1   4    11     10    26.66
## 2   6     7      4    19.74
## 3   8    14      9    15.10
```

```r
#this has the same result as last code chunk, but is more readable
```


5. Get to know the functionality and design principles of `reshape2`. Try examples provided in the package and consider the working scenarios where `dcast` and `melt` can greatly simplify complex tasks.

```r
library(reshape2)
mtcars<-cbind(mtcars,'carname'=rownames(mtcars))
carMelt<-melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
```

```
##         carname gear cyl variable value
## 1     Mazda RX4    4   6      mpg  21.0
## 2 Mazda RX4 Wag    4   6      mpg  21.0
## 3    Datsun 710    4   4      mpg  22.8
```

```r
tail(carMelt,n=3)
```

```
##          carname gear cyl variable value
## 62  Ferrari Dino    5   6       hp   175
## 63 Maserati Bora    5   8       hp   335
## 64    Volvo 142E    4   4       hp   109
```

```r
dcast(carMelt,cyl~ variable,mean)#summarize the mean of 'mpg','hp' fordifferent 'cyl' values.
```

```
##   cyl   mpg     hp
## 1   4 26.66  82.64
## 2   6 19.74 122.29
## 3   8 15.10 209.21
```


6. Get familiar with `sqldf`. Try examples provided in the package and consider how tasks that cannot easily be reduced to utilizing former package functionalities can possibly be accomplished by harnessing the power of SQL on data frames.
**Notes:** Here are two examples which can give us a little perception of SQL language.

```r
library(sqldf)
dat<-mtcars
names(dat)
```

```
##  [1] "mpg"     "cyl"     "disp"    "hp"      "drat"    "wt"      "qsec"   
##  [8] "vs"      "am"      "gear"    "carb"    "carname"
```

```r
## select only the data for "mpg" with "cyl"<6
cat("the max and min value of vaiable cyl is" ,range(dat$cyl))
```

```
## the max and min value of vaiable cyl is 4 8
```

```r
sub_mpg<-sqldf("select mpg from dat where cyl < 6")
# this command is equivalent to unique(dat$cyl)
sqldf("select distinct cyl from dat")
```

```
##   cyl
## 1   6
## 2   4
## 3   8
```
Here are some material related to using package `RMySQL`.  

* [RMySQL vignetteL](http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf)
* [List of commands](http://www.pantz.org/software/mysql/mysqlcommands.html)
* [A nice blog](http://www.r-bloggers.com/mysql-and-r/) post summarizing some commands

7. Missing values could emerge from almost everywhere in real-world  data analysis. Try the `na` family, such as `na.omit` in `stats` and `na.locf` in `zoo`, and determine which are the most useful ones in your working scenarios.  
**Notes:**  Before we analyze data, we usually need to get and clear data at first. In reality, the samples we collect often have missing value. Here is some skills to deal with the missing value.

    `read.table("file",na.rm=TRUE) `#omit the missing value  
    `good<-complete.cases(object1,object2)`#select the sample which are complete   
    `object1[good]`                        #both in object1 and object2.  
    `object2[good]`        
   ` na.omit(object)`#remove the rows which have missing value    
    `na.locf(object)`#Generic function for replacing each NA with the most recent 
                    non-NA prior to it.`fromLast` which substitutes the
    missing value with the most recent non-NA after it.
    
    

