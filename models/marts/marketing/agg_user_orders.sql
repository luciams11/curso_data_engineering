WITH stg_users AS (
    SELECT * 
    FROM {{ ref("stg_sql_server_dbo_users")}}
),

stg_addresses AS (
    SELECT * 
    FROM {{ ref("stg_sql_server_dbo_addresses") }}
    ),

stg_orders AS (
    SELECT * 
    FROM {{ ref("stg_sql_server_dbo_orders") }}
    ),



users_orders AS (
    SELECT
        u.user_id,
        first_name,
        email,
        phone_number,
        u.created_at_UTC,
        u.updated_at_UTC,
        u.address,
        a.zipcode,
        a.state,
        a.country,
        count(*) as total_number_orders,
        sum(o.order_cost) as total_orders_cost_usd,
        sum(o.shipping_cost) as total_shipping_cost_usd,
        sum(o.disc) as total_discount_usd,
        sum() as total_quantity_product,
        sum() as total_dif_product
    FROM src_users u
    LEFT JOIN src_addresses a
    ON u.address_id = a.address_id
    LEFT JOIN src_orders o
    ON u.user_id = o.user_id
    group by user_id
    )

select * from events_users