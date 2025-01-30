{{ config(
    materialized='table',
    unique_key='date_id'
) }}

WITH date_series AS (
    -- Create a series of dates from '2006-01-01' to today's date because the XKCD dataset starts from 2006
    SELECT 
        DATE '2006-01-01' + INTERVAL x DAY AS date_value
    FROM UNNEST(GENERATE_ARRAY(0, DATE_DIFF(CURRENT_DATE(), DATE '2006-01-01', DAY))) AS x
)

SELECT
    -- Create unique key for each date
    EXTRACT(YEAR FROM date_value) * 10000 + EXTRACT(MONTH FROM date_value) * 100 + EXTRACT(DAY FROM date_value) AS date_id,
    -- The actual date
    date_value,
    -- Year, Quarter, Month, Day, and Weekday breakdowns
    EXTRACT(YEAR FROM date_value) AS year,
    EXTRACT(QUARTER FROM date_value) AS quarter,
    EXTRACT(MONTH FROM date_value) AS month,
    EXTRACT(DAY FROM date_value) AS day,
    CASE 
        WHEN EXTRACT(DAYOFWEEK FROM date_value) = 1 THEN 7  -- Sunday -> 7
        ELSE EXTRACT(DAYOFWEEK FROM date_value) - 1  -- Monday -> 1, Tuesday -> 2, etc.
    END AS day_of_week,
    CASE WHEN EXTRACT(DAYOFWEEK FROM date_value) = 1 THEN 'Sunday'
         WHEN EXTRACT(DAYOFWEEK FROM date_value) = 2 THEN 'Monday'
         WHEN EXTRACT(DAYOFWEEK FROM date_value) = 3 THEN 'Tuesday'
         WHEN EXTRACT(DAYOFWEEK FROM date_value) = 4 THEN 'Wednesday'
         WHEN EXTRACT(DAYOFWEEK FROM date_value) = 5 THEN 'Thursday'
         WHEN EXTRACT(DAYOFWEEK FROM date_value) = 6 THEN 'Friday'
         ELSE 'Saturday' END AS day_name,
    -- Week of the year
    EXTRACT(WEEK FROM date_value) AS week_of_year,

    DATE_SUB(date_value, INTERVAL (EXTRACT(DAYOFWEEK FROM date_value) - 2) DAY) AS start_of_week,  -- Adjust to Monday
    DATE_ADD(date_value, INTERVAL (8 - EXTRACT(DAYOFWEEK FROM date_value)) DAY) AS end_of_week,

    -- Is it a weekend? (Optional)
    CASE WHEN EXTRACT(DAYOFWEEK FROM date_value) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,

    -- Month name
    CASE EXTRACT(MONTH FROM date_value)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name
    
FROM date_series
