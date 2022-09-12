--9. Список курсов, которые посещает студент.
SELECT student.name || ' ' || student.surname as student_name, subject.name as subject
    FROM student_rating as st_r
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN student ON student.id_student = st_r.id_student
    GROUP BY student_name, subject
    ORDER BY student_name;