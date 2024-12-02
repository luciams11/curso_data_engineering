with stg_users AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_users")}}
),

stg_addresses AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_addresses') }}
),

users_info AS(
    SELECT 
        u.user_id,
        u.first_name,
        u.last_name,
        u.address_id,
        a.address,
        a.state,
        a.country,
        a.zipcode,
        u.phone_number,
        u.email,
        u.created_at_UTC,
        u.updated_at_UTC
    FROM stg_users u
    LEFT JOIN stg_addresses a
    ON u.address_id = a.address_id
)

SELECT * FROM users_info