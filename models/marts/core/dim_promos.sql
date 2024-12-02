with stg_promos AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_promos")}}
),

dim_promos AS(
    SELECT 
        promo_id,
        promo_name,
        discount_usd,
        promo_status
    FROM stg_users
)

SELECT * FROM dim_promos