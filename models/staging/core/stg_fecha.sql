{{ 
    config(
        materialized='table', 
        sort='date_day',
        dist='date_day',
        pre_hook="alter session set week_start = 7;" 
        ) }}


WITH date_spine AS(
    {{ dbt_utils.date_spine(
            datepart="day",
            start_date="cast('2020-01-01' as timestamp)",
            end_date="cast('2022-01-01' as timestamp)"
        )
    }} 
),

time_dimension AS(
    SELECT
        date_day as date_id,
        YEAR(date_day) AS year,
        MONTH(date_day) AS month,
        DAY(date_day) AS day,
        WEEK(date_day) AS week_of_year,
        QUARTER(date_day) AS quarter,
        DAYOFWEEK(date_day) AS day_of_week,
        CASE 
            WHEN DAYOFWEEK(date_day) IN (6,0) THEN 'Weekend'
            ELSE 'Weekday'
        END AS is_weekend,
        MONTHNAME(date_day) as month_name,
        DAYNAME(date_day) as day_name,
        CASE
            WHEN MONTH(date_day) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN MONTH(date_day) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN MONTH(date_day) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END AS quarter_name
    FROM date_spine
)

SELECT * from time_dimension