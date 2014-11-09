Explore the `iris` Data
========================================================

*Milton Deng, 2014/11/07*

`iris` data is a very famous data set (find the data description here: http://en.wikipedia.org/wiki/Iris_flower_data_set). It was firstly used as an example to show how discriminant analysis works, but it can also be used as a wonderful example to get familiar with R.

After the following task, you may:

  * Get familiar with one of the most important data type: Cross-Sectional Data.
  
  * Basic skills in R: Subsetting, Basic Statistics, Plot, *apply() Functions  and Function Writing.
  
  * Essentials about exploratory data analysis. It will provide you a general idea about how to explore a set of data, how to find the main features of the variables, and how the varialbes are correlated with each other.  

## Get Familiar with the Data

Using `data(iris)` and the the `iris` data will be created in your R session. You can also ues `data()` to check other available data sets. 


```r
data(iris)
```

Remember, before any analytic tasks, we should be familiar with the data structure. Ask yourself:
  * (1) What is the data structure? A vector (`vecotr`, `list`), a table (`data.frame`), or some high-dimensional data types? 
  * (2) How many variables are there, and what do these variables mean?
  * (3) How large is the data? How many lines or how many elements?
  * (4) What is the type of each variable?


```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
class(iris)
```

```
## [1] "data.frame"
```

```r
ls(iris)
```

```
## [1] "Petal.Length" "Petal.Width"  "Sepal.Length" "Sepal.Width" 
## [5] "Species"
```

```r
nrow(iris)
```

```
## [1] 150
```

```r
sapply(iris, FUN=class)
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##    "numeric"    "numeric"    "numeric"    "numeric"     "factor"
```

We find that `Species` is one of the key variables here. We want to know:
  * (1) How many species are there?
  * (2) How many records are there of each species?


```r
unique(iris$Species)
```

```
## [1] setosa     versicolor virginica 
## Levels: setosa versicolor virginica
```

```r
table(iris$Species)
```

```
## 
##     setosa versicolor  virginica 
##         50         50         50
```

## Start with "setosa" Subset

### Basic Statistics

We begin our analysis with just one species, since analyse the data of three species will surely increase the difficulty. Try to select subset data of `setosa`.


```r
setosa <- iris[iris$Species == "setosa", -5]
```

Again, here are want to know:
  * (1) What are the means and standard deviations of each variable?
  * (2) Are these varialbes correlated with each other?


```r
sapply(setosa, mean)
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##        5.006        3.428        1.462        0.246
```

```r
sapply(setosa, sd)
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##       0.3525       0.3791       0.1737       0.1054
```

```r
cov(setosa)
```

```
##              Sepal.Length Sepal.Width Petal.Length Petal.Width
## Sepal.Length      0.12425    0.099216     0.016355    0.010331
## Sepal.Width       0.09922    0.143690     0.011698    0.009298
## Petal.Length      0.01636    0.011698     0.030159    0.006069
## Petal.Width       0.01033    0.009298     0.006069    0.011106
```

```r
cor(setosa)
```

```
##              Sepal.Length Sepal.Width Petal.Length Petal.Width
## Sepal.Length       1.0000      0.7425       0.2672      0.2781
## Sepal.Width        0.7425      1.0000       0.1777      0.2328
## Petal.Length       0.2672      0.1777       1.0000      0.3316
## Petal.Width        0.2781      0.2328       0.3316      1.0000
```

Try to calculate `Sepal.Ratio` and `Petal.Ratio`, which are defined as `Sepal.Ratio = Sepal.Length / Sepal.Width, Petal.Ratio = Petal.Length / Petal.Width`.



```r
setosa <- transform(setosa, Sepal.Ratio = Sepal.Length / Sepal.Width,
                    Petal.Ratio = Petal.Length / Petal.Width)
```


### Explore the Data with Figures

Now we use some figures to explore the data, which is really a very intuitive and powerful way. 

  * (1) How the data of each variable is distributed? Use boxplot and histogram to show that.
  
  * (2) Is `Sepal.Length` and `Sepal.Width` correlated? Use scatter plot to show that.


```r
boxplot(setosa)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 


```r
par(mfrow=c(2, 3))
for( j in 1:ncol(setosa) ){
  hist(setosa[, j], border=FALSE, 
       col="darkred", main=paste0("Histogram of ", names(setosa)[j] ) )
}  
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

```r
par(mfrow=c(1, 1))
```


```r
par(mfrow=c(1, 2))
plot(setosa$Sepal.Length, setosa$Sepal.Width, 
     main="Setosa: Sepal Length vs Sepal Width", pch=20, col="darkred")
plot(setosa$Petal.Length, setosa$Petal.Width, 
     main="Setosa: Petal Length vs Petal Width", pch=20, col="darkgreen")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 

```r
par(mfrow=c(1, 1))
```

### Write Functions to Make It Reproducible

We want to write functions to make the procedure more reproducitble. First, write a function which is able to show some basic statistics of the data set. For example, the mean, standard deviation and quantiles of each variable, as what we have did above.


```r
stats <- function(df){
  Mean <- sapply(df, mean)
  Sd <- sapply(df, sd)
  FiveNum <- sapply(df, quantile)
  rst <- list(Mean=Mean, Sd=Sd, FiveNum=FiveNum)
  return(rst)
}

stats(setosa)
```

```
## $Mean
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width  Sepal.Ratio 
##        5.006        3.428        1.462        0.246        1.470 
##  Petal.Ratio 
##        6.908 
## 
## $Sd
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width  Sepal.Ratio 
##       0.3525       0.3791       0.1737       0.1054       0.1187 
##  Petal.Ratio 
##       2.8545 
## 
## $FiveNum
##      Sepal.Length Sepal.Width Petal.Length Petal.Width Sepal.Ratio
## 0%            4.3       2.300        1.000         0.1       1.268
## 25%           4.8       3.200        1.400         0.2       1.386
## 50%           5.0       3.400        1.500         0.2       1.463
## 75%           5.2       3.675        1.575         0.3       1.541
## 100%          5.8       4.400        1.900         0.6       1.957
##      Petal.Ratio
## 0%         2.667
## 25%        4.688
## 50%        7.000
## 75%        7.500
## 100%      15.000
```

Try to write another function which is able to plot some figures to show the basic features of a single variable. And use the `setosa` data to test it.


```r
explore.plot <- function (x){ 
  par(mfrow=c(2,2))
  hist(x)
  plot(x)
  boxplot(x,horizontal=T)
  qqnorm(x); qqline(x)
  par(mfrow=c(1,1))
}

explore.plot(setosa$Sepal.Length)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

### Regression

Try to use linear regression model to describe the relationship between `Sepal.Length` and `Sepal.Width`.


```r
setosa.fit <- lm(data=setosa, Sepal.Length ~ Sepal.Width)
summary(setosa.fit)
```

```
## 
## Call:
## lm(formula = Sepal.Length ~ Sepal.Width, data = setosa)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.5248 -0.1629  0.0217  0.1383  0.4443 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   2.6390     0.3100    8.51  3.7e-11 ***
## Sepal.Width   0.6905     0.0899    7.68  6.7e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.239 on 48 degrees of freedom
## Multiple R-squared:  0.551,	Adjusted R-squared:  0.542 
## F-statistic:   59 on 1 and 48 DF,  p-value: 6.71e-10
```


## Explore Data with Different Species

After the following step, we have known some specific features of within `setosa`. You may find some interesting conclusions, but will they stay real across different species? 

### Plot 

First, use the complete data set to plot `Sepal.Length vs Sepal.Width` and `Petal.Length vs Petal.Width`, and use different color to denote different species. Tell what you found from the figure.


```r
par(mfrow=c(1, 2))
with(iris, {
  plot(Sepal.Length, Sepal.Width, pch=20, col=factor(Species))
  plot(Petal.Length, Petal.Width, pch=20, col=factor(Species))
})
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 

```r
par(mfrow=c(1, 1))
```

R also provides a very powerful function to explore the relationship among different variables.


```r
pairs(iris[, -5], pch=21, bg=iris$Species)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 

### Linear Regression Models Across Groups

Try to use linear regression `Sepal.Length = a + b*Sepal.Width` again. Is that consistent with what you found in the figure? (Uncontrolled Regression)


```r
lm.uc <- lm(data=iris, Sepal.Length~Sepal.Width)
summary( lm.uc )
```

```
## 
## Call:
## lm(formula = Sepal.Length ~ Sepal.Width, data = iris)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.556 -0.633 -0.112  0.558  2.223 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    6.526      0.479   13.63   <2e-16 ***
## Sepal.Width   -0.223      0.155   -1.44     0.15    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.825 on 148 degrees of freedom
## Multiple R-squared:  0.0138,	Adjusted R-squared:  0.00716 
## F-statistic: 2.07 on 1 and 148 DF,  p-value: 0.152
```

Use Species to control the regression, and check why the conclusion differs with the Uncontrolled regression.


```r
summary( lm(data=iris, Sepal.Length~Sepal.Width+Species) )
```

```
## 
## Call:
## lm(formula = Sepal.Length ~ Sepal.Width + Species, data = iris)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.3071 -0.2571 -0.0533  0.1954  1.4125 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)          2.251      0.370    6.09  9.6e-09 ***
## Sepal.Width          0.804      0.106    7.56  4.2e-12 ***
## Speciesversicolor    1.459      0.112   13.01  < 2e-16 ***
## Speciesvirginica     1.947      0.100   19.47  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.438 on 146 degrees of freedom
## Multiple R-squared:  0.726,	Adjusted R-squared:  0.72 
## F-statistic:  129 on 3 and 146 DF,  p-value: <2e-16
```

This question is an essential question in econometrics, and happens very where in financial empirical work. 

## Advanced Topics

Try to consider the following questions:

  * If you have already been familiar with all the data process and analysis technics. You may find all the codes above are from `base` package of R. Actually there are very useful packages to make you much more efficient. Learn more about the following packages, and try to upgrade your R skills:
  
   `plyr` : A game changer of R. Functions like `ddply`, `dlply` will take place of `sapply` and `lapply`. 
  
   `dplyr` : A package with essential data manipulation functions.
   
   `reshape2` : Functions like `dcast` and `melt` make you reshape your data very 
   
   `ggplot2` : An elegant and very efficient way to plot.
   
   `pipeR` : Developed by senior Kun Ren. It will completely change your code style.
   
   In the future, I may use these packages to provide another version of solution.
   
  * Discriminant Analysis. The original aim of `iris` data was to show how discriminant analysis works. The question is, if a set of data is given but we do not know which species these samples are, how do we can we answer this question based on all the given information? This can also be used in financial analysis. If you are interested in this field, try to learn and realize the following models: 
  
  `Fisher Discriminant`, `Decision Trees`, `Random Forest`, `SVM (Support Vector Machine)`.
  
  
  
 
   
   
