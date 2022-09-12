--7. Оценки студентов в группе по предмету.
SELECT group_.name, student.name || ' ' || student.surname as student_name, subject.name as subject, rate.val as value, st_r.date_rate
    FROM student
        INNER JOIN group_ ON student.id_group = group_.id_group
        INNER JOIN student_rating as st_r ON student.id_student = st_r.id_student
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN rate ON rate.id_rate = st_r.id_rate
    ORDER BY student_name;
