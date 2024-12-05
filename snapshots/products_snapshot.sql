{% snapshot products_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_id', 'price', 'inventory'],
      invalidate_hard_deletes = true
    )
}}

select 
    product_id,
    price,
    name,
    inventory,
    _fivetran_deleted,
    _fivetran_synced
from {{ source('sql_server_dbo', 'products') }}

{% endsnapshot %}