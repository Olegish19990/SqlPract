SELECT 
    hw.id,
    hw.homework_theme,
    hw.description_homework,
    hw.deadline,
    g.title
FROM 
    homeworks hw
JOIN 
    completed_homeworks ch ON hw.id = ch.homework_id
JOIN 
    students st ON ch.student_id = st.id
JOIN 
    groups g ON st.group_id = g.id
LEFT JOIN 
    homeworks_grades hg ON ch.id = hg.completed_homework_id
WHERE
    hw.teacher_id = 1 
    AND g.id = 1  
    AND hg.completed_homework_id IS NULL;
