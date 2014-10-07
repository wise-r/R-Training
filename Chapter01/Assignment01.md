# Assignment 01 for R-Training Project

This assignment serves as your very first step into the R world. You will know what kind of development environments you can work in with the R Programming Language, the appearance of the language itself and how it has evolved, and the proliferate and supportive community that makes R a widely accepted necessity for data-oriented problems.

## RGUI

1. Download and install the latest version of R from CRAN. What's new in the latest version compared to the former one?  
**Notes:** Changes in R 3.1.1 contains three parts, which are new features, installation and included software, bug fixes.  
* Who contribute to making such changes?  
**Notes:**There may be a link like "(PR#15760)" after the changes. This leads to a description of when and who discovered the corresponding bugs. It seems that it is the users who pointed out the bugs and desired modification and then the R core team modified R to be a better version.  
* How did they manage to make those advances in your opinion?  
**Notes:**R core team collected opinions from users all over the world, which leads to a broad and timely suggestions when there are some bugs.  
* Although most of the improvement might not seem to make sense for you for the moment, choose one that looks most appealing and get familiar with the issues involved and decide how important it is.  
**Notes:**Finally, I find some changes I can roughly understand what it means."dbinom(x, n), pbinom(), dpois(), etc, are slightly less restrictive in checking if n is integer-valued. (Wish of PR#15734.)" I guess that since this changes, we can use the distribution and probability function of binomial variables in a wider way, or say in more relaxed conditions.

2. Locate and run the `RGUI` program from the start-up menu, or `\bin\x64` or `\bin\i386` in your installing folder. Type in RGUI console whatever statements that you deem reasonable and test whether R recognizes your instructions. If you know some other programming languages, try a variety of expressions, see how RGUI responds to them, and discuss how the syntax of R differs and has in common.  
**Notes:** I think the most particular character for R languish is that the smallest unit for calculation is a vector. No matter the class and length of the vector, it is the smallest unit for calculation.

## RStudio

1. Download, install and launch the latest version of RStudio from RStudio.com. Go to `Tools` `Global Options` `Appearance` and choose your favorite editor theme for your coding experience in R. 

2. Get familiar with the user interface. For what (programming) languages does the text editor provide intrinsic support in terms of highlighting(e.g. type `function` or `for` in the text editor for an R source file and these *keyword* will be highlighted)?  
**Notes:** When there are some words related to the syntax of R, the words would be highlighted. Also, the number and character in objects will also be highlighted. Thought there are several versions of editor theme, the types of word which would be highlighted are the same.  
* For what (programming) languages does the text editor provide auto-completion(e.g. type `sys` and press `Tab`)?  
**Notes:** The names of object, both variables and functions which are created by users or originally in packages in global environment can be auto-completed.  
* How do the text editor and the `Console` interact with each other?  
**Notes:** When we run some codes in text editor, these codes appear in Console. On the contrary, the codes run directly in Console will not be added into text editors automatically.

3. Get to know the functionalities of each menu strip, toolbox, and buttons, especially of `Run` and `Source` buttons above the text editor. What's the difference between these two buttons?  
**Notes:** When we click on the "run" button, the specific codes will be operated. But when we source the code, the whole code in the document will be run. Then the objects in the document will be created in the global environment.  
* Take a look at the `Package` tab in the bottom-right panel, find `stats`, enter several entries in the package, and test the sample code in the `Examples` section in corresponding `Help` pages. Imagine some scenario in which each function in the package might be used.

4. Find in `RStudio Docs` in `Help` menu how to debug an R program by setting *break points* and try.  
**Notes:** When we are debugging, in order to pinpoint the bug, we can first set the break point before the bugs and then source the codes after the break point into the global environment. Hence, we can examine the codes line by line.

## The R Programming Language

1. Go to wikipedia and search the entry `R Programming Language`. The source code for the R software environment is written primarily in what programming languages?  
**Notes:** S language.  
* Make some guess on how this might work. What statistical features of the R programming language are described?  
**Notes:** In R programming language, the basic unit is a vector. This corresponds to a piece of information that describes the observed value of a variable. What's more, some functions are operate vectors, which is related to summarizing and abstracting information for the observation.  
* What's the relationship between the R programming language and other programming languages, such as C, C++, Java, Python, and those in the .NET family?  
**Notes:** From my point of view, the R language is a kind of more advanced language than C, C++. It has some similar characteristics with Matlab.(PS: I don't know what does “.NET” mean.)

2. Follow the examples one by one either in RGUI or in RStudio. In each example, the result of which statements can be easily predicted? Which statement brings surprising result to you?
* From these examples, how do you define a variable?  
**Notes:** In general, we use`<-`to assign values for a variable.  
* How do you define a function?  
**Notes:**`fun.name<- function(x) { }`  
* What kind of objects, such as vector and matrix, are involved in the examples?  
**Notes:** *Sorry, I don't know which examples you refer to.*  
* Are functions objects in the R programming language? Why or why not?   
**Notes:** Yes, they are the same with variables in fact.  
* Can you pass a function as an argument to another function? Refer to `Help` for those statement that don't seem to make sense to you.  
**Notes:** Yes, we can set a function as the parameter of another function.

3. Go to the wikipedia pages of C, C++, Java, C#, Python, MATLAB, SPSS, SAS and other programming languages or environments that you know, take note of the different `programming paradigms` each of them supports, and try to make sense of each of the `programming paradigms`, such as `functional`, `object-oriented` and `array`, by carefully comparing the introductions and code examples. 

## The R Community

1. Go to `CRAN` and see what it does.  
**Notes:** We can download R software and R packages form [R-CRAN](http://cran.r-project.org/).

2. Go to `stackoverflow` and see how people collaborate to solve problems.  
**Notes:** [stackoverflow-R](http://stackoverflow.com/questions/tagged/r)

3. Go to `Github` and see how `social coding` is carried out for R projects.  
**Notes:** We can `fork` the copy of [R-Training in github](https://github.com/wise-r/R-Training) in our own accout and `Clone in Desktop`. After finishing the assignment, we can submit/share it online. 
4. Go to `R-Bloggers` and `Capital of Statistics` and carefully read several latest articles. What do the authors talk about? How do they investigate the problem using the R programming language? What difficulties do they meet during the process?  
**Notes:** The link for the listing webpages: [R-Bloggers](http://www.r-bloggers.com/) and [Capital of Statistics](http://cos.name/).

## Packages

1. In the `Package` section in wikipedia page of `R Programming Language`, which page on the CRAN website is described to list a wide range of tasks?     
**Notes:** Here is the link of [CRAN Task Views](http://cran.r-project.org/web/views/).
Go to that page after you name some of the fields that you are most familiar with, such as Finance and Econometrics, and find one of the related packages that you think what it does. Install and load the package in RStudio, and try examples in the package help pages.

2. Are there any packages that should have been in the task view but are actually not? If you are to develop some packages that you think is useful, what functionality would you like to offer? How would you design the package? How would you guarantee its reliability? Would you provide constant support to the package? If not, what might happen if you suspend supporting it?  
**Notes:** Maybe I will consider these questions several years later...sigh~

