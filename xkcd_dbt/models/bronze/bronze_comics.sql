-- this model will use incremental load
{{ config(
    materialized='incremental',
    unique_key='comic_id'
) }}

WITH raw_comics as (
    SELECT * FROM {{ source('xkcd_dataset', 'xkcd_comics') }}
) 

SELECT num as comic_id,
       title,
       safe_title,
       alt as alt_text,
       img as img_url,
       transcript,
       link,
       news,
       year,
       month,
       day,
       source_file_name,
       source_file_path,
       CURRENT_TIMESTAMP() AS created_at  
FROM raw_comics
{% if is_incremental() %}
WHERE num NOT IN (SELECT comic_id FROM {{ this }})  -- Only insert new comics
{% endif %}