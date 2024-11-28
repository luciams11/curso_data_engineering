WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
    	address_id,
        zipcode::number(5) as zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_addresses
    )

SELECT * FROM renamed_casted