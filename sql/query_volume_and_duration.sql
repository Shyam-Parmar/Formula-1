select
  query,
  calls,
  round(total_exec_time::numeric, 2) as total_time_ms,
  round(mean_exec_time::numeric, 2) as avg_time_ms
from pg_stat_statements
order by total_exec_time desc
limit 20;