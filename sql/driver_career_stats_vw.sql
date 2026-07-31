 create or replace view driver_career_stats_vw as
 SELECT driver_id,
    driver_name,
    driver_nationality,
    count(*) AS races_started,
    count(*) FILTER (WHERE (position_order = 1)) AS wins,
    count(*) FILTER (WHERE (position_order <= 3)) AS podiums,
    count(*) FILTER (WHERE (grid = (1)::double precision)) AS poles,
    count(*) FILTER (WHERE ((finish_status <> 'Finished'::text) AND (finish_status !~~ '+%Lap%'::text))) AS dnfs,
    sum(points) AS career_points,
    min(year) AS first_season,
    max(year) AS last_season,
    round(avg(position_order) FILTER (WHERE (position_order IS NOT NULL)), 2) AS avg_finish_position
   FROM race_results_full_vw
  GROUP BY driver_id, driver_name, driver_nationality
  ORDER BY (sum(points)) DESC;