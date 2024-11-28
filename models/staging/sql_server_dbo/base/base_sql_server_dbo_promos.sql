WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['promo_id'])}} as promo_id,
        lower(promo_id) as promo_name,
        discount as discount_usd,
        status as promo_status,
        CASE
            WHEN _fivetran_deleted = null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_promos
    )

SELECT * FROM renamed_casted