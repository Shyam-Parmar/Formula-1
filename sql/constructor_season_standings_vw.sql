CREATE OR REPLACE VIEW constructor_season_standings_vw AS
SELECT ra.year AS season,
  con.constructor_id,
  con.name AS constructor_name,
  con.nationality AS constructor_nationality,
  cs.points AS final_points,
  cs."position" AS final_position,
  cs.wins AS season_wins
  FROM ((constructor_standings cs
    JOIN races ra ON ((cs.race_id = ra.race_id)))
    JOIN constructors con ON ((cs.constructor_id = con.constructor_id)))
WHERE (ra.round = ( SELECT max(ra2.round) AS max
          FROM (constructor_standings cs2
            JOIN races ra2 ON ((cs2.race_id = ra2.race_id)))
        WHERE ((ra2.year = ra.year) AND (cs2.constructor_id = cs.constructor_id))))
ORDER BY ra.year DESC, cs."position";