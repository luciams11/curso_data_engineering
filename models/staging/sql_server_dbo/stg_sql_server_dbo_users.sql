WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        convert_timezone('UTC', updated_at) as updated_at_UTC,
        address_id,
        last_name,
        convert_timezone('UTC', created_at) as created_at_UTC,
        replace(phone_number,'-','')::number as phone_number,
        first_name,
        email,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_users
    )

SELECT * FROM renamed_casted