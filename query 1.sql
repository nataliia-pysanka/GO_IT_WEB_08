--1. 5 студентов с наибольшим средним баллом по всем предметам.
SELECT round(avg(rate.val), 2) as value, student.name || ' ' || student.surname as student_name FROM rate
    INNER JOIN student_rating ON rate.id_rate = student_rating.id_rate
    INNER JOIN student ON student.id_student = student_rating.id_student
    INNER JOIN subject ON subject.id_subject = student_rating.id_subject
    GROUP BY student_name
    ORDER BY value DESC
    LIMIT 5;
