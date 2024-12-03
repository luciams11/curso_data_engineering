{% snapshot stg_products_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_id', 'product_price_usd', 'stock'],
      invalidate_hard_deletes = true
    )
}}

select 
    product_id,
    product_price_usd,
    product_name,
    stock,
    is_deleted,
    date_load_UTC
from {{ ref('stg_sql_server_dbo_products') }}

{% endsnapshot %}