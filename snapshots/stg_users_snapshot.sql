{% snapshot stg_users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at = 'updated_at_UTC',
      invalidate_hard_deletes = true
    )
}}

select 
    user_id,
    first_name,
    last_name,
    address_id,
    phone_number,
    email,
    created_at_UTC,
    updated_at_UTC,
    is_deleted,
    date_load_UTC
from {{ ref('stg_sql_server_dbo_users') }}

{% endsnapshot %}