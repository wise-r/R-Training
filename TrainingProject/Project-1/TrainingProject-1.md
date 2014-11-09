Explore the `iris` Data
========================================================

*Milton Deng, 2014/11/07*

`iris` data is a very famous data set in the field of data analysis (find the data description here: http://en.wikipedia.org/wiki/Iris_flower_data_set). It was firstly used as an example to show how discriminant analysis works, but it is also a wonderful example to get familiar with R.

Several tasks are provided for those who want to get familiar with R faster. They are specially designed for you to practice your basic skills in data manipulation and analysis, and also shows you clear steps to get familiar with a data set and find useful conclusions. 

Finishing the following tasks, you may:

  * Able to deal with most of the small scale data (less than 10k lines) analysis tasks!

  * Get familiar with one of the most important data type: Cross-Sectional Data.
  
  * Basic skills in R: Subsetting, Basic Statistics, Plot, *apply() Functions and Function Writing.
  
  * Essentials about exploratory data analysis. It will provide you general ideas about how to explore a set of data, how to find the main features of the variables, and how to find the relationships among different variables.
  
  * The uses of linear regression model, which is the most fundamental model in econometrics, and also the most important model in financial and economic empirical works.

## Get Familiar with the Data

Using `data(iris)` and the the `iris` data will be created in your R session. You can also use `data()` to check other available data sets. 


```r
data(iris)
```

Answer the following questions to get familiar with the data structure:

  * (1) What is the data structure? A vector (`vecotr`, `list`), a table (`data.frame`), or some high-dimensional data types? 
  * (2) How many variables are there, and what do these variables mean?
  * (3) How large is the data? How many lines or how many elements?
  * (4) What is the type of each variable?

We find that `Species` is one of the key variables here. We want to know:
  * (1) How many species are there?
  * (2) How many records are there of each species?

## Start with "setosa" Subset

We begin our analysis with just one species, since analyse the data of three species will surely increase the difficulty. 

  * Try to select subset data of `setosa`.

Again, here we want to know:

  * (1) What are the means and standard deviations of each variable? (Hint: use `sapply()` )
  * (2) Are these variables correlated with each other?
  * (3) Create a new variable called `Sepal.Ratio` and `Petal.Ratio`, which are defined as `Sepal.Ratio = Sepal.Length / Sepal.Width, Petal.Ratio = Petal.Length / Petal.Width`. (Hint: use `transform()`)

Now we use some figures to explore the data. 

  * (1) How the data of each variable is distributed? (Hint: Use `boxplot` and `histogram` to show that.)
  
  * (2) Is `Sepal.Length` and `Sepal.Width` correlated? (Hint: Use `scatter` plot to show that.)

We want to write functions to make the procedure more reproducible. 

  * First, write a function to show some basic statistics of the data set. For example, the mean, standard deviation and quantiles of each variable, as what we have done above. And use the `setosa` data to test it.

  * Try to write another function which is able to plot some figures instantaneously to show the basic features of a single variable. And use the `setosa` data to test it.

Then, 

  * Try to use linear regression model to describe the relationship between `Sepal.Length` and `Sepal.Width`. (Hint: Use `lm()` and `summary()` )

## Explore Data with Different Species

After the following step, we have known some specific features of `setosa`. You may find some interesting conclusions, but will they stay real across different species? 

  * First, use the complete data set to plot `Sepal.Length vs Sepal.Width` and `Petal.Length vs Petal.Width`, and use different color to denote different species. Tell what you found from the figure.

  * Try to use linear regression `Sepal.Length = a + b * Sepal.Width` again. Is that consistent with what you found in the figure? (Uncontrolled Regression)

  * Use Species to control the regression, and check why the conclusion differs from the Uncontrolled regression.

## Advanced Topics

Try to consider the following questions:

  * If you have already been familiar with all the data process and analysis technics. You may find the codes above all come from `base` package of R. Actually there are very useful packages to make it much more efficient. Learn more about the following packages, and try to upgrade your R skills:
  
   `plyr` : A game changer of R. Functions like `ddply`, `dlply` will take place of `sapply` and `lapply`. 
  
   `dplyr` : A package with essential data manipulation functions.
   
   `reshape2` : Functions like `dcast` and `melt` make you reshape your data in a easiest way.
   
   `ggplot2` : An elegant and very efficient way to plot.
   
   `pipeR` : Developed by senior Kun Ren. It will completely change your code style.
   
   In the future, I may use these packages to provide another version of solution.
   
  * Discriminant Analysis. The original aim of `iris` data was to show how discriminant analysis works. The question is, if a set of data is given but we do not know which species these samples are, how can we answer this question based on the given information? This question is quite general and also happens in some financial data mining tasks. If you are interested in this field, try to know something about the following models: 
  
  `Fisher Discriminant`, `Decision Trees`, `Random Forest`, `SVM (Support Vector Machine)`.
  
  
