WITH users_info AS (
    SELECT * 
    FROM {{ ref("int_user_add_joined")}}
),

fct_orders AS (
    SELECT * 
    FROM {{ ref("fct_orders") }}
    ),

dim_promos AS (
    SELECT * 
    FROM {{ ref("dim_promos") }}
),

product_info AS(
    SELECT 
        product_id,
        product_name,
        product_price_usd
    FROM {{ ref('dim_products') }}
),

users_orders AS (
    SELECT
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.created_at_UTC,
        u.updated_at_UTC,
        u.address,
        u.zipcode,
        u.state,
        u.country,
        count(distinct o.order_id) as total_number_orders,
        sum((pi.product_price_usd*o.quantity)+o.shipping_cost_per_product_usd-p.discount_usd) as total_order_cost_usd,
        sum(o.shipping_cost_per_product_usd) as total_shipping_cost_usd,
        sum(p.discount_usd) as total_discount_usd,
        sum(o.quantity) as total_quantity_product,
        count(distinct o.product_id) as total_dif_product
    FROM users_info u
    LEFT JOIN fct_orders o
    ON u.user_id = o.user_id
    LEFT JOIN dim_promos p
    ON o.promo_id = p.promo_id
    LEFT JOIN product_info pi 
    ON o.product_id = pi.product_id
    group by u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.created_at_UTC,
        u.updated_at_UTC,
        u.address,
        u.zipcode,
        u.state,
        u.country
    order by u.state, u.address
    )

select * from users_orders