{% set missing_count_query %}
  {{ missing_records_check('silver_comics_fct', 'bronze_comics', 'comic_id', 'comic_id') }}
{% endset %}

-- Run the query and check for missing records
select * from ({{ missing_count_query }}) as missing_count
where missing_count.missing_records_count > 0