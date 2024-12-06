SELECT 
    h.id,
    h.homework_theme,
    h.description_homework,
    h.deadline
FROM 
    homeworks h
WHERE 
    NOT EXISTS (
        SELECT ch.id 
        FROM completed_homeworks ch 
        WHERE ch.homework_id = h.id 
          AND ch.student_id = 4
    );





