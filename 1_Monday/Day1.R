###############################################################################
# Title:        Coding Camp - Day 1
# Description:  Intro to RStudio and R basics
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################

## Today's agenda: 
# (1) Introduction to RStudio's environment
# (2) Scripts and RMarkdown
# (3) R basics

# The hashtag sign '#' is used to write comments
# Text preceded by '#' will not be read by R. 

This will be read by R, and will produce an error. 

## First things first

# Run line shortcut: Ctrl + Enter (Windows)
#                    Cmd + Enter (macOS)

# An R session should begin as an empty space, i.e., there should be no
# *objects* in our environment. 

# The ls() function shows us a *list* of objects in our environment. To run 
# this code, you have 2 options:
# 1. Select the function and click 'Run' on the top right corner of this pane.
# 2. Or use the shortcut Ctrl/Cmd + Enter. 

ls()

############
# R Basics 
############
# R includes built-in datasets
data()

# Let's examine 'Nile' 
Nile

# More explanation of what this dataset is:
?Nile
# or:
help(Nile)

# And what type of data it consists of:
class(Nile) # time series

mean(Nile)
plot(Nile)
hist(Nile)

# And now, for some simple functions: 
# You can use R as a calculator: 
2+3 # addition
5-3 # subtraction
6/2 # division
4*4 # multiplication
5^2 # exponentiation

# We can also conduct logical operations: 
3 == 1 # Equal
3 != 1 # Unequal
4 > 3 # Greater
2 < 4 # Lesser
3 > 3 | 3 >= 3 # Or
3 > 3 & 3 >= 3 # And

# Create 7 random numbers between 0 and 1:
runif(7)

# R allows for two different versions to assign a value to an object
z <- 2 + 2 # preferred way
z = 2 + 2

# Shortcut for the assignment operator: 
# Windows: Alt + -
# macOS: Option + -

# Data types in R: 
# 1. Character (ex: "hello", "Comparison is the thief of joy.")
# 2. Integer (ex: 4, 177)
# 3. Double/numeric (ex: 3.27, 14.0)
# 4. Logical/Boolean (ex: TRUE, FALSE)

## Data structures in R
# 1. Vector (1d, homogeneous) 
#  Ex 1: 3, 7, 14, 732, 4
#  Ex 2: "democracy", "democracy", "autocracy", "hybrid"
# 2. Matrix (2d, homogeneous)
# Ex: 3, 7, 2, 1,
#     4, 2, 1, 0,
#     9, 2, 5, 4
# 3. Array (any number of dimensions, homogeneous)
# All examples above are also arrays
# Ex: imagine a Rubik's Cube with numbers or words on each block (3d)
# 4. List (1d, heterogeneous)
# Ex: 7, "democracy", 9, the matrix above
# 5. Data frame (2d, heterogeneous)
# Ex: name     age   party
#     Simon    38    Fine Gael
#     Enya     29    Labour
#     Ocean    21    Green


# 'c' stands for 'concatenate' so 'y' here stores the values 1,2, and 4. 
y <- c(1,2,4)

# Parts of individual objects can be accessed via square brackets: 
y[3]

# We can access multiple parts of objects with a colon
y[2:3]

# Suppose now we want the sum of y
sum(y)

# Store the output of a function in another object
z <- sum(y)
z

# notice that we replaces the former 'z' object

# Double/numeric vector
num_vec <- c(300, 200, 4)
num_vec

# Character vector
char_vec <- c("democracy", "authoritarian", "democracy", "hybrid")
char_vec

# Logical/Boolean vector
log_vec <- c(FALSE, FALSE, TRUE)
log_vec

# Check data type
typeof(num_vec)

# Another way to check for specific values:
is.numeric(num_vec)
is.character(char_vec)
is.logical(log_vec)

## Exercise: 
# Can you use the sqrt() function to compute the square root of 962?

# answer here

# Can you now assign it to a new object?

# answer here


#########
# OOP 
#########

# R is an object-oriented programming language. This means, essentially,
# that we make objects with functions, which we then manipulate with other
# functions.

# The rm() function can be used to *remove* objects. Here, we are passing the
# contents of the *list* created by calling the ls() function which we used
# earlier. Do not worry if this is unclear for now: we are simply clearing our
# workspace.

rm(list = ls())

# Here, we assign the value 'Hello' to the object 'x'. 
x <- "Hello"

# The class() function tells us what *class* of object we have just created:
# in this case an object of class *character*. 
class(x)

# The length() function tells us how many discrete values or elements the 
# object contains.
length(x)

# We can use square brackets [ ] after an object's name to access a particular
# element by its *index*. Indexes in R begin at 1. 
x[1]

# We can use [ ] together with <- to add an element to x. Here, let's add the 
# word 'world', which will be sorted in the 2nd index position:
x[2] <- "world"

# We have now a *character vector* of length 2. 
# The str_length() function returns the number of characters within
# each discrete element of x, here 5: 5 for [1] Hello, and [2] world.
x
length(x)

# To run the str_length(x) command, we must first install and load the package
# 'stringr'
install.packages("stringr")
library(stringr)

str_length(x)

# If the elements of your vector have names, you can extract them by name.
# To do so, place a name or a vector of names, in the brackets behind a vector.
# Surround each name with quotation marks. 

# Extract the element named gamma from the vector below. 
vec2 <- c(alpha = 1, beta = 2, gamma = 3)

# Your code here
vec2["gamma"]

# We can use functions to create objects. Here, we use rnorm() to create an
# object comprising 50 *random* numbers drawn from the *normal distribution* 
# family (here with a mean) of 0 and standard deviation of 1 (these are the 
# default settings for the function).

x <- rnorm(n = 50)
length(x)
mean(x)
sd(x)


## Exercise: 
# Use rnorm() to generate 100 random normal values with a mean
# of 100 and a standard deviation of 15. 

# Your code here
rnorm(100, mean = 100, sd = 15)

# Now, assign them to an object named 'data'. 
# Then, on a new line, call the hist() function on data to plot 
# a histogram of the random values. 

# Your code here
data <- rnorm(100, mean = 100, sd = 15)

hist(data)

# A strength of R is that many functions will be applied automatically 
# to every element in an object. Here, the multiplication function takes
# the *scalar* input 2 and applies it to each discrete element in y. 
# We then simultaneously assign the result of this operation back onto 
# y using the assignment operator. 

y <- x
y <- 2 * y

# Many functions return large *lists* of objects. Here, we use the lm()
# or *linear model* function to apply a linear regression of the objects
# y and x on each other, and assign the results to a new object, xylm. 

xylm <- lm(y~x)
xylm


# We use the attributes() function to list the objects created by lm()
attributes(xylm)

# We use the summary() function to provide an output of summary statistics.
# Unsurprisingly, we discover that the slope of y is 2. 

summary(xylm)

# When we plot() x and y, they are perfectly linear. Note that R provided us
# with a helpful warning that this is the case in the output of summary().
plot(x,y)

# One of the objects which lm() creates is the value of the *residuals*
# (i.e., the values "left over" between the predicted and actual values of y).
# We can access these by using the "$" operator. When a function creates a 
# *list* of objects, passing the name of the "top level" object (here: xylm)
# followed by $ and then the "lower level" object allows us to
# access the latter.

xylm$residuals
plot(xylm$residuals)

###########
# FUNctions
###########

# As well as being an object-oriented language, R is also a *functional*
# language. This essentially means that, rather than constantly writing loops
# in our code, we can express iterative behaviour implicitly. 

# Here is the long way of creating an object comprising a vector
# of the numbers 1 to 10. 
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# Here is a *loop* doing the same thing.
# (Don't worry if this doesn't make sense yet!)

x <- vector("double", 10)
for (i in 1:10){
  x[i] <- i
}
x

# And here is the seq() function doing the same:
# a large saving in mental effort
x <- seq(1:10)

# Be careful though: here, if we want to add the number 11 onto the end of our 
# sequence, we must use the c() function. If we "add" using the + function, R 
# will add 11 to each discrete element in x. 

y <- x + 11
y <- c(x, 11)

# Every operator is itself a function, as we see by calling help 
# on the operator within quote marks. 

?"+"

?"c"

?"<-"

## Tomorrow's agenda:
# Working directories + Projects
# More on functions and Debugger
# Libraries
# Plots

