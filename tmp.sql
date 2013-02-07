WITH dists AS
  SELECT distance FROM generate_series(
    (SELECT min(distance) FROM edges WHERE scenario_id=42), 
    (SELECT max(distance) FROM edges WHERE scenario_id=42),
    (SELECT (max(distance) - min(distance)) / 5 FROM edges
      WHERE scenario_id=42)) as distance
SELECT * from dists
