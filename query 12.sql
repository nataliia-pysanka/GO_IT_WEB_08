--12. Средний балл, который ставит преподаватель.
SELECT professor.title || ' ' ||professor.name || ' ' || professor.surname as professor_name,
       round(avg(rate.val), 2) as avg
    FROM rate
        INNER JOIN student_rating as st_r ON st_r.id_rate = rate.id_rate
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN professor_subject as pr_s ON pr_s.id_subject = subject.id_subject
        INNER JOIN professor ON professor.id_professor = pr_s.id_professor
        INNER JOIN rate r on r.id_rate = st_r.id_rate
    GROUP BY professor_name
    ORDER BY professor_name;