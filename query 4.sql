--4. Средний балл в потоке.
SELECT round(avg(rate.val), 2) as avg, group_.name FROM rate
    INNER JOIN student_rating ON rate.id_rate = student_rating.id_rate
    INNER JOIN student ON student.id_student = student_rating.id_student
    INNER JOIN subject ON subject.id_subject = student_rating.id_subject
    INNER JOIN group_ ON student.id_group = group_.id_group
    GROUP BY group_.name
    ORDER BY group_.name DESC;
