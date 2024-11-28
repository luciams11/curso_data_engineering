with stg_dim_tiempo AS(
    SELECT * 
    FROM {{ref("stg_dim_tiempo")}}
),

dim_tiempo AS(
    SELECT *
    FROM stg_tiempo
)

SELECT * FROM dim_tiempo