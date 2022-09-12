--5. Какие курсы читает преподаватель.
SELECT pr.title || ' '||pr.name||' '||pr.surname as professor, subject.name as subject FROM professor as pr
    INNER JOIN professor_subject as pr_s
        ON pr.id_professor = pr_s.id_professor
    INNER JOIN subject ON pr_s.id_subject = subject.id_subject;
