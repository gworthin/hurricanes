# Import Libraries
library(tidyverse)
library(dplyr)
library(broom)
library(USAboundaries)
library(sf)

# hur_state dataset from https://www.nhc.noaa.gov/data/hurdat/hurdat2-format-nov2019.pdf

# Remove geometry column from hur_state so I can manipulate the table
hur_state -> hurricanes

############################################
# Analysis of Number of Hurricanes by State
# Where are Hurricanes making landfall?
############################################

# Count the number of hurricanes in each state
hurricanes %>%
  group_by(state_abbr, id) %>%
  summarize(count = n()) %>%
  count(state_abbr, sort = TRUE) %>%
  rename(
    num_hurricanes = n
  ) -> num_hurricanes_by_state

# Get the map of U.S. States from sf
us_states <- us_states("2000-12-31")

# Omit Alaska and Hawaii from the map
us_contiguous <- subset(us_states, name!="Alaska" & name!="Hawaii")

# Add the number of hurricanes to the us_contiguous table
us_contiguous %>%
  left_join(
    num_hurricanes_by_state,
    by = "state_abbr"
  ) -> us_contiguous

# Change NA values to 0 (12 states didn't have any hurricanes and don't show up
# on the hurricanes dataset)
us_contiguous[is.na(us_contiguous)] <- 0 

# Set the CRS and graticule
laea = st_crs("+proj=laea +lat_0=30 +lon_0=-95") # Lambert equal area
us_contiguous <- st_transform(us_contiguous, laea)
g = st_graticule(us_contiguous, lon = seq(-130,-65,5))

# Plot
plot(us_contiguous['num_hurricanes'], 
     breaks = "jenks", 
     graticule = TRUE, 
     axes = TRUE,
     main = "Number of Hurricanes by State from 1850 - 2019")

############################################
# Analysis of Number of Hurricanes Per Year
############################################

# Count the number of named hurricanes each year
hurricanes %>%
  group_by(year, id) %>%
  summarize(count = n()) %>% 
  count(year) %>%
  rename(num_hurricanes = n) -> num_hurricanes_by_year

# Table showing every year and the number of hurricanes in that year
view(num_hurricanes_by_year)

#Linear regression model predicting the number of hurricanes based on the year
mod.count <- lm(
  num_hurricanes ~ year,
  data=num_hurricanes_by_year
)

# Get the summary statistics for the model
summary(mod.count)

# Plot the scatterplot with the linear regression line from the summary statistics
ggplot(num_hurricanes_by_year, aes(x = year, y = num_hurricanes)) +
  geom_point() +
  geom_abline(slope=0.07440, intercept=-132.74536, size=0.5, color = "red") +
  theme_bw() +
  ggtitle("Number of Hurricanes by Year") +
  xlab("Year") + 
  ylab("Number of Hurricanes")

##########################################
# Analysis of Category 4 and 5 Hurricanes
##########################################

# Count the number of category 4 or 5 hurricanes per decade
hurricanes %>%
  filter(windmph >= 130) %>% # Category 4 hurricanes have wind speed 130 or faster
  group_by(year, id) %>%
  summarize(count = n()) %>%
  count(year) %>%
  rename(num_hurricanes = n) %>% # Count of cat 4 or 5 storms per year
  mutate(
    Decade = floor(year / 10) * 10 
  ) %>% # Adds a decade column to the data frame
  group_by(Decade) %>% 
  summarize(num_hurricanes = sum(num_hurricanes)) -> num_cat_hurricanes_by_decade

# Table of decades and the number of category 4 or 5 storms
view(num_cat_hurricanes_by_decade)

# Plot a line graph
ggplot(num_cat_hurricanes_by_decade, aes(x = Decade, y = num_hurricanes)) +
  geom_line() +
  theme_bw() +
  ggtitle("Number of Category 4 or 5 Hurricanes by Decade") +
  xlab("Decade starting at that year (Decade spans years XXX0 - XXX9)") + 
  ylab("Number of Category 4 or 5 Hurricanes")

