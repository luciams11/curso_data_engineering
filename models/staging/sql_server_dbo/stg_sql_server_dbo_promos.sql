WITH base_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

add_promo AS (
    SELECT
        promo_id,
        promo_name,
        discount_usd,
        promo_status,
        is_deleted,
        date_load_UTC
    FROM base_promos

    UNION ALL

    SELECT 
        {{dbt_utils.generate_surrogate_key(["'no promo'"])}} as promo_id,
        'no promo' as promo_name,
        0 as discount_usd,
        'active' as promo_status,
        false as is_deleted,
        convert_timezone('UTC', CURRENT_TIMESTAMP) AS date_load_UTC
    )

SELECT * FROM add_promo