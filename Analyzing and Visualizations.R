# --- PHASE 2: ANALYZING DATA AND CREATING VISUALIZATIONS ---

# Using 'all_trips_cleaned' for analysis

# 1. Overall Ride Length Summary
overall_ride_length_summary <- all_trips_cleaned %>%
  summarize(
    mean_ride_length = mean(ride_length),
    median_ride_length = median(ride_length),
    max_ride_length = max(ride_length),
    min_ride_length = min(ride_length)
  )
print("Overall Ride Length Summary:")
print(overall_ride_length_summary)

# 2. Ride Length by Member vs. Casual
ride_length_by_member_casual <- all_trips_cleaned %>%
  group_by(member_casual) %>%
  summarize(
    mean_ride_length = mean(ride_length),
    median_ride_length = median(ride_length),
    max_ride_length = max(ride_length),
    min_ride_length = min(ride_length)
  )
print("Ride Length by Member vs. Casual:")
print(ride_length_by_member_casual)

# 3. Total Rides by Member vs. Casual
total_rides_by_type <- all_trips_cleaned %>%
  group_by(member_casual) %>%
  summarize(total_rides = n()) %>%
  ungroup() # Always a good practice to ungroup after summarizing
print("Total Rides by Type:")
print(total_rides_by_type)


# 4. Total Rides and Ride Length by Day of Week and User Type
total_rides_by_day_and_type <- all_trips_cleaned %>%
  group_by(day_of_week, member_casual) %>%
  summarize(
    total_rides = n(),
    mean_ride_length = mean(ride_length),
    median_ride_length = median(ride_length)
  ) %>%
  ungroup() %>%
  arrange(day_of_week) # Arrange by day for consistent order
print("Total Rides & Ride Length by Day of Week and Type:")
print(total_rides_by_day_and_type)

# 5. Total Rides and Ride Length by Hour of Day and User Type
ride_length_by_hour_and_type <- all_trips_cleaned %>%
  group_by(hour_of_day, member_casual) %>%
  summarize(
    total_rides = n(),
    mean_ride_length = mean(ride_length),
    median_ride_length = median(ride_length)
  ) %>%
  ungroup() %>%
  arrange(hour_of_day)
print("Total Rides & Ride Length by Hour of Day and Type:")
print(ride_length_by_hour_and_type)

# 6. Total Rides by Month and User Type
total_rides_by_month_and_type <- all_trips_cleaned %>%
  group_by(month_of_year, member_casual) %>%
  summarize(total_rides = n()) %>%
  ungroup() %>%
  arrange(month_of_year) # Arrange by month for consistent order
print("Total Rides by Month and Type:")
print(total_rides_by_month_and_type)

# 7. Top Starting Stations by User Type (Top 10 as an example)
top_start_stations_by_type <- all_trips_cleaned %>%
  group_by(member_casual, start_station_name) %>%
  summarize(total_rides = n()) %>%
  ungroup() %>%
  group_by(member_casual) %>%
  top_n(10, total_rides) %>%
  arrange(member_casual, desc(total_rides))
print("Top 10 Starting Stations by User Type:")
print(top_start_stations_by_type)

# 8. Top Ending Stations by User Type (Top 10 as an example)
top_end_stations_by_type <- all_trips_cleaned %>%
  group_by(member_casual, end_station_name) %>%
  summarize(total_rides = n()) %>%
  ungroup() %>%
  group_by(member_casual) %>%
  top_n(10, total_rides) %>%
  arrange(member_casual, desc(total_rides))
print("Top 10 Ending Stations by User Type:")
print(top_end_stations_by_type)


# --- VISUALIZATION CODE (using ggplot2) ---

# Example: Total Rides by Day of Week and User Type (as seen in your R chart)
ggplot(data = total_rides_by_day_and_type, aes(x = day_of_week, y = total_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(
    title = "Total Rides by Day of Week and User Type",
    x = "Day of Week",
    y = "Total Rides",
    fill = "Rider Type"
  ) +
  scale_y_continuous(labels = scales::comma) + # Format y-axis as comma separated
  theme_minimal() +
  scale_fill_manual(values = c("casual" = "salmon", "member" = "darkturquoise")) # Customize colors
