# --- PHASE 1: PROCESSING AND COMBINING DATA ---

# 1. Load Required Libraries
# If you don't have these installed, run install.packages("package_name") first
library(tidyverse) # Includes dplyr, ggplot2, readr, etc.
library(lubridate) # For date/time manipulation
library(readr)     # For efficient reading of CSV files

# 2. Set Working Directory (if needed, e.g., in Posit Cloud)
# setwd("/cloud/project") # Uncomment and modify if your files are not in the default directory

# 3. Load Raw Data Files
# Ensure these CSV files are in your working directory or provide the full path
divvy_2019_q1 <- read_csv("Divvy_Trips_2019_Q1 - Divvy_Trips_2019_Q1.csv")
divvy_2020_q1 <- read_csv("Divvy_Trips_2020_Q1 - Divvy_Trips_2020_Q1.csv")

# 4. Standardize Column Names and Types for 2019 Q1
# Rename columns to match 2020 Q1's naming convention for consistency
divvy_2019_q1 <- divvy_2019_q1 %>%
  rename(ride_id = trip_id,
         rideable_type = bikeid,
         started_at = start_time,
         ended_at = end_time,
         start_station_name = from_station_name,
         start_station_id = from_station_id,
         end_station_name = to_station_name,
         end_station_id = to_station_id,
         member_casual = usertype) %>%
  # Convert ID columns to character type to match 2020 data
  mutate(ride_id = as.character(ride_id),
         rideable_type = as.character(rideable_type))

# 5. Select and Arrange Columns for 2020 Q1 (to match 2019 after renaming)
# Ensure both data frames have the same columns in the same order before combining
divvy_2020_q1 <- divvy_2020_q1 %>%
  select(ride_id, rideable_type, started_at, ended_at,
         start_station_name, start_station_id, end_station_name,
         end_station_id, start_lat, start_lng, end_lat, end_lng,
         member_casual)

# 6. Combine Datasets
all_trips <- bind_rows(divvy_2019_q1, divvy_2020_q1)

# 7. Unify 'member_casual' Column Categories
# Convert "Customer" to "casual" and "Subscriber" to "member"
all_trips <- all_trips %>%
  mutate(member_casual = case_when(
    member_casual == "Customer" ~ "casual",
    member_casual == "Subscriber" ~ "member",
    TRUE ~ member_casual # Keeps 'casual' and 'member' as is for 2020 data
  ))

# 8. Create New Time-Based Features
all_trips <- all_trips %>%
  mutate(
    # Convert character dates to datetime objects
    started_at = ymd_hms(started_at),
    ended_at = ymd_hms(ended_at),
    # Calculate ride length in minutes
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    # Extract day of the week (e.g., "Monday")
    day_of_week = wday(started_at, label = TRUE, abbr = FALSE),
    # Extract hour of the day
    hour_of_day = hour(started_at),
    # Extract month of the year
    month_of_year = month(started_at, label = TRUE, abbr = FALSE)
  )

# 9. Perform Data Cleaning (Filter out problematic rides)
# Remove rides with duration <= 0 minutes (errors) and NA station names
all_trips_cleaned <- all_trips %>%
  filter(ride_length > 0) %>%
  filter(!is.na(start_station_name) & !is.na(end_station_name))

# At this point, 'all_trips_cleaned' is your primary data frame for analysis
