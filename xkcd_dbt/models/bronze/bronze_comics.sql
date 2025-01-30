WITH raw_comics as (
    SELECT * FROM {{ source('xkcd_dataset', 'xkcd_comics') }}
) 

SELECT num as comic_id,
       title,
       safe_title,
       alt_text,
       img_url,
       transcript,
       link,
       news,
       year,
       month,
       day  
 FROM raw_comics