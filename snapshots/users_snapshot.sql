{% snapshot users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at = 'updated_at',
      invalidate_hard_deletes = true
    )
}}

select *
from {{ source('sql_server_dbo', 'users') }}

{% endsnapshot %}