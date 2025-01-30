{{ config(
    materialized='incremental',
    unique_key='comic_id'
) }}

WITH bronze_comics as (
    SELECT * FROM {{ ref('bronze_comics') }}
)

SELECT DISTINCT
    comic_id,
    title,
    safe_title,
    alt_text,
    img_url,
    transcript,
    link,
    news,
    CURRENT_TIMESTAMP() AS processed_at
FROM bronze_comics
{% if is_incremental() %}
WHERE comic_id NOT IN (SELECT comic_id FROM {{ this }})
{% endif %}
