--2. 1 студент с наивысшим средним баллом по одному предмету.
SELECT s.name as subject, st.name || ' ' || st.surname as student_name, max(rating.avg)
    FROM (SELECT s_r.id_student, s_r.id_subject, round(avg(rate.val), 2) as avg
            FROM student_rating as s_r
            INNER JOIN rate on rate.id_rate = s_r.id_rate
            GROUP BY s_r.id_student, s_r.id_subject) as rating
        INNER JOIN student as st ON st.id_student = rating.id_student
        INNER JOIN subject as s ON s.id_subject = rating.id_student
        GROUP BY s.name, student_name;
