select
  usename as db_user,
  application_name,
  client_addr,
  count(*) as connections
from pg_stat_activity
where datname = current_database()
group by usename, application_name, client_addr
order by connections desc;