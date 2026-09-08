###############################################################################
# Title:        Coding Camp - Day 2 - SOLUTIONS  (Part 1 + Part 2, combined)
# Description:  The full Day 2 script with every exercise completed
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################

# This is the whole of Day2_Part1.R and Day2_Part2.R in one file, with the
# "Your code here" gaps filled in. Section numbers match the two teaching
# scripts. It runs top to bottom (a couple of purely interactive lines -
# browseVignettes(), debug() - are commented out with a note).


library(tidyverse)


###############################################################################
#  PART 1
###############################################################################

###########################
# (1) Projects & working directory
###########################

getwd()
# setwd("~/Desktop/coding camp 26")   # only if you are NOT using a Project


###########################
# (2) Libraries
###########################

search()
# install.packages("tidyverse")   # once per machine
library(tidyverse)
search()


###########################
# (3) Getting help
###########################

?mean
help(mean)
example(mean)
# vignette("dplyr")              # opens the vignette
# browseVignettes(package = "dplyr")   # interactive - opens a browser
??"standard deviation"


###########################
# (4) Examining a dataset
###########################

?mtcars
summary(mtcars)
str(mtcars)
head(mtcars)
glimpse(mtcars)

# The five-variable demo plot
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

# --- EXERCISE 1: explore the mpg dataset, make some simple plots ----------

help(mpg)
head(mpg)

# Simplest possible: a histogram of city fuel economy.
ggplot(mpg, aes(x = cty)) +
  geom_histogram()

# The same, tidied up.
ggplot(mpg, aes(x = cty)) +
  geom_histogram(bins = 20, fill = "darkblue", colour = "black", alpha = 0.5) +
  labs(title = "City miles per gallon", x = "City mpg", y = "Count")

# A bar chart: how many models per manufacturer, split by year.
ggplot(mpg, aes(x = manufacturer, fill = factor(year))) +
  geom_bar(position = "dodge") +
  labs(title = "Models per manufacturer", x = NULL, y = "Count", fill = "Year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# A boxplot: highway economy by class of car.
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot(fill = "grey90") +
  labs(title = "Highway mpg by class", x = NULL, y = "Highway mpg")


###########################
# (5) A small, complete analysis: the diamonds data
###########################

### 5a. Examine ------------------------------------------------------------

head(diamonds)
glimpse(diamonds)
summary(diamonds)

hist(diamonds$price, col = "steelblue",
     main = "Histogram of diamond prices", xlab = "Price (USD)")

# price is heavily right-skewed, so the mean sits well above the median:
mean(diamonds$price)     # ~3933
median(diamonds$price)   # ~2401

ggplot(diamonds, aes(x = price)) +
  geom_histogram(fill = "steelblue", colour = "white") +
  labs(title = "Histogram of diamond prices", x = "Price (USD)", y = "Count")

# --- EXERCISE 2: price histogram split by cut ---------------------------
ggplot(diamonds, aes(x = price, fill = cut)) +
  geom_histogram(aes(colour = cut), alpha = 0.5) +
  labs(title = "Diamond price by cut", x = "Price (USD)", y = "Count")


### 5b. Wrangle ----------------------------------------------------------

an_object      <- diamonds[diamonds$cut == "Ideal", ]
anotherObject  <- diamonds[diamonds$cut == "Premium", ]
Object3        <- diamonds[diamonds$cut == "Very Good", ]

# --- EXERCISE 3: give the three subsets sensible names -----------------
ideal_cut     <- diamonds[diamonds$cut == "Ideal", ]
premium_cut   <- diamonds[diamonds$cut == "Premium", ]
very_good_cut <- diamonds[diamonds$cut == "Very Good", ]

# (the tidyverse way to make one of them)
ideal_cut <- filter(diamonds, cut == "Ideal")


### 5c. Summarise ------------------------------------------------------------

diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  group_by(cut) %>%
  summarise(
    n          = n(),
    mean_price = mean(price),
    mean_carat = mean(carat)
  )
# Ideal has the LOWEST mean price and also the SMALLEST mean carat.


### 5d. Visualise ------------------------------------------------------------

boxplot_price <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(cut, price)) +
  geom_boxplot() +
  labs(title = "Diamond price by cut", x = NULL, y = "Price (USD)")

boxplot_price

# The problem: Ideal is the *best* cut but looks the *cheapest*.
class(diamonds$cut)     # "ordered" "factor"
levels(diamonds$cut)    # Fair < Good < Very Good < Premium < Ideal

# Why? Size. From the 5c table, Ideal-cut stones have the smallest mean
# carat, and carat is what drives price.


### 5e. Recycle code -------------------------------------------------------

# --- EXERCISE 5: the same boxplot for carat instead of price ----------
boxplot_carat <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(cut, carat)) +
  geom_boxplot() +
  labs(title = "Diamond size by cut", x = NULL, y = "Carat")

boxplot_carat
# Yes - it supports the explanation: Ideal-cut diamonds really are smaller
# here, which is why they come out cheaper in the price boxplot. Cut and
# size are confounded.

# Price against carat, coloured by cut:
diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(carat, price, colour = cut)) +
  geom_point(alpha = 0.15) +
  geom_smooth() +
  labs(title = "Price rises with carat; cut shifts the line",
       x = "Carat", y = "Price (USD)", colour = "Cut")
# Once you hold carat constant, better cuts DO sit a little higher - so cut
# adds value; the raw boxplot just hid it because size varied.


### 5f. Save our work ----------------------------------------------------

price_carat_plot <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium", "Very Good")) %>%
  ggplot(aes(carat, price, colour = cut)) +
  geom_smooth() +
  theme_classic() +
  labs(title = "Diamond price by carat and cut",
       x = "Carat", y = "Price (USD)", colour = "Cut")

ggsave("diamonds_price_carat.pdf", plot = price_carat_plot)
write_csv(diamonds, "diamonds_copy.csv")


###########################
# (6) Bridge to Part 2: read a file from disk
###########################

ged <- read_csv("data/ucdp_ged_sample.csv")

glimpse(ged)
summary(ged)

ged %>%
  count(year) %>%
  ggplot(aes(year, n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Recorded events per year", x = NULL, y = "Events")


###############################################################################
#  PART 2
###############################################################################

# install.packages(c("rjson", "ggtext"))   # once per machine


###########################
# (1) Writing functions
###########################

survey <- data.frame(
  check.names      = FALSE,
  stringsAsFactors = FALSE,
  "Respondent ID" = 1:3,
  "Birth Year"    = c(1990, 1985, 2001),
  "Q1 Response"   = c("1) Yes", "2) No", "1) Yes")
)

survey

# --- EXERCISE 1: write clean_colnames() --------------------------------
clean_colnames <- function(df) {
  names(df) <- tolower(names(df))          # (a) lower-case
  names(df) <- gsub(" ", "_", names(df))   # (b) spaces -> underscores
  df                                       # (c) return the data frame
}

survey_clean <- clean_colnames(survey)
names(survey_clean)   # "respondent_id" "birth_year" "q1_response"


###########################
# (2) When code breaks
###########################

# A guaranteed-working clean_colnames to practise the debugger on:
clean_colnames <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
  df
}

# Run these interactively in the teaching script - they pause execution, so
# they are commented out here to keep this file source-able:
# debug(clean_colnames)
# clean_colnames(survey)     # pauses inside - step through with n
# undebug(clean_colnames)

# --- EXERCISE 2: find and fix the bugs --------------------------------

clean_colnames_bug1 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
}
clean_colnames_bug2 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub("_", " ", names(df))
  df
}

clean_colnames_bug1(survey)
clean_colnames_bug2(survey)

# Bug 1: the last line is an assignment. A function returns its last
# expression, and an assignment returns INVISIBLY - so calling the function
# shows nothing, and if you capture the result you get the names vector,
# not the data frame. Fix: put df on its own line at the end.
clean_colnames_bug1_fixed <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
  df
}
clean_colnames_bug1_fixed(survey)

# Bug 2: gsub("_", " ", ...) replaces underscores with spaces - the wrong
# way round. After tolower() the names still contain SPACES, so this line
# does nothing useful. Fix: swap the first two arguments.
clean_colnames_bug2_fixed <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
  df
}
clean_colnames_bug2_fixed(survey)


###########################
# (3) Reading external data: JSON
###########################

library(rjson)

# Read the three stations from the Met Eireann API.
dublin  <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Dublin%20Airport")
cork    <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Roches%20point")
donegal <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Malin%20Head")

str(dublin, max.level = 1)   # a nested list, not a data frame

# Flatten the rainfall piece of each into a one-row wide data frame.
dublin_df  <- as.data.frame(dublin$total_rainfall)
cork_df    <- as.data.frame(cork$total_rainfall)
donegal_df <- as.data.frame(donegal$total_rainfall)

str(dublin_df)
colnames(dublin_df)       # "report.<year>.<month>"

dim(dublin_df) == dim(cork_df)
dim(dublin_df) == dim(donegal_df)

# Stack the three rows, name them, keep only the 2025 months.
rain_df <- rbind(dublin_df, cork_df, donegal_df)
rownames(rain_df) <- c("Dublin", "Cork", "Donegal")

keep_cols <- startsWith(colnames(rain_df), "report.2025.") &
             !endsWith(colnames(rain_df), "annual")
rain_df <- rain_df[, keep_cols]
colnames(rain_df) <- gsub("report.2025.", "", colnames(rain_df), fixed = TRUE)

rain_df

# Values arrive as text - convert every column to numbers.
rain_df[] <- lapply(rain_df, as.numeric)
str(rain_df)

# Transpose so months run down the side, stations across the top.
rain_t <- t(rain_df)
rain_t

# Base R plot, in layers.
plot(NA,
     xlim = c(1, 12),
     ylim = c(0, max(rain_t)),
     xaxt = "n",
     xlab = "", ylab = "Rainfall (mm)",
     main = "Monthly rainfall by station, 2025")
axis(1, at = 1:12, labels = rownames(rain_t))
lines(rain_t[, "Dublin"],  col = "blue",      lwd = 2)
lines(rain_t[, "Cork"],    col = "red",       lwd = 2)
lines(rain_t[, "Donegal"], col = "darkgreen", lwd = 2)
legend("topright",
       legend = c("Dublin", "Cork", "Donegal"),
       col    = c("blue", "red", "darkgreen"),
       lwd = 2, bg = "white")

# --- EXERCISE 3 (small): each station's total for 2025 -----------------
colSums(rain_t)
# Dublin ~804, Cork ~1104, Donegal ~983. Cork is the wettest - which
# matches the plot, where the red line sits above the others most months.


###########################
# (4) Polishing a plot
###########################

library(ggtext)

plot_data <- ToothGrowth %>%
  mutate(dose = factor(dose)) %>%
  group_by(dose, supp) %>%
  summarise(len = mean(len), .groups = "drop")

ggplot(plot_data, aes(x = len, y = dose, fill = supp)) +
  geom_col(position = "dodge")

ggplot(plot_data, aes(x = len, y = dose, fill = supp)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.7) +
  geom_text(aes(label = round(len, 0)),
            position = position_dodge(width = 0.7),
            hjust = 1.5, size = 5, fontface = "bold", colour = "white") +
  scale_x_continuous(limits = c(0, 30), name = "Tooth length") +
  scale_fill_manual(values = c(OJ = "#9B1D20", VC = "#3D5A80")) +
  labs(
    title = "Tooth growth in guinea pigs",
    subtitle = "60 guinea pigs, three vitamin C doses (0.5, 1, 2 mg/day),
delivered as <span style='color:#9B1D20'>**orange juice**</span> or
<span style='color:#3D5A80'>**ascorbic acid**</span>.",
    y = "Dose (mg/day)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position     = "none",
    plot.title          = element_textbox_simple(face = "bold"),
    plot.subtitle       = element_textbox_simple(margin = margin(t = 10),
                                                 lineheight = 1.5),
    plot.title.position = "plot",
    panel.grid          = element_blank(),
    axis.text.x         = element_blank()
  )


###########################
# (5) ADVANCED / OPTIONAL
###########################

rain_long <- as.data.frame(rain_t) %>%
  rownames_to_column("month") %>%
  pivot_longer(
    cols      = c(Dublin, Cork, Donegal),
    names_to  = "station",
    values_to = "mm"
  )

rain_long

# (a) yearly total per station
rain_long %>%
  group_by(station) %>%
  summarise(total_mm = sum(mm)) %>%
  arrange(desc(total_mm))

# (b) wettest calendar month on average
rain_long %>%
  group_by(month) %>%
  summarise(avg_mm = mean(mm)) %>%
  arrange(desc(avg_mm))
# -> November, then October: a wet Irish autumn.

# (c) ggplot version of the section (3) plot
rain_long %>%
  mutate(month = factor(month, levels = rownames(rain_t))) %>%
  ggplot(aes(x = month, y = mm, colour = station, group = station)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Monthly rainfall by station, 2025",
       x = NULL, y = "Rainfall (mm)", colour = NULL) +
  theme_minimal()

# --- EXERCISE 4 (optional): each station's single wettest month --------
rain_long %>%
  group_by(station) %>%
  slice_max(mm, n = 1)
# Cork's wettest month was January; Dublin's and Donegal's was November.
