 CREATE OR REPLACE VIEW dnf_summary_vw AS
 SELECT year,
    constructor_id,
    constructor_name,
    finish_status AS status_reason,
        CASE
            WHEN ((finish_status = 'Finished'::text) OR (finish_status ~~ '+%Lap%'::text)) THEN 'classified'::text
            WHEN (finish_status = ANY (ARRAY['Did not qualify'::text, 'Did not prequalify'::text, 'Withdrew'::text])) THEN 'not_started'::text
            WHEN (finish_status = 'Disqualified'::text) THEN 'disqualified'::text
            ELSE 'dnf'::text
        END AS category,
    count(*) AS occurrences
   FROM race_results_full_vw
  GROUP BY year, constructor_id, constructor_name, finish_status
  ORDER BY year DESC, (count(*)) DESC;