--8. Оценки студентов в группе по предмету на последнем занятии.
SELECT group_.name as group_name, subject.name as subject, student.name || ' ' || student.surname as student_name, max(date_rate) as last_day
    FROM student_rating as st_r
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN student ON student.id_student = st_r.id_student
        INNER JOIN group_ ON student.id_group = group_.id_group
    GROUP BY group_name, subject, student_name
    ORDER BY group_name;