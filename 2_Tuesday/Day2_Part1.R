###############################################################################
# Title:        Coding Camp - Day 2 - Part 1  
# Description:  R basics II + Good practices
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################


##################################
# (1) Projects & working directory
##################################

# Every R session has a *working directory*: the folder R treats as "here".
# Relative paths like "data/mydata.csv" are read from this folder, so it
# pays to know where it points.

getwd()

# You can move it with setwd(), passing a path in the parentheses:
#   setwd("~/Desktop/coding camp 26")
# ...but a better habit is to work inside an RStudio *Project*. When you
# open a .Rproj file, RStudio sets the working directory to that folder
# automatically, every time. No setwd() lines cluttering your script.

# You can also set it by hand: in the Files pane, navigate to a folder,
# click "More" -> "Set As Working Directory". Handy for Windows users, who
# otherwise have to deal with backslashes in copied paths.


###########################
# (2) Libraries
###########################

# R's real strength is its *packages*: collections of functions other people
# have written. search() shows which are loaded right now.

search()

# install.packages() downloads a package from the web. You only need to do
# this ONCE per machine. Here we install the "tidyverse", a bundle of
# packages for reading, wrangling and plotting data.

install.packages("tidyverse")

# Installing does not load. To use a package's functions in this session we
# call library(). Do this at the top of every script, every session.

library(tidyverse)

search()   # the tidyverse packages now appear


###########################
# (3) Getting help
###########################

# ? and help() open a function's documentation.
?mean
help(mean)

# example() runs the examples from the bottom of a help page.
example(mean)

# Some packages ship *vignettes* - longer, friendlier guides than the terse
# help pages.
vignette("dplyr")
browseVignettes(package = "dplyr")

# Not sure which function you need? Search all installed help with two ??
??"standard deviation"


###########################
# (4) Examining a dataset
###########################

# mtcars is built into R: 32 cars, 11 measurements each.
?mtcars

# Four functions worth reaching for whenever you meet new data:
summary(mtcars)   # min / max / quartiles per column
str(mtcars)       # structure: type and first values of each column
head(mtcars)      # first 6 rows
glimpse(mtcars)   # tidyverse's str()

# This next plot shows five
# variables at once: weight, fuel economy, cylinders, horsepower and
# transmission type. Do NOT worry about the code right now. 

mtcars_demo <- mtcars
mtcars_demo$am  <- factor(mtcars_demo$am,  labels = c("automatic", "manual"))
mtcars_demo$cyl <- factor(mtcars_demo$cyl)

ggplot(mtcars_demo, aes(wt, mpg)) +
  geom_text(aes(label = cyl, colour = am, size = hp)) +
  geom_smooth(aes(linetype = cyl), colour = "grey50",
              linewidth = 0.5, se = FALSE, show.legend = FALSE) +
  guides(size = "none") +
  scale_colour_manual(values = c(automatic = "blue", manual = "red")) +
  labs(title = "Fuel efficiency by weight for 32 cars",
       subtitle = "Digit = cylinders; size = horsepower",
       x = "Weight (1000 lbs)", y = "Miles per gallon", colour = NULL) +
  theme_classic()

# ---------------------------------------------------------------------------
# EXERCISE 1  (try it yourself - solutions in Day2_Solutions.R)
#
# The mpg dataset is a built in dataset for the ggplot
# package. By recycling the code in this script file, 
# explore the dataset and try creating your own simple 
# plots of the variables.
# ---------------------------------------------------------------------------

# Your code here



###################################################
# (5) A small, complete analysis: the diamonds data
###################################################

# For the rest of Part 1 we work with one dataset from start to finish, the
# way a real project goes. "diamonds" comes with ggplot2 (so the tidyverse
# gave it to us): ~54,000 diamonds, with price, size (carat) and quality
# grades (cut, colour, clarity).

### 5a. Examine ------------------------------------------------------------

head(diamonds)
glimpse(diamonds)
summary(diamonds)

# A first look at the outcome we care about, price. Base R:
hist(diamonds$price, 
     main = "Histogram of diamond prices", 
     xlab = "Price (USD)")

mean(diamonds$price)
median(diamonds$price)

# The same histogram in ggplot2:
ggplot(diamonds, aes(x = price)) +
  geom_histogram() +
  labs(title = "Histogram of diamond prices", x = "Price (USD)", y = "Count")

# ---------------------------------------------------------------------------
# EXERCISE 2: complete the code below to draw the price histogram split by
# "cut" (fill AND colour the bars by cut).
# ---------------------------------------------------------------------------

ggplot(diamonds, aes(x = , fill = )) +
  geom_histogram(aes(colour = ), alpha = 0.5)


### 5b. Wrangle ----------------------------------------------------------

# We want to compare three cuts. First, in base R, by subsetting rows with
# square brackets [rows, columns]:

an_object      <- diamonds[diamonds$cut == "Ideal", ]
anotherObject  <- diamonds[diamonds$cut == "Premium", ]
Object3        <- diamonds[diamonds$cut == "Very Good", ]

# The tidyverse way to do the same thing is filter(), which reads better:
#   filter(diamonds, cut == "Ideal")

# ---------------------------------------------------------------------------
# EXERCISE 3: the object names above are terrible. Re-create the three
# subsets with clear names (e.g. ideal_cut, premium_cut, very_good_cut).
# ---------------------------------------------------------------------------

# Your code here


### 5c. Summarise ------------------------------------------------------------

# Now the average price per cut. You *could* write mean() three times on
# three objects - but that is copy-paste and that is not efficient.
# group_by() + summarise() does all three groups in one statement:

diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  summarise(
    n = n(),
    mean_price = mean(price),
    mean_carat = mean(carat)
  )

# %>% is the "pipe operator": it takes what is on its left and feeds it as the first
# argument to the function on its right. Read it as "and then".



### 5d. Visualise ------------------------------------------------------------

# Q: Ideal, Premium and Very Good, which cut
# will have the highest median price? 

boxplot_price <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(cut, price)) +
  geom_boxplot() +
  labs(title = "Diamond price by cut", x = NULL, y = "Price (USD)")

boxplot_price

# Do you see a problem?


class(diamonds$cut)
levels(diamonds$cut)

# The clue is size. Look again at the summarise() table from 5c: which cut
# has the largest mean carat? 

### 5e. Recycle code -------------------------------------------------------

# ---------------------------------------------------------------------------
# EXERCISE 5: take the boxplot code from 5d and adapt it to show "carat"
# instead of "price". Save it to a sensibly named object. Does it support
# the size explanation above?
# ---------------------------------------------------------------------------

# Your code here

# Putting price and carat together shows the real relationship - price rises
# with carat, and the lines for the three cuts sit slightly apart:

diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(carat, price, colour = cut)) +
  geom_point(alpha = 0.15) +
  geom_smooth() +
  labs(title = "Price rises with carat; cut shifts the line",
       x = "Carat", y = "Price (USD)", colour = "Cut")


### 5f. Save our work ----------------------------------------------------

# A clean version of the plot we want to keep as a record:
price_carat_plot <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(carat, price, colour = cut)) +
  geom_smooth() +
  theme_classic() +
  labs(title = "Diamond price by carat and cut",
       x = "Carat", y = "Price (USD)", colour = "Cut")

# ggsave() writes the last plot (or a named one) to a file.
ggsave("diamonds_price_carat.pdf", plot = price_carat_plot)

# write_csv() saves a data frame as a plain-text CSV.
write_csv(diamonds, "diamonds_copy.csv")

# Check your working directory - both files should be there.


#############################################
# (6) Bridge to Part 2: read a file from disk
#############################################

# Everything so far used data that came bundled with a package. Usually your
# data lives in a file. This is the payoff of setting a working directory:
# a short relative path just works.

# UCDP GED sample: one row per recorded event of organised violence
# (a clash, an attack), 2014-2022, for four countries.
# year, country, region, type_of_violence, date_start, best (deaths)

ged <- read_csv("data/ucdp_ged_sample.csv")

glimpse(ged)
summary(ged)

# A quick look - events per year:
ged %>%
  count(year) %>%
  ggplot(aes(year, n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Recorded events per year", x = NULL, y = "Events")

# In Part 2 we come back to reading data - including messier formats like
# JSON - and to writing functions that clean it up.


###########################
# You can now:
###########################
# - set / recognise a working directory and why Projects help
# - install and load packages, and find help
# - examine a new dataset (summary / str / glimpse / head)
# - subset and group data, and summarise by group
# - build and save a ggplot, and read a CSV from a relative path
