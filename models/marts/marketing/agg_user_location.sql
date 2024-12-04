WITH user_address AS (
    SELECT *
    FROM {{ ref('int_user_info') }}
),

agg_user_location AS(
    SELECT
        state,
        country,
        zipcode,
        COUNT(user_id) AS total_users,
        COUNT(DISTINCT state) AS unique_states,
        COUNT(DISTINCT country) AS unique_countries,
        COUNT(DISTINCT zipcode) AS unique_zipcodes
    FROM user_address
    GROUP BY state, country, zipcode
    ORDER BY country, state, zipcode
)

SELECT * from agg_user_location