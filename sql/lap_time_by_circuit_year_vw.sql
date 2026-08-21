 CREATE OR REPLACE VIEW lap_time_by_circuit_year_vw AS
  SELECT ra.year,
    ra.circuit_id,
    c.name AS circuit_name,
    c.country AS circuit_country,
    count(*) AS total_laps_recorded,
    round((avg(lt.milliseconds) / 1000.0), 3) AS avg_lap_time_seconds,
    round(((min(lt.milliseconds))::numeric / 1000.0), 3) AS fastest_lap_time_seconds
   FROM ((lap_times lt
     JOIN races ra ON ((lt.race_id = ra.race_id)))
     JOIN circuits c ON ((ra.circuit_id = c.circuit_id)))
  GROUP BY ra.year, ra.circuit_id, c.name, c.country
  ORDER BY c.name, ra.year;