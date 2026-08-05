 CREATE OR REPLACE VIEW grid_finish_deltas_vw AS
 SELECT race_id,
    year,
    race_name,
    driver_id,
    driver_name,
    constructor_name,
    grid,
    position_order AS finish_position,
    finish_status,
        CASE
            WHEN (grid = (0)::double precision) THEN NULL::double precision
            ELSE (grid - (position_order)::double precision)
        END AS positions_gained
   FROM race_results_full_vw
  WHERE (position_order IS NOT NULL)
  ORDER BY year DESC, race_id,
        CASE
            WHEN (grid = (0)::double precision) THEN NULL::double precision
            ELSE (grid - (position_order)::double precision)
        END DESC NULLS LAST;