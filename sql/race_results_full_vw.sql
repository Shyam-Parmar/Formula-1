create or replace view race_results_full as
select
    r.result_id,
    ra.race_id,
    ra.year,
    ra.round,
    ra.name as race_name,
    ra.date as race_date,
    c.name as circuit_name,
    c.country as circuit_country,
    d.driver_id,
    d.forename || ' ' || d.surname as driver_name,
    d.code as driver_code,
    d.nationality as driver_nationality,
    con.constructor_id,
    con.name as constructor_name,
    con.nationality as constructor_nationality,
    r.grid,
    r.position,
    r.position_order,
    r.position_text,
    r.points,
    r.laps,
    r.time as race_time,
    r.milliseconds,
    r.fastest_lap,
    r.fastest_lap_time,
    r.fastest_lap_speed,
    r.rank as fastest_lap_rank,
    st.status as finish_status
from results r
join races ra on r.race_id = ra.race_id
join drivers d on r.driver_id = d.driver_id
join constructors con on r.constructor_id = con.constructor_id
join circuits c on ra.circuit_id = c.circuit_id
join status st on r.status_id = st.status_id;