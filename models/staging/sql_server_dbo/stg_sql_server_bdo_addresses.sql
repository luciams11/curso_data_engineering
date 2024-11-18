WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
    	address_id,
        zipcode int(5),
        country varchar(40),
        address,
        state varchar(40),
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM src_addresses
    )

SELECT * FROM renamed_casted