 CREATE OR REPLACE VIEW teammate_comparisons_vw AS
 SELECT a.race_id,
    a.year,
    a.race_name,
    a.constructor_id,
    a.constructor_name,
    a.driver_id,
    a.driver_name,
    b.driver_id AS teammate_id,
    b.driver_name AS teammate_name,
    a.grid AS driver_grid,
    b.grid AS teammate_grid,
    a.position_order AS driver_finish,
    b.position_order AS teammate_finish,
    a.points AS driver_points,
    b.points AS teammate_points,
    qa."position" AS driver_quali_position,
    qb."position" AS teammate_quali_position,
        CASE
            WHEN ((a.position_order IS NULL) OR (b.position_order IS NULL)) THEN NULL::boolean
            ELSE (a.position_order < b.position_order)
        END AS beat_teammate_race,
        CASE
            WHEN ((qa."position" IS NULL) OR (qb."position" IS NULL)) THEN NULL::boolean
            ELSE (qa."position" < qb."position")
        END AS beat_teammate_quali
   FROM (((race_results_full_vw a
     JOIN race_results_full_vw b ON (((a.race_id = b.race_id) AND (a.constructor_id = b.constructor_id) AND (a.driver_id <> b.driver_id))))
     LEFT JOIN qualifying qa ON (((qa.race_id = a.race_id) AND (qa.driver_id = a.driver_id))))
     LEFT JOIN qualifying qb ON (((qb.race_id = b.race_id) AND (qb.driver_id = b.driver_id))))
  ORDER BY a.year DESC, a.race_id, a.constructor_name, a.driver_name;