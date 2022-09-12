--6. Список студентов в группе.
SELECT group_.name, student.name || ' ' || student.surname as student_name
    FROM student INNER JOIN group_ ON student.id_group = group_.id_group
    ORDER BY group_.name;
