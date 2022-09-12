--1. 5 студентов с наибольшим средним баллом по всем предметам.
SELECT round(avg(rate.val), 2) as value, student.name || ' ' || student.surname as student_name FROM rate
    INNER JOIN student_rating ON rate.id_rate = student_rating.id_rate
    INNER JOIN student ON student.id_student = student_rating.id_student
    INNER JOIN subject ON subject.id_subject = student_rating.id_subject
    GROUP BY student_name
    ORDER BY value DESC
    LIMIT 5;

--2. 1 студент с наивысшим средним баллом по одному предмету.
SELECT s.name as subject, st.name || ' ' || st.surname as student_name, max(rating.avg)
    FROM (SELECT s_r.id_student, s_r.id_subject, round(avg(rate.val), 2) as avg
            FROM student_rating as s_r
            INNER JOIN rate on rate.id_rate = s_r.id_rate
            GROUP BY s_r.id_student, s_r.id_subject) as rating
        INNER JOIN student as st ON st.id_student = rating.id_student
        INNER JOIN subject as s ON s.id_subject = rating.id_student
        GROUP BY s.name, student_name;

--3. средний балл в группе по одному предмету.
SELECT round(avg(rate.val), 2) as avg, subject.name as subject, group_.name FROM rate
    INNER JOIN student_rating ON rate.id_rate = student_rating.id_rate
    INNER JOIN student ON student.id_student = student_rating.id_student
    INNER JOIN subject ON subject.id_subject = student_rating.id_subject
    INNER JOIN group_ ON student.id_group = group_.id_group
    GROUP BY subject, group_.name
    ORDER BY group_.name DESC;

--4. Средний балл в потоке.
SELECT round(avg(rate.val), 2) as avg, group_.name FROM rate
    INNER JOIN student_rating ON rate.id_rate = student_rating.id_rate
    INNER JOIN student ON student.id_student = student_rating.id_student
    INNER JOIN subject ON subject.id_subject = student_rating.id_subject
    INNER JOIN group_ ON student.id_group = group_.id_group
    GROUP BY group_.name
    ORDER BY group_.name DESC;

--5. Какие курсы читает преподаватель.
SELECT pr.title || ' '||pr.name||' '||pr.surname as professor, subject.name as subject FROM professor as pr
    INNER JOIN professor_subject as pr_s
        ON pr.id_professor = pr_s.id_professor
    INNER JOIN subject ON pr_s.id_subject = subject.id_subject;

--6. Список студентов в группе.
SELECT group_.name, student.name || ' ' || student.surname as student_name
    FROM student INNER JOIN group_ ON student.id_group = group_.id_group
    ORDER BY group_.name;

--7. Оценки студентов в группе по предмету.
SELECT group_.name, student.name || ' ' || student.surname as student_name, subject.name as subject, rate.val as value, st_r.date_rate
    FROM student
        INNER JOIN group_ ON student.id_group = group_.id_group
        INNER JOIN student_rating as st_r ON student.id_student = st_r.id_student
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN rate ON rate.id_rate = st_r.id_rate
    ORDER BY student_name;

--8. Оценки студентов в группе по предмету на последнем занятии.
SELECT group_.name as group_name, subject.name as subject, student.name || ' ' || student.surname as student_name, max(date_rate) as last_day
    FROM student_rating as st_r
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN student ON student.id_student = st_r.id_student
        INNER JOIN group_ ON student.id_group = group_.id_group
    GROUP BY group_name, subject, student_name
    ORDER BY group_name;

--9. Список курсов, которые посещает студент.
SELECT student.name || ' ' || student.surname as student_name, subject.name as subject
    FROM student_rating as st_r
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN student ON student.id_student = st_r.id_student
    GROUP BY student_name, subject
    ORDER BY student_name;

--10. Список курсов, которые студенту читает преподаватель.
SELECT professor.title || ' ' ||professor.name || ' ' || professor.surname as professor_name,
       student.name || ' ' || student.surname as student_name,
       subject.name as subject
    FROM student_rating as st_r
        INNER JOIN student ON student.id_student = st_r.id_student
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN professor_subject as pr_s ON pr_s.id_subject = subject.id_subject
        INNER JOIN professor ON professor.id_professor = pr_s.id_professor
    GROUP BY professor_name, student_name, subject
    ORDER BY professor_name;

--11. Средний балл, который преподаватель ставит студенту.
SELECT professor.title || ' ' ||professor.name || ' ' || professor.surname as professor_name,
       student.name || ' ' || student.surname as student_name,
       subject.name as subject,
       round(avg(rate.val), 2) as avg
    FROM rate
        INNER JOIN student_rating as st_r ON st_r.id_rate = rate.id_rate
        INNER JOIN student ON student.id_student = st_r.id_student
        INNER JOIN subject ON st_r.id_subject = subject.id_subject
        INNER JOIN professor_subject as pr_s ON pr_s.id_subject = subject.id_subject
        INNER JOIN professor ON professor.id_professor = pr_s.id_professor
        INNER JOIN rate r on r.id_rate = st_r.id_rate
    GROUP BY professor_name, student_name, subject
    ORDER BY professor_name;

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