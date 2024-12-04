{% snapshot products_snapshot %}

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
    origin_country,
    stock,
    is_deleted,
    date_load_UTC
from {{ source('sql_server_dbo', 'products') }}

{% endsnapshot %}