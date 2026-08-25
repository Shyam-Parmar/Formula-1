 CREATE OR REPLACE VIEW season_standings_final_vw AS
  WITH driver_final AS (
         SELECT ra.year,
            ds.driver_id,
            ((d.forename || ' '::text) || d.surname) AS driver_name,
            ds.points,
            ds."position",
            ds.wins
           FROM ((driver_standings ds
             JOIN races ra ON ((ds.race_id = ra.race_id)))
             JOIN drivers d ON ((ds.driver_id = d.driver_id)))
          WHERE (ra.round = ( SELECT max(ra2.round) AS max
                   FROM (driver_standings ds2
                     JOIN races ra2 ON ((ds2.race_id = ra2.race_id)))
                  WHERE ((ra2.year = ra.year) AND (ds2.driver_id = ds.driver_id))))
        ), driver_margin AS (
         SELECT driver_final.year,
            (max(driver_final.points) FILTER (WHERE (driver_final."position" = (1)::double precision)) - max(driver_final.points) FILTER (WHERE (driver_final."position" = (2)::double precision))) AS margin
           FROM driver_final
          GROUP BY driver_final.year
        ), constructor_margin AS (
         SELECT constructor_season_standings_vw.season AS year,
            (max(constructor_season_standings_vw.final_points) FILTER (WHERE (constructor_season_standings_vw.final_position = (1)::double precision)) - max(constructor_season_standings_vw.final_points) FILTER (WHERE (constructor_season_standings_vw.final_position = (2)::double precision))) AS margin
           FROM constructor_season_standings_vw
          GROUP BY constructor_season_standings_vw.season
        )
 SELECT df.year,
    'driver'::text AS standings_type,
    df.driver_id AS entity_id,
    df.driver_name AS entity_name,
    df.points AS final_points,
    df."position" AS final_position,
    df.wins AS season_wins,
    dm.margin AS title_margin
   FROM (driver_final df
     JOIN driver_margin dm ON ((df.year = dm.year)))
UNION ALL
 SELECT cs.season AS year,
    'constructor'::text AS standings_type,
    cs.constructor_id AS entity_id,
    cs.constructor_name AS entity_name,
    cs.final_points,
    cs.final_position,
    cs.season_wins,
    cm.margin AS title_margin
   FROM (constructor_season_standings_vw cs
     JOIN constructor_margin cm ON ((cs.season = cm.year)))
  ORDER BY 1 DESC, 2, 6;