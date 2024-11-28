WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        first_name,
        last_name,
        address_id,
        replace(phone_number,'-','')::number as phone_number,
        email,
        
        convert_timezone('UTC', created_at) as created_at_UTC,
        convert_timezone('UTC', updated_at) as updated_at_UTC,
        
        CASE
            WHEN _fivetran_deleted = null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_users
    )

SELECT * FROM renamed_casted