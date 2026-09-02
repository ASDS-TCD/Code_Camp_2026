###############################################################################
# Title:        Coding Camp - Day 2 - Part 1
# Description:  R basics II + Good practices
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################


# (1) Projects
# (2) Working directory

# Try running this (it informs you where your current WD is set):
getwd()

# If you want to change the working directory, you run the command 
# setwd() and you insert the pathname in the parentheses. 
# Try it out with any folder you prefer:
setwd()

# Of course, you can do it manually through the navigation pane. 
# You navigate to your preferred folder, you click the "More" button and then 
# click 'Set as Working Directory'. 
# This might be useful for Windows users, since you have the reverse \ problem  
# with file paths.
getwd()

# (3) Libraries

# One of R's strengths is the large number of *packages* which users
# have created for different tasks. Packages contain functions which 
# we can use on our data.

# The search() function shows us which packages are loaded in our R session. 

search()

# The install.packages() function allows us to install new packages from the 
# web. Here, we are installing a suite of packages known as the "tidyverse". 

install.packages("tidyverse")

# Installing a package does not make it available to us in our R session. 
# To make a package available, along with its functions, we need to use 
# the library() function. 

library(tidyverse)

search()

# The tidyverse packages are now listed in our session. 

#######
# Help!
#######

# There are many ways of accessing help in R. The help() function is the main
# method. Its shortcut is "?".

help(tidyverse)
?tidyverse
?persp

# The example() function provides an interactive demo

example(persp)


# Some packages have *vignettes*, which go into more detail than R help files
# (which can be very terse). The vignette() function accesses there, or use
# browseVignettes(package = "name") to search. 

?dplyr
vignette("dplyr")
browseVignettes(package = "dplyr")

# If you're looking for help on a particular area, and aren't sure what function
# or package to use, try the help.search() function. 

help.search("standard deviation")

#####################
# R Basics - Part II
#####################

# Let's use some data:
# mtcars is a built-in dataset contained in R's datasets library.
# It is, unsurprisingly, a dataset about cars. 

?mtcars

# The summary() function provides some summary statistics of the dataset. 
summary(mtcars)

# The str() function provides information about the *structure* of the dataset. 
str(mtcars)

# The head() function provides the first 6 entries in each variable. 
head(mtcars)

# The ls.str() function combines the ls() and str() functions. 
ls.str(mtcars)

# These are all useful functions to remember when exploring a new dataset. 

# The next example makes use of the 'ggplot2' package (a more advanced 
# graphics package than base R graphics) to produce a scatter plot which is 
# able simultaneously to show the relationship between five variables: 
# the weight of the car, its fuel economy, the number of cylinders, 
# its horsepower and type of transmission.
# Further, three trend lines show the relationship between weight and 
# mpg for 4, 6, and 8 cylinder cars. 
library(ggplot2)

mtcars$am <- as.factor(mtcars$am)
mtcars$cyl <- as.factor(mtcars$cyl)

ggplot(mtcars, aes(wt, mpg, size = hp)) +
  geom_text(aes(size = hp, label = cyl, color = am)) +
  geom_smooth(aes(linetype = cyl), color = "grey", linewidth = 0.5, 
              se = F, show.legend = F) +
  guides(size = "none") +
  theme_classic() + 
  theme(legend.title = element_blank(), legend.justification = c(1,1),
        legend.position = c(1,1)) +
  scale_color_manual(labels = c("automatic", "manual"),
                     values = c("blue", "red")) +
  labs(title = "Plot of Fuel Efficiency by Weight for 32 Cars",
       subtitle = "Number of cylinders; size = horsepower") +
  xlab("Weight (1000 lbs)")

# It is not always a good idea to show so many variables
# simultaneously, but the plot gives a good idea of what
# is possible with R. Again, do not worry about the 
# specifics of the code at this point.

# A better example...
ggplot(mpg, aes(x = displ)) + 
  geom_histogram(bins = 10, fill = "darkblue", alpha = 0.5) +
  geom_text(stat = "bin", bins = 10, aes(label = stat(count),
                                         y = stat(count)), 
            nudge_y = 2, color = "darkblue", size = 3) +
  scale_x_continuous(breaks = 1:7) +
  theme_bw()

###############
# Exercise
###############

# The mpg dataset is a built in dataset for the ggplot
# package. By recycling the code in this script file, 
# explore the dataset and try creating your own simple 
# plots of the variables.

# Your answer here:


# For this script, we will only need the tidyverse package, so go
# ahead and edit the call to library(). 

library()

###  Examining the data

# In our analysis, we are going to be working with the *diamonds* dataset, 
# which is a built-in dataset provided with the ggplot2 package. If you
# managed to successfully load the tidyverse package, diamonds should now
# be available to you.

head(diamonds)
summary(diamonds)

# Let's create a histogram of values for 'price' with base R
hist(diamonds$price, col = "steelblue",
     main = "Histogram of Price Values",
     xlab = "Price")

# And now with ggplot2
ggplot(data = diamonds, aes(x = price)) +
  geom_histogram(fill = "steelblue", color = "black") +
  ggtitle("Histogram of Price Values")


# Complete the code below to create a histogram of "price", 
# group by "cut".
ggplot(diamonds, aes(x = , fill = )) + 
  geom_histogram(aes(color = cut), alpha = 0.5)

### Wrangling the data

# Most data science projects begin by organising our data.
# Below, we are taking three subsets of the diamonds data. 
# Can you work out what the code is doing?

an_object <- diamonds[diamonds$cut == "Ideal",]
anotherObject <- diamonds[diamonds$cut == "Premium", ]
Object3 <- diamonds[diamonds$cut == "Very Good", ]  


# Each new subset becomes an object with a name. The names provided are not 
# very good. Choose your own name in keeping with good data science principles, 
# and edit the code accordingly.

# Renaming:

# Your code here

### Analysing our data

# Next, we want to find out the average price for our diamonds according to the
# three types of cut we used to subset the data. Edit and complete
# the code below to find out.

mean(ideal_cut$price)
mean(premium_cut$price)
mean(very_good_cut$price)


# What would you need to add to the code above if you wanted to create 3 new
# objects each containing the different means? What names might you give these 
# objects? Go ahead and try it out. 

# Your code here


### Visualising our data

# As we might expect, there seems to be quite a difference between the average
# price of the 3 cuts of diamonds. But is everything as you might expect?

# Run the code below. What is strange about this boxplot?

diamonds %>% 
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(cut, price)) +
  geom_boxplot()

# This could be an important finding. Edit the code above to assign the plot
# to an object, and give it an appropriate name. 

boxplot_cut <- diamonds %>% 
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(cut, price)) +
  geom_boxplot()

### Investigating further

# The "cut" variable is what is known in R as an *observed factor*.
# A factor is a categorical variable (a variable with distinct categories).
# An ordered factor is a factor where the different possible categories have 
# an explicit order. 

class(diamonds$cut)

# The levels() functions shows us the order for the 'cut' variable.
# Again, looking at the boxplot, what is strange? 

levels(diamonds$cut)

# The carat of a diamond is the diamond's weight. Let's see if there is
# any interaction with the 'cut' variable. Use the mean() function
# on the carat variable for your three diamond subsets.

mean(diamonds$carat)

# mean carat, Ideal diamonds object
mean(ideal_cut$carat)

# mean carat, Premium diamonds object
mean(premium_cut$carat)

# mean carat, Very Good diamonds object
mean(very_good_cut$carat)

### Recycling code

# Recycling code is an important skill. You may not quite understand yet 
# everything that's going on in the code below (which we used to generate the
# previous boxplot), but you should be able to work out how to edit it to 
# produce a new boxplot which substitutes the price variable for carat. Give
# it a go, and don't forget to also make an appropriately named object.
# What do you notice about the plot?


# Your code here
boxplot_carat <- diamonds %>% 
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(cut, carat)) +
  geom_boxplot()

boxplot_carat

# %>% is the forward pipe operator
# it takes the output of the expression on its left and passes it
# as the first argument to the function on its right. 

diamonds %>% 
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(cut, price)) +
  geom_boxplot()

# Our final plot gives us a good idea of the interaction:
# Can you describe what is happening here?

diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(carat, price, color = cut)) +
  geom_point(alpha = 0.2) +
  geom_smooth()

### Saving our work

# We decide that the scatter plot is a bit busy, and the line plot
# with error bars does a good job of showing the interaction effect on its own. 
# We added a clean theme and a title to the plot, and decide to save a pdf
# of the plot as a record of our analysis. 

diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  ggplot(aes(carat, price, color = cut)) + 
  geom_smooth() + 
  theme_classic() +
  labs(title = "Pick a good title for this plot")

# Choose a name for this file below, and then call the function to save it. 

ggsave("filename.pdf", plot = last_plot())

# We also decide it would be a good idea to have a record of the data
# in the same location, so we use the write_csv() function to store a 
# comma-separated values copy of the dataset.

write_csv(diamonds, "filename.csv")

# We also decide to rename our script file and save it in 
# the same place. Now try closing R. Can you find the 
# files in the working directory?



