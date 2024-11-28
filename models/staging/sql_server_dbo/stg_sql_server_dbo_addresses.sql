WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
    	address_id,
        address,
        state,
        country,
        zipcode,
        CASE
            WHEN _fivetran_deleted is null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_addresses
    )

SELECT * FROM renamed_casted