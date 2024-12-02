with stg_dim_tiempo AS(
    SELECT * 
    FROM {{ref("stg_dim_tiempo")}}
),

dim_tiempo AS(
    SELECT 
        date_id,
        year,
        month,
        day,
        week_of_year,
        quarter,
        day_of_week,
        is_weekend,
        month_name,
        day_name,
        quarter_name
    FROM stg_tiempo
)

SELECT * FROM dim_tiempo