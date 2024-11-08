UPDATE climbs 
JOIN climb_grades AS cg_old ON climbs.grade_id = cg_old.grade_id AND cg_old.grade_str = "5.10a"
JOIN climb_grades AS cg_new ON cg_new.grade_str = "5.10b"
SET climbs.grade_id = cg_new.grade_id;

-- finds all the rows that have 5.10a 
-- and changes the grade id of those that matches the grade id of rows that have 5.10b