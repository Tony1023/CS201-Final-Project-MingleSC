CREATE TEMPORARY TABLE suggestion AS (SELECT *, 0.0 as score FROM user WHERE NOT user_id=@this_id);
CREATE TEMPORARY TABLE temp AS (SELECT * FROM user WHERE NOT user_id=@this_id);
CREATE TEMPORARY TABLE this_user AS (SELECT * from user WHERE user_id=@this_id);

UPDATE suggestion SET score=score+1.0 WHERE major_id=(SELECT major_id FROM this_user);
UPDATE suggestion SET score=score+0.5 WHERE housing_id=(SELECT housing_id FROM this_user);

UPDATE suggestion s JOIN (
	SELECT t.user_id, COUNT(*) AS share_num FROM 
    temp t JOIN user_interests u ON t.user_id=u.user_id
    WHERE u.interest_id in (SELECT interest_id from user_interests WHERE user_id=@this_id)
    GROUP BY t.user_id
) i ON s.user_id=i.user_id SET s.score=s.score+i.share_num*0.5;

UPDATE suggestion s JOIN (
	SELECT t.user_id, COUNT(*) AS share_num FROM 
    temp t JOIN user_extracurriculars u ON t.user_id=u.user_id
    WHERE u.extracurricular_id in (SELECT extracurricular_id from user_extracurriculars WHERE user_id=@this_id)
    GROUP BY t.user_id
) i ON s.user_id=i.user_id SET s.score=s.score+i.share_num*0.5;

UPDATE suggestion s JOIN (
	SELECT t.user_id, COUNT(*) AS share_num FROM 
    temp t JOIN user_courses u ON t.user_id=u.user_id
    WHERE u.course_id in (SELECT course_id from user_courses WHERE user_id=@this_id)
    GROUP BY t.user_id
) i ON s.user_id=i.user_id SET s.score=s.score+i.share_num*0.5;

SELECT user_id FROM suggestion WHERE user_id NOT IN 
(
	SELECT blocking_user_id FROM blocks
    WHERE blocked_user_id=@this_id AND block_status=1
)
ORDER BY score DESC LIMIT 5;