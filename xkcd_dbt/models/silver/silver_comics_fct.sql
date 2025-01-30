{{ config(
    materialized='incremental',
    unique_key='comic_id'
) }}


WITH bronze_comics as (
    SELECT * FROM {{ ref('bronze_comics') }}
),
gold_date as (
    SELECT * FROM {{ ref('gold_date_dim') }}
)

SELECT
comic_id,
date_id,
-- remove the space, dash, and parentheses from the title and multiply the number of letters by 5
LENGTH(REGEXP_REPLACE(title, r'[\s\(\)-]', '')) * 5 AS cost,
CAST(ROUND(rand() * 10000) as INT) as views, 
CAST(FLOOR(RAND() * 10) + 1 as INT) as reviews,
CURRENT_TIMESTAMP() as processed_at
FROM bronze_comics c
LEFT JOIN gold_date d
ON c.year = d.year AND c.month = d.month AND c.day = d.day
{% if is_incremental() %}
WHERE comic_id NOT IN (SELECT comic_id FROM {{ this }})
{% endif %}