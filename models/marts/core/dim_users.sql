with stg_users AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_users")}}
),

dim_users AS(
    SELECT 
        user_id,
        first_name,
        last_name,
        address_id,
        phone_number,
        email,
        created_at_UTC,
        updated_at_UTC
    FROM stg_users
)

SELECT * FROM dim_users