{% macro missing_records_check(target_table, source_table, target_column, source_column) %}
  
  -- Generate a query to check missing records in the target table
  select
    count(*) as missing_records_count
  from
    {{ ref(target_table) }} tgt
  where
    tgt.{{ target_column }} not in (select {{ source_column }} from {{ ref(source_table) }})

{% endmacro %}
