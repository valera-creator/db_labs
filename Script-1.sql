-- USE ValeriiLarionovEmployees;
-- SHOW TABLES;
DESCRIBE employees;

-- 1 задание: 
-- Добавление в таблицу employees сотрудника с именем John Dowe, родившегося 18 июня 1993 года и принятого на работу 1 сентября 2025 года.

INSERT INTO employees 
(emp_no, first_name, last_name, birth_date, gender, hire_date)
VALUES 
((SELECT MAX(emp_no) + 1 FROM employees), 'John', 'Dowe', '1993-06-18', 'M', '2025-09-01');

-- 2 задание: 
-- Добавление сотрудника с именем Jane Austen, родившуюся 5 марта 2003 года и принятую на работу сегодня (т.е. в тот день, когда будет выполнен запрос).

INSERT INTO employees 
(emp_no, first_name, last_name, birth_date, gender, hire_date)
VALUES
((SELECT MAX(emp_no) + 1 FROM employees), 'Jane', 'Austen', '2003-03-05', 'F', CURDATE());

-- 3 задание:
-- Получение фамилии и имени (только этих полей и именно в таком порядке) сотрудника с номером 10169.
SELECT last_name, first_name FROM employees
WHERE emp_no = 10169;

-- 4 задание:
-- Получение номера, фамилии и возраста самого молодого и самого возрастного сотрудников (взять минимального и максимального по фамилии в случае если их много)
(SELECT emp_no, last_name, TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM employees
WHERE birth_date = (SELECT MIN(birth_date) FROM employees)
ORDER BY last_name 
LIMIT 1)
UNION
(SELECT emp_no, last_name, TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM employees
WHERE birth_date = (SELECT MAX(birth_date) FROM employees)
ORDER BY last_name
LIMIT 1);

-- 5 задание:
-- Поиск сотрудников, возраст которых на момент принятия на работу был наименьшим и наибольшим. Для каждого из них необходимо получить номер, фамилию и возраст на момент принятия на работу.
-- способ 1
(SELECT emp_no, last_name, TIMESTAMPDIFF(YEAR, birth_date, hire_date) AS age_work FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) = (SELECT MIN(TIMESTAMPDIFF(YEAR, birth_date, hire_date)) FROM employees)
ORDER BY last_name 
LIMIT 1)
UNION
(SELECT emp_no, last_name, TIMESTAMPDIFF(YEAR, birth_date, hire_date) AS age_work FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) = (SELECT MAX(TIMESTAMPDIFF(YEAR, birth_date, hire_date)) FROM employees)
ORDER BY last_name
LIMIT 1)

-- способ 2
-- with - временная таблица во время выполнения запроса
WITH emp_with AS
(SELECT emp_no, last_name, TIMESTAMPDIFF(YEAR, birth_date, hire_date) AS age_work FROM employees)
(SELECT emp_no, last_name, age_work FROM emp_with
WHERE age_work = (SELECT MIN(age_work) FROM emp_with)
ORDER BY last_name
LIMIT 1)
UNION
(SELECT emp_no, last_name, age_work FROM emp_with
WHERE age_work = (SELECT MAX(age_work) FROM emp_with)
ORDER  BY last_name
LIMIT 1
);

-- задание 6:
-- Поиск первых 5 сотрудников, фамилии которых начинаются на G. Сотрудники должны быть упорядочены по фамилии в алфавитном порядке. Для каждого из сотрудников необходимо вывести фамилию и имя.
SELECT last_name, first_name FROM employees
WHERE last_name LIKE 'G%'
ORDER BY last_name
LIMIT 5;

-- задание 7:
-- Поиск первых 5 имён сотрудников, начинающихся на B. Обратите внимание, что у нескольких сотрудников может быть одинаковое имя.
SELECT DISTINCT first_name FROM employees
WHERE first_name LIKE 'B%'
ORDER BY first_name
LIMIT 5


-- задание 8:
-- Подсчитать число женщин, которые когда-либо являлись руководителям отделов.
SELECT COUNT (DISTINCT employees.emp_no) AS count_woman FROM employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
WHERE employees.gender = 'F'

-- задание 9:
-- Подсчитать число сотрудников, которые поступили на работу между 20 и 30 годами.
SELECT COUNT(*) AS count_employes_between_20_30 FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) BETWEEN 20 AND 30;

-- задание 10:
-- Подсчитать число сотрудников, которые поступили на работу не между 20 и 30 годами. Сколькими способами можно решить эту задачу? Какой из них эффективнее?

-- способ 1
SELECT COUNT(*) AS count_employes_not_between_20_30 FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) NOT BETWEEN 20 AND 30;

-- способ 2
SELECT COUNT(*) AS count_employes_not_between_20_30 FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) < 20 OR TIMESTAMPDIFF(YEAR, birth_date, hire_date) > 30;

-- способ 3
SELECT
(SELECT COUNT(*) FROM employees) 
-
(SELECT COUNT(*) AS count_employes_between_20_30 FROM employees
WHERE TIMESTAMPDIFF(YEAR, birth_date, hire_date) BETWEEN 20 AND 30)
AS count_employes_not_between_20_30


