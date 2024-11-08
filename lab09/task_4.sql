SELECT 
    climbs.climb_name AS "name", 
    climb_grades.grade_str AS "grade", 
    climbs.climb_len_ft AS "length (Ft)", 
    crags.crag_name AS "crag", 
    GROUP_CONCAT(DISTINCT first_ascender.climber_first_name ORDER BY first_ascender.climber_first_name ASC SEPARATOR ', ') AS "first ascent by", 
    GROUP_CONCAT(DISTINCT equipper.climber_first_name ORDER BY equipper.climber_first_name ASC SEPARATOR ', ') AS "equipped by"
FROM climbs
LEFT JOIN climb_grades ON climbs.grade_id = climb_grades.grade_id
LEFT JOIN crags ON climbs.crag_id = crags.crag_id
LEFT JOIN climber_first_ascents ON climber_first_ascents.climb_id = climbs.climb_id
LEFT JOIN climbers AS first_ascender ON climber_first_ascents.climber_id = first_ascender.climber_id
LEFT JOIN climber_climbs_established ON climber_climbs_established.climb_id = climbs.climb_id
LEFT JOIN climbers AS equipper ON climber_climbs_established.climber_id = equipper.climber_id
GROUP BY climbs.climb_id;

-- pull all desired fields and display it for all of the climbs
-- group duplicate first ascents and equippers
-- used left join to show all climbs even if there is no first ascents or equippers