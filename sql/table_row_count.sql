select
  relname as table_name,
  n_live_tup as row_count
from pg_stat_user_tables
where schemaname = 'public'
order by n_live_tup desc;