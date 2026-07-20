CREATE TABLE IF NOT EXISTS circuits (
  "circuit_id" bigint,
  "circuit_ref" text,
  "name" text,
  "location" text,
  "country" text,
  "lat" double precision,
  "lng" double precision,
  "alt" bigint,
  "url" text,
  PRIMARY KEY ("circuit_id")
);

CREATE TABLE IF NOT EXISTS constructors (
  "constructor_id" bigint,
  "constructor_ref" text,
  "name" text,
  "nationality" text,
  "url" text,
  PRIMARY KEY ("constructor_id")
);
  
CREATE TABLE IF NOT EXISTS constructor_results (
  "constructor_results_id" bigint,
  "race_id" bigint,
  "constructor_id" bigint,
  "points" double precision,
  "status" text,
  PRIMARY KEY ("constructor_results_id")
);

CREATE TABLE IF NOT EXISTS constructor_standings (
  "constructor_standings_id" bigint,
  "race_id" bigint,
  "constructor_id" bigint,
  "points" double precision,
  "position" double precision,
  "position_text" text,
  "wins" bigint,
  PRIMARY KEY ("constructor_standings_id")
);

CREATE TABLE IF NOT EXISTS drivers (
  "driver_id" bigint,
  "driver_ref" text,
  "number" double precision,
  "code" text,
  "forename" text,
  "surname" text,
  "dob" text,
  "nationality" text,
  "url" text,
  PRIMARY KEY ("driver_id")
);

CREATE TABLE IF NOT EXISTS driver_standings (
  "driver_standings_id" bigint,
  "race_id" bigint,
  "driver_id" bigint,
  "points" double precision,
  "position" double precision,
  "position_text" text,
  "wins" bigint,
  PRIMARY KEY ("driver_standings_id")
);

CREATE TABLE IF NOT EXISTS lap_times (
  "race_id" bigint,
  "driver_id" bigint,
  "lap" bigint,
  "position" bigint,
  "time" NUMERIC(6,3),
  "milliseconds" bigint,
  PRIMARY KEY ("race_id", "driver_id", "lap")
);

CREATE TABLE IF NOT EXISTS pit_stops (
  "race_id" bigint,
  "driver_id" bigint,
  "stop" bigint,
  "lap" bigint,
  "time" NUMERIC(10,3),
  "duration" NUMERIC(6,3),
  "milliseconds" bigint,
  PRIMARY KEY ("race_id", "driver_id", "stop")
);

CREATE TABLE IF NOT EXISTS qualifying (
  "qualify_id" bigint,
  "race_id" bigint,
  "driver_id" bigint,
  "constructor_id" bigint,
  "number" bigint,
  "position" bigint,
  "q1" NUMERIC(7,3),
  "q2" NUMERIC(7,3),
  "q3" NUMERIC(7,3),
  PRIMARY KEY ("qualify_id")
);

CREATE TABLE IF NOT EXISTS races (
  "race_id" bigint,
  "year" bigint,
  "round" bigint,
  "circuit_id" bigint,
  "name" text,
  "date" DATE,
  "time" TIME (3),
  "url" text,
  "fp1_date" DATE,
  "fp1_time" TIME (3),
  "fp2_date" DATE,
  "fp2_time" TIME (3),
  "fp3_date" DATE,
  "fp3_time" TIME (3),
  "quali_date" DATE,
  "quali_time" TIME (3),
  "sprint_date" DATE,
  "sprint_time" TIME (3),
  PRIMARY KEY ("race_id")
);

CREATE TABLE IF NOT EXISTS results (
  "result_id" bigint,
  "race_id" bigint,
  "driver_id" bigint,
  "constructor_id" bigint,
  "number" double precision,
  "grid" double precision,
  "position" double precision,
  "position_text" text,
  "position_order" bigint,
  "points" double precision,
  "laps" bigint,
  "time" NUMERIC(9,3),
  "milliseconds" BIGINT,
  "fastest_lap" double precision,
  "rank" double precision,
  "fastest_lap_time" NUMERIC(6,3),
  "fastest_lap_speed" NUMERIC(6,3),
  "status_id" bigint,
  PRIMARY KEY ("result_id")
);

CREATE TABLE IF NOT EXISTS seasons (
  "year" bigint,
  "url" text,
  PRIMARY KEY ("year")
);

CREATE TABLE IF NOT EXISTS sprint_results (
  "result_id" bigint,
  "race_id" bigint,
  "driver_id" bigint,
  "constructor_id" bigint,
  "number" bigint,
  "grid" bigint,
  "position" double precision,
  "position_text" text,
  "position_order" bigint,
  "points" bigint,
  "laps" bigint,
  "time" NUMERIC(9,3),
  "milliseconds" BIGINT,
  "fastest_lap" double precision,
  "fastest_lap_time" NUMERIC(6,3),
  "status_id" double precision,
  "rank" double precision,
  PRIMARY KEY ("result_id")
);

CREATE TABLE IF NOT EXISTS status (
  "status_id" bigint,
  "status" text,
  PRIMARY KEY ("status_id")
);

