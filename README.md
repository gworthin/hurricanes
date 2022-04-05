# hurricanes

`Hurricanes.R` contains three separate analsyses on all recorded hurricanes in the United States. The `hur_state` dataframe is from the National Hurricane Center's [HURDAT2](https://www.nhc.noaa.gov/data/hurdat/hurdat2-format-nov2019.pdf) dataset.

The first analysis creates a map of the U.S. showing the number of unique hurricanes that have made landfall in each state. The resulting map is `Map.png`. From the map, it's clear that hurricanes arrive in the U.S. from the southeast, mostly affecting states including Florida, Georgia, North  Carolina, and Texas.

The second analysis creates a scatterplot of the number of unique hurricanes every year since 1851 with a line of best fit. This is stored in `Number.png` There is a slightly weak, positive relationship where  every 13 years, there is an average increase of one hurricane recorded in the  U.S. (0.4191  adj. R-sq). 

The final analysis creates a line graph of the number of severe storms (category 4 or 5) recorded in each decade. This is visible in `Category.png`. In this graph, the relationship between year and hurricane severity is very obvious, with the two most recent decades – 2000-09 and 2010-19 – seeing the most category 4 or 5 hurricanes. In just 30 years since 1990, there have been more of these severe storms in the U.S. than between 1850 and 1939. There’s a noticeable dip in storms in the 70s and 80s, but that can be explained by missing wind data for various years in that time period.  
