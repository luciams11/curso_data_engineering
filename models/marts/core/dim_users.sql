with stg_users AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_users")}}
),

dim_users AS(
    SELECT *
    FROM stg_users
)

SELECT * FROM dim_users