# Google Data Analytics Capstone: Cyclistic Bike-Share Analysis (R-based)

## Project Overview

This project is a case study for Cyclistic, a fictional bike-share company in Chicago. As a junior data analyst, I analyzed historical bike trip data to understand **how casual riders and annual members use Cyclistic bikes differently**. The insights from this analysis aim to inform a new marketing strategy to convert casual riders into more profitable annual members.

## Business Task

The core business task driving this analysis is: **How do annual members and casual riders use Cyclistic bikes differently?**

## Data Source

The analysis utilizes Cyclistic's historical trip data for Q1 2019 and Q1 2020:
* `Divvy_Trips_2019_Q1 - Divvy_Trips_2019_Q1.csv`
* `Divvy_Trips_2020_Q1 - Divvy_Trips_2020_Q1.csv`

These public datasets were provided by Motivate International Inc. under this [license](https://divvybikes.com/data/licensing-agreement).

## Tools Used

* **R** (Programming Language)
* **RStudio** (Integrated Development Environment)
* **`readr`** (R package for efficient data loading)
* **`dplyr`** (R package for data manipulation and transformation)
* **`lubridate`** (R package for easy date and time handling)
* **`ggplot2`** (R package for creating high-quality data visualizations)

## Data Processing and Cleaning (in R)

The following key steps were performed in R to prepare the data for analysis:

1.  **Load Packages:** Necessary R packages (`readr`, `dplyr`, `lubridate`, `ggplot2`) were loaded.
2.  **Load Data:** The 2019 Q1 and 2020 Q1 CSV files were read into R data frames (`divvy_2019_q1`, `divvy_2020_q1`).
3.  **Standardize Column Names & Types:**
    * For `divvy_2019_q1`, columns like `start_time`, `end_time`, and `usertype` were `rename`d to `started_at`, `ended_at`, and `member_casual` respectively. `trip_id` and `bikeid` were converted to character types to match 2020 data.
    * For `divvy_2020_q1`, unnecessary columns were `select`ed out to ensure consistent columns for binding.
4.  **Combine Data:** The two data frames were combined into a single `all_trips` data frame using `bind_rows()`.
5.  **Unify `member_casual` Categories:** A critical step involved using `mutate()` with `case_when()` to standardize the `member_casual` column. "Customer" from 2019 data was mapped to "casual", and "Subscriber" to "member", ensuring only "casual" and "member" categories remained for consistent analysis.
6.  **Create New Variables:**
    * `started_at` and `ended_at` were converted from character to datetime objects using `ymd_hms()`.
    * `ride_length` (in minutes) was calculated using `difftime()` between `ended_at` and `started_at`.
    * `day_of_week` (full name, e.g., "Sunday") was extracted from `started_at` using `wday()`.
    * `hour_of_day` and `month_of_year` were extracted for further time-based analysis.
7.  **Clean Data:** Rides with a `ride_length` of zero or less (indicating errors) were removed using `filter(ride_length > 0)`. Also, rows with missing station names were filtered out.

## Key Findings and Insights

The analysis of how casual riders and annual members use Cyclistic bikes differently revealed distinct patterns:

* **Ride Duration:**
    * **Casual riders take significantly longer trips than annual members.** The mean ride length for casual riders was approximately 85.1 minutes, while for members it was around 13.3 minutes.
    * This difference is particularly pronounced on **weekends**, where casual riders' average ride length increases even further, suggesting leisure or recreational use.
    * Members' ride lengths remain relatively consistent across days and times.

* **Usage Patterns by Day of Week:**
    * **Members consistently use bikes more frequently on weekdays,** indicating a strong tendency for commuting or routine daily trips.
    * **Casual riders predominantly use bikes on weekends,** with a clear peak in total rides on Saturdays and Sundays. Their weekday usage is significantly lower. This pattern strongly suggests leisure or recreational purposes for their rides.

* **Overall Ride Volume:**
    * While casual riders take longer trips, **annual members contribute a substantially higher total number of rides** (approx. 720,313 rides for members vs. 71,433 for casuals in the analyzed period), highlighting their consistent engagement and value.

* **Time of Day and Monthly Usage:**
    * Members show two daily peaks aligned with typical commuting hours (e.g., 6-8 AM and 4-8 PM).
    * Casual riders' usage generally increases throughout the day until the evening.
    * Both groups exhibit higher ridership in spring and summer months, with a notable increase in casual rider engagement during these warmer periods.

* **Station Popularity:**
    * **Casual riders frequently start and end their trips at stations located near tourist attractions and recreational areas** (e.g., HQ QR, Streeter Dr & Grand Ave, Lake Shore Dr & Monroe St, Shedd Aquarium).
    * **Members' most popular stations are typically in business districts, residential areas, and transport hubs** (e.g., Canal St & Adams St, Clinton St & Washington Blvd, Clinton St & Madison St). This indicates distinct purposes for their rides.

### Summary:

| Feature           | Casual Riders                                                                                                 | Members                                                                                            |
| :---------------- | :------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------- |
| **Usage Pattern** | Prefer longer, less frequent rides, peaking on weekends, especially in spring and summer, for leisure/recreation. | Prefer shorter, more frequent rides, predominantly on weekdays, likely for commuting and routine trips. |
| **Ride Duration** | Average ride length around 85.1 mins (approx. 2x longer than members).                                        | Average ride length around 13.3 mins (approx. half of casual riders' duration).                     |
| **Peak Usage** | Weekends (Saturday, Sunday) and mid-day hours.                                                              | Weekdays and typical commuting hours (e.g., 6-8 AM, 4-8 PM).                                       |
| **Station Use** | Frequent stations near tourist attractions, parks, lakefronts, museums.                                       | Frequent stations in business districts, residential areas, transport hubs.                        |

## Recommendations

Based on these findings, here are the top three actionable marketing strategies to convert casual riders into annual members:

1.  **Seasonal Weekend Membership Campaigns:** Launch targeted marketing campaigns during spring and summer, emphasizing special weekend-only or seasonal membership options. Promote these directly at popular casual rider stations (e.g., parks, lakefronts, tourist spots) or through digital ads targeting users in those locations on weekends.
2.  **Highlight Value for Longer, Leisure Rides:** Develop messaging that showcases the significant cost savings an annual membership offers for casual riders who enjoy longer, more frequent leisure rides. Emphasize "unlimited rides" or "freedom to explore for longer" as key benefits over single-ride passes.
3.  **Flexible Membership Tiers:** Consider introducing new membership tiers that might appeal to casual riders' less frequent but longer-duration use, such as a "weekend warrior" pass or a "leisure-focused" annual membership with perks tailored to their specific riding habits.
