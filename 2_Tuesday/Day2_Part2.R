###############################################################################
# Title:        Coding Camp - Day 2 - Part 2
# Description:  R basics II + Good practices
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################

###########################
#  Functions 
###########################

# Read data
library(readr)
ucdp_ged_sample <- read_csv("data/ucdp_ged_sample.csv")

# Let's write a function that takes a data frame, lowercases all of its column
# names, and replaces spaces with underscores. A genuinely useful thing when 
# you've just imported a survey with columns like "Birth Year" and "Q1 Response".

# Function syntax: 
# name <- function(arguments) {body}

# Your code here:

# Let's see if it works:
# Some fake data - messy on purpose:

survey <- data.frame(
  check.names = FALSE,      # let R keep the ugly names as-is
  stringsAsFactors = FALSE,
  "Respondent ID" = 1:3,
  "Birth Year"    = c(1990, 1985, 2001),
  "Q1 Response"   = c("1) Yes", "2) No", "1) Yes")
)


survey                     # before
survey_clean <- clean_colnames(survey)   
survey_clean

# Target headers:
#   "respondent_id"  "birth_year"  "q1_response"

## What if the code breaks

# Read the error message
# Check out the debugger:
# The debugger keys, once you're paused inside a function:
#   n  = run the next line
#   c  = continue to the end
#   Q  = quit out
# While paused you can type ANY expression — names(df), df, class(df) — and see
# what the function sees, right now.

# Let's see the debugger environment:
debug(clean_colnames)         # dig in
clean_colnames(survey)        # pauses inside, step through it
undebug(clean_colnames)       # climb back out

# test data (same messy survey as previous exercise )
survey <- data.frame(
  check.names = FALSE,
  stringsAsFactors = FALSE,
  "Respondent ID" = 1:3,
  "Birth Year"    = c(1990, 1985, 2001),
  "Q1 Response"   = c("1) Yes", "2) No", "1) Yes")
)

# Your working version from Exercise 1 (paste yours in if you prefer):
clean_colnames <- function(df) {
  # 1. lowercase the names
  names(df) <- tolower(names(df))
  # 2. replace spaces with underscores
  names(df) <- gsub(" ", "_", names(df))
  # bonus task: remove the 1) and 2) from the responses
  df[, 3] <- gsub("[0-9])\\s*", "", df[, 3])
  # 3. hand the df back
  return(df)
}

# watch a working function run 
# Run these three lines one at a time. After each `n`, type names(df) and watch
# the names change under you.

debug(clean_colnames)
clean_colnames(survey)     # pauses inside — press n, then type names(df)
undebug(clean_colnames)    # always climb back out when you're done!


# find the bugs 
# Both of these look fine at first sight but neither works. Figure out why :)

# Bug 1 — "nothing happened?"
clean_colnames_bug1 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
}

# Bug 2 — "it runs, but the names are still wrong"
clean_colnames_bug2 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub("_", " ", names(df))
  df
}

clean_colnames_bug1(survey)
clean_colnames_bug2(survey)

# Try fixing them! 


###########################
#  Reading external data  #
###########################

# We used csv before.
# Another way of storing data is json format.
# For this one we'll install a package.

# install.packages("rjson")
library(rjson)

# Let's read in the Monthly Weather (Climate and Agmet Data) 
# of a few regions of Ireland and compare where rained more.

# Dublin Airport, Co Dublin
# https://data.gov.ie/dataset/monthly-weather-dublin-airport?package_type=dataset

#Function from the package that works here (quick google search will tell)
dublin <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Dublin%20Airport")
str(dublin) # What format is here?


#To access the element that contains the monthly average we can 
# use a dolar sign as if it was a column, as save as a dataframe
dublin_df <- as.data.frame(dublin$total_rainfall)
str(dublin_df)
View(dublin_df)
colnames(dublin_df)

# Now let's get two more (not randomly selected)
# regions doing the same as above

# Roches Point, Co Cork
# https://data.gov.ie/dataset/monthly-weather-roches-point?package_type=dataset
cork <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Roches%20point")
cork_df <- as.data.frame(cork$total_rainfall)

# Comparing if the dataframes have the same dimensions
dim(dublin_df) == dim(cork_df) 


# Malin head, Co Donegal
# https://data.gov.ie/dataset/monthly-weather-malin-head?package_type=dataset
donegal <- fromJSON (file = "https://prodapi.metweb.ie/monthly-data/Malin%20Head")
donegal_df <- as.data.frame(donegal$total_rainfall)

# Now let's merge these three rows in the same dataframe
rain_df <- do.call("rbind", list(dublin = dublin_df,
                                 cork = cork_df,
                                 donegal = donegal_df))
str(rain_df)

#Drop columns that contain annual averages
rain_df <- rain_df[,!endsWith(colnames(rain_df),"annual")]

#Drop columns that contain report.LTA.
rain_df <- rain_df[,!startsWith(colnames(rain_df),"report.LTA.")]

# We selected the data we want but it is still not in the right format.
# Making all variables into numeric. 
# 'lapply' (and variations) is a useful way of
# vectorised operations without looping

#Transforming in numeric
rain_df <- data.frame(lapply(rain_df, function(x) as.numeric(x)))

#Drop columns where all values are missing (August-December 2023)
rain_df <- rain_df[,colSums(is.na(rain_df))<nrow(rain_df)]

#New column with county names
rownames(rain_df)<- c("Dublin", "Cork", "Donegal")

#transposing so we have the dates on the rows and counties on columns 
rain_df <- data.frame(t(rain_df[-1]))

# Now let's plot using only base R
# (never mind the order of months it's not correct )

# Specify par parameters
old_par <- par(mar = c(5, 4, 4, 8),
    xpd = TRUE)

# Create a blank plot with custom axis labels and a legend
plot(1, type = "n", xlim = c(1, length(rain_df$Dublin)), ylim = c(0, max(rain_df$Dublin, rain_df$Cork, rain_df$Donegal)), 
     ylab = "Rainfall (mm)", xlab = "Month", main = "Monthly Rainfall Comparison")

# Add lines for each dataset with different colors and labels
lines(rain_df$Dublin, type = "l", col = "blue", lwd = 1, lty = 1, xaxt = "n", yaxt = "n", ann = FALSE)
lines(rain_df$Cork, type = "l", col = "red", lwd = 1, lty = 2)
lines(rain_df$Donegal, type = "l", col = "green", lwd = 1, lty = 3)

# Add a legend
legend("topright",inset = c(- 0.5, 0), legend = c("Dublin", "Cork", "Donegal"), col = c("blue", "red", "green"),
       lty = c(1, 2, 3), lwd = 1, bg = "white", xpd = TRUE, y.intersp = 2, title = "Locations")

#par function to reset par to default setting
par(old_par)


########################################

# More on styling plots using ggplot
# Example from  Royal Statistical Society
# (https://royal-statistical-society.github.io/datavisguide/RSS-data-vis-guide.pdf)

# install.packages("ggtext")
library(ggtext)
# we are also using ggplot2 and dplyr but 
# we have them already with tidyverse

View(ToothGrowth)

plot_data <- ToothGrowth %>%
  mutate(dose = factor(dose)) %>%
  group_by(dose, supp) %>%
  summarise(len = mean(len)) %>%
  ungroup()

# Unstyled plot
ggplot(
  data = plot_data,
  mapping = aes(x = len, y = dose, fill = supp)
) +
  geom_col(position = "dodge")

# Styled plot
ggplot(
  data = plot_data,
  mapping = aes(x = len, y = dose, fill = supp)
) +
  geom_col(
    position = position_dodge(width = 0.7),
    width = 0.7
  ) +
  scale_x_continuous(
    limits = c(0, 30),
    name = "Tooth length"
  ) +
  geom_text(
    mapping = aes(label = round(len, 0)),
    position = position_dodge(width = 0.7),
    hjust = 1.5,
    size = 6,
    fontface = "bold",
    colour = "white"
  ) +
  scale_fill_manual(values = c("#9B1D20", "#3D5A80")) +
  labs(title = "Tooth Growth",
       subtitle = "Each of 60 guinea pigs received one of three dose levels of
vitamin C (0.5, 1, and 2 mg/day) by one of two delivery methods:
<span style='color: #9B1D20'>**orange juice**</span> or
<span style='color: #3D5A80'>**ascorbic acid**</span>.",
       y = "Dosage (mg/day)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_textbox_simple(face = "bold"),
    plot.subtitle = element_textbox_simple(
      margin = margin(t = 10),
      lineheight = 1.5
    ),
    plot.title.position = "plot",
    plot.margin = margin(15, 10, 10, 15),
    panel.grid = element_blank(),
    axis.text.x = element_blank()
  )


## Good resource to know what is possible to do:
# https://posit.cloud/learn/cheat-sheets

