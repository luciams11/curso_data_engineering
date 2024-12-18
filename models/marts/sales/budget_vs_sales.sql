with fct_budget AS(
    SELECT *
    FROM {{ref("fct_budget")}}
),

sales_per_month AS(
    SELECT *
    FROM {{ ref('agg_sales_per_month') }}
),

dim_tiempo AS(
    SELECT *
    FROM {{ ref('dim_tiempo') }}
),

budget_vs_sales AS(
    SELECT

        b.product_id,

        -- Fecha
        t.month_name as month,
        t.year as year,

        -- Comparación
        b.estimated_quantity,
        b.estimated_profit_usd,
        coalesce(s.total_quantity_product,0) as total_quantity_product_sold,
        coalesce(s.real_profit_usd,0) as real_profit_usd,

        -- Comprueba si se ha llegado al objetivo
        CASE 
            WHEN total_quantity_product_sold >= estimated_quantity THEN true
            ELSE false
        END AS budget_achieved,

        -- Métricas
        -- Diferencia cantidad
        coalesce(s.total_quantity_product,0) - b.estimated_quantity as quantity_diff,
        -- Diferencia beneficio
        coalesce(s.real_profit_usd,0) - b.estimated_profit_usd as profit_diff,

    FROM fct_budget b 
    JOIN dim_tiempo t
    ON b.month = t.date_id
    LEFT JOIN sales_per_month s
    ON b.product_id = s.product_id AND t.year = s.year AND t.month = s.month
)

SELECT * FROM budget_vs_sales 