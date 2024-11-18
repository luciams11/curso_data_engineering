
{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['product_id', 'month'])}} as budget_id,
        month,
        product_id,
        quantity,
        _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted