DELETE FROM climber_climbs_established
WHERE climb_id IN (
    SELECT climb_id FROM climbs WHERE climb_established_date >= '2010-01-01'
);

DELETE FROM climber_first_ascents
WHERE climb_id IN (
    SELECT climb_id FROM climbs WHERE climb_established_date >= '2010-01-01'
);

DELETE FROM climbs
WHERE climb_established_date >= '2010-01-01';

-- delete rows in `climber_climbs_established` where the climb was established in 2010 or later
-- delete rows in `climber_first_ascents` where the climb was established in 2010 or later
-- then deleted the routes from `climbs` that were equipped in 2010 or more recently