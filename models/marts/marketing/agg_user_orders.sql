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

stg_promos AS (
    SELECT * 
    FROM {{ ref("stg_sql_server_dbo_promos") }}
),

stg_order_items AS (
    SELECT * 
    FROM {{ ref("stg_sql_server_dbo_order_items") }}
),

users_orders AS (
    SELECT
        u.user_id,
        first_name,
        email,
        phone_number,
        u.created_at_UTC,
        u.updated_at_UTC,
        a.address,
        a.zipcode,
        a.state,
        a.country,
        count(*) as total_number_orders,
        sum(o.order_cost_euros) as total_orders_cost_usd,
        sum(o.shipping_cost) as total_shipping_cost_usd,
        sum(p.discount_euros) as total_discount_usd,
        sum(i.quantity) as total_quantity_product,
        count(distinct i.product_id) as total_dif_product
    FROM stg_users u
    LEFT JOIN stg_addresses a
    ON u.address_id = a.address_id
    LEFT JOIN stg_orders o
    ON u.user_id = o.user_id
    LEFT JOIN stg_promos p
    ON o.promo_id = p.promo_id
    LEFT JOIN stg_order_items i 
    ON o.order_id = i.order_id
    group by user_id,
        first_name,
        email,
        phone_number,
        u.created_at_UTC,
        u.updated_at_UTC,
        a.address,
        a.zipcode,
        a.state,
        a.country
    )

select * from users_orders