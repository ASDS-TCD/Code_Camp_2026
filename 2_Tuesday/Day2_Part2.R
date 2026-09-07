###############################################################################
# Title:        Coding Camp - Day 2 - Part 2  
# Description:  R basics II + Good practices 
# Author:       Elena Karagianni
# R version:    R 4.5.2
###############################################################################

library(tidyverse)

# Part 2 also uses two small extra packages. Install them once, now:
# install.packages(c("rjson", "ggtext"))

###########################
# (1) Writing functions
###########################

# When you catch yourself doing the same thing more than twice, write a
# function. Syntax:
#
#   name <- function(arguments) {
#     body
#     return(value)     # or just put the value on the last line
#   }

# Here is some deliberately messy survey data

survey <- data.frame(
  check.names      = FALSE,   # keep the ugly names exactly as written
  stringsAsFactors = FALSE,
  "Respondent ID" = 1:3,
  "Birth Year"    = c(1990, 1985, 2001),
  "Q1 Response"   = c("1) Yes", "2) No", "1) Yes")
)

survey   # look at those column names

# ---------------------------------------------------------------------------
# EXERCISE 1  (solutions in Day2_Solutions.R)
#
# Write a function clean_colnames(df) that:
#   (a) lower-cases every column name
#   (b) replaces spaces with underscores
#   (c) returns the data frame
# so that names(clean_colnames(survey)) becomes:
#   "respondent_id"  "birth_year"  "q1_response"
#
# Hints: names(df) gets/sets the names; tolower() lower-cases; gsub() does
# find-and-replace. Remember to hand df back at the end.
# ---------------------------------------------------------------------------

# Your code here:

clean_colnames <- function(df) {

}

# Test it:
survey_clean <- clean_colnames(survey)
survey_clean


###########################
# (2) When code breaks
###########################

# Some things to try, roughly in order:
#
#   1. READ THE ERROR MESSAGE. It names the function and usually the reason.
#   2. traceback()  - after an error, shows the chain of calls that led to it.
#   3. print() or cat() inside the function - the quick "what is this value
#      right now?" check.
#   4. the debugger - pause execution and look around inside the function.

# For the debugger practice below we need a function that definitely WORKS,
# so here is a finished clean_colnames. (Compare it with your Exercise 1.)

clean_colnames <- function(df) {
  names(df) <- tolower(names(df))            # 1. lower-case
  names(df) <- gsub(" ", "_", names(df))     # 2. spaces -> underscores
  df                                         # 3. hand df back
}

# debug() marks a function so R pauses on its first line the next time it
# runs. While paused, the console prompt changes to "Browse[1]>" and you can:
#
#   n            run the next line
#   c            continue to the end
#   Q            quit out
#   <anything>   type any expression - names(df), df, class(df) - to see
#                what the function sees at this exact moment
#
# Run these three lines one at a time. After each n, type  names(df)  and
# watch the names change under you.

debug(clean_colnames)
clean_colnames(survey)     # pauses inside - step through with n
undebug(clean_colnames)    # ALWAYS climb back out when you are done

# ---------------------------------------------------------------------------
# EXERCISE 2: find the bugs.
#
# Both functions below look fine but neither works. Figure out why, then
# fix them. (Test each with clean_colnames_bugX(survey).)
# ---------------------------------------------------------------------------

# Bug 1 - "I called it and nothing happened."
clean_colnames_bug1 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub(" ", "_", names(df))
}

# Bug 2 - "it runs and returns a data frame, but the names are still wrong."
clean_colnames_bug2 <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub("_", " ", names(df))
  df
}

clean_colnames_bug1(survey)
clean_colnames_bug2(survey)

# Your fixed versions here:



###########################
# (3) Reading external data: JSON
###########################

# Part 1 read a CSV - a flat table, the easy case. The other format you meet
# constantly, especially from web APIs, is JSON. JSON is *nested*: lists
# inside lists, not a single rectangle. This section walks through getting
# rainfall data out of that nested shape and comparing three places.

library(rjson)

# WHAT WE'RE LOOKING AT --------------------------------------------------
# Met Eireann publishes monthly weather for each of its stations at a web
# address like  https://prodapi.metweb.ie/monthly-data/<station>
#
# We compare monthly RAINFALL at three stations, one on each coast:
# Dublin Airport - east, Roches Point (Cork) - south,  Malin Head (Donegal) - north
# Question: where did it rain the most in 2025?

# fromJSON() reads JSON. Give it file = <url> and it downloads and parses
# the file in one step.
dublin <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Dublin%20Airport")

# What did we get? str() shows the shape. It is NOT a data frame - it is a
# nested LIST: a list of 9 things, and several of those are themselves
# lists. This is normal for data from a web API.
str(dublin, max.level = 1)

# The piece we want is $total_rainfall. 
# as.data.frame() flattens that
# nested list into a normal (if very wide) data frame - one row, one column
# per month-and-year.
dublin_df <- as.data.frame(dublin$total_rainfall)

str(dublin_df)
View(dublin_df)
colnames(dublin_df)
# The column names read  report.<year>.<month>  - e.g. "report.2025.july".
# "LTA" is the long-term average, and each year also has an "annual" total.

# Now the same two steps for the other two stations.
cork    <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Roches%20point")
donegal <- fromJSON(file = "https://prodapi.metweb.ie/monthly-data/Malin%20Head")

cork_df    <- as.data.frame(cork$total_rainfall)
donegal_df <- as.data.frame(donegal$total_rainfall)

# The three data frames should have the same shape. dim() gives
# c(rows, columns); comparing them with == checks both at once.
dim(dublin_df) == dim(cork_df)
dim(dublin_df) == dim(donegal_df)

# WRANGLING: from three wide rows to one clean table 

# rbind() stacks data frames on top of each other (row-bind). We get one
# data frame with three rows - one per station.
rain_df <- rbind(dublin_df, cork_df, donegal_df)

# Give the rows names so we can tell the stations apart.
rownames(rain_df) <- c("Dublin", "Cork", "Donegal")

# We only want the twelve 2025 months. Two helper functions pick columns
# by name:
#   startsWith(x, "report.2025.")  - TRUE for the 2025 columns
#   endsWith(x, "annual")          - TRUE for the yearly-total columns
# We keep the 2025 columns that are NOT the annual total. The "!" means NOT.
keep_cols <- startsWith(colnames(rain_df), "report.2025.") &
             !endsWith(colnames(rain_df), "annual")
rain_df <- rain_df[, keep_cols]

# Tidy the column names: chop off the "report.2025." prefix. gsub() is
# find-and-replace; fixed = TRUE means "treat the pattern as plain text".
colnames(rain_df) <- gsub("report.2025.", "", colnames(rain_df), fixed = TRUE)

rain_df

# The values are still TEXT ("73.1"), because that is how they arrived in
# the JSON. lapply() applies a function to every column; here we turn each
# column into numbers with as.numeric(). rain_df[] <- keeps it a data frame.
rain_df[] <- lapply(rain_df, as.numeric)

str(rain_df)   # now: 3 rows, 12 numeric columns

# t() transposes - it flips rows and columns. We want months down the side
# and stations across the top, which is the natural shape for the plot.
rain_t <- t(rain_df)
rain_t

# PLOT: base R, built up in layers ------------------------------------

# Base R draws a plot in layers. Layer 1: an empty canvas, with axes big
# enough for the largest value in the whole table (max(rain_t)).
plot(NA,
     xlim = c(1, 12),
     ylim = c(0, max(rain_t)),
     xaxt = "n",                    # suppress the default x-axis...
     xlab = "", ylab = "Rainfall (mm)",
     main = "Monthly rainfall by station, 2025")

# ...draw our own x-axis with month names instead of 1-12.
axis(1, at = 1:12, labels = rownames(rain_t))

# Layer 2: one line per station. rain_t[, "Dublin"] is the Dublin column.
lines(rain_t[, "Dublin"],  col = "blue",      lwd = 2)
lines(rain_t[, "Cork"],    col = "red",       lwd = 2)
lines(rain_t[, "Donegal"], col = "darkgreen", lwd = 2)

# Layer 3: a legend so the colours mean something.
legend("topright",
       legend = c("Dublin", "Cork", "Donegal"),
       col    = c("blue", "red", "darkgreen"),
       lwd = 2, bg = "white")

# WHAT WE FOUND -------------------------------------------------------
# - JSON from an API comes as a nested list; as.data.frame() on the right
#   piece flattens it into a table.
# - Real data needs tidying: selecting columns, renaming, fixing types.
# - Cork (south) sits above the others most months; Dublin (east) is
#   lowest. The wet Atlantic coasts get more rain than the drier east.

# ---------------------------------------------------------------------------
# EXERCISE 3 (small one): rain_t is a table with one column per station.
# colSums() adds up each column. Run  it  to get each
# station's total rainfall for 2025. Which station is the wettest? Does it
# match what you see in the plot?
# ---------------------------------------------------------------------------

# Your code here



###########################
# (4) Polishing a plot
###########################

# A last step of most analyses: taking a plain plot and making it
# presentable. Example adapted from the Royal Statistical Society's data
# visualisation guide:
# https://royal-statistical-society.github.io/datavisguide/

library(ggtext)   # lets us use a little markdown in plot text

plot_data <- ToothGrowth %>%
  mutate(dose = factor(dose)) %>%
  group_by(dose, supp) %>%
  summarise(len = mean(len), .groups = "drop")

# Plain version:
ggplot(plot_data, aes(x = len, y = dose, fill = supp)) +
  geom_col(position = "dodge")

# Styled version - same data, every element deliberate:
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
    legend.position   = "none",
    plot.title        = element_textbox_simple(face = "bold"),
    plot.subtitle     = element_textbox_simple(margin = margin(t = 10),
                                               lineheight = 1.5),
    plot.title.position = "plot",
    panel.grid        = element_blank(),
    axis.text.x       = element_blank()
  )

# Cheat sheets for what else is possible:
# https://posit.co/resources/cheatsheets/


###########################
# You can now:
###########################
# - write a function, and know when you should
# - read an error, use traceback(), and step through code with debug()
# - read JSON from a web API and tidy it into a table
# - take a rough plot to a presentable one


#########################################################
# (5) ADVANCED / OPTIONAL - for anyone who finished early
#########################################################

# The base R plot in section (3) works, but ggplot needs the data in a
# different shape: "long" format, with one row per station-per-month
# instead of one row per station. Reshaping between wide and long is a core
# tidyverse skill.

# We already have rain_t (months in rows, stations in columns). Turn it
# back into a data frame, move the month names from rownames into a real
# column, then pivot_longer() to stack the three station columns into two:
# one column of station names, one of values.

rain_long <- as.data.frame(rain_t) %>%
  rownames_to_column("month") %>%
  pivot_longer(
    cols      = c(Dublin, Cork, Donegal),
    names_to  = "station",
    values_to = "mm"
  )

rain_long   # 36 rows: 12 months x 3 stations

# With the data long, the Part 1 tools all work again.

# (a) each station's yearly total - the same answer as colSums(rain_t):
rain_long %>%
  group_by(station) %>%
  summarise(total_mm = sum(mm)) %>%
  arrange(desc(total_mm))

# (b) the wettest calendar month, averaged across the three stations:
rain_long %>%
  group_by(month) %>%
  summarise(avg_mm = mean(mm)) %>%
  arrange(desc(avg_mm))

# (c) and the ggplot version of the section (3) plot:
rain_long %>%
  mutate(month = factor(month, levels = rownames(rain_t))) %>%
  ggplot(aes(x = month, y = mm, colour = station, group = station)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Monthly rainfall by station, 2025",
       x = NULL, y = "Rainfall (mm)", colour = NULL) +
  theme_minimal()

# ---------------------------------------------------------------------------
# EXERCISE 4 (advanced): using rain_long and the verbs from Part 1, find
# for EACH station its single wettest month of 2025.
# ---------------------------------------------------------------------------

# Your code here
