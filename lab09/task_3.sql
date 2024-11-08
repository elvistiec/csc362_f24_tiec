SELECT climbers.climber_first_name, COUNT(climber_climbs_established.climb_id) AS routes_established
FROM climber_climbs_established
JOIN climbers ON climber_climbs_established.climber_id = climbers.climber_id
GROUP BY climbers.climber_id
ORDER BY routes_established DESC
LIMIT 3;

-- pull all names of the climber and counts how many times the id has been repeated (find how many climbs established)
-- join the tables and put it in descending order from routes_established, limit only top 3