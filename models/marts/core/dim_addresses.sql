with stg_addresses AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_addresses")}}
),

dim_addresses AS(
    SELECT *
    FROM stg_addresses
)

SELECT * FROM dim_addresses
