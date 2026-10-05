-- задание 1:
-- Получение названий должностей, которые в настоящий момент занимают последние 10 принятых на работу сотрудников, и даты, с которых они занимают эти должности.

SELECT titles.title, titles.from_date 
FROM employees JOIN titles
ON employees.emp_no = titles.emp_no
WHERE titles.to_date = '9999-01-01'
ORDER BY employees.hire_date DESC
LIMIT 10;

-- задание 2:
-- Получение названий должностей, которые в настоящий момент занимают сотрудники, у которых завтра будет день рождения.
SELECT DISTINCT titles.title
FROM employees JOIN titles
ON employees.emp_no = titles.emp_no
WHERE titles.to_date = '9999-01-01'
	AND MONTH(CURDATE() + INTERVAL 1 DAY) = MONTH(employees.birth_date)
	AND DAY(CURDATE() + INTERVAL 1 DAY) = DAY(employees.birth_date);
	
-- задание 3:	
-- Получение списка всех должностей, которые когда-либо занимали первые 30 принятых на работу сотрудников.
WITH first_30 AS (
	SELECT employees.emp_no
	FROM employees
	ORDER BY employees.hire_date
	LIMIT 30
	)
SELECT DISTINCT titles.title from
first_30 JOIN titles
ON first_30.emp_no = titles.emp_no;

-- задание 4:
-- Получение списка сотрудников (в алфавитном порядке), которые в настоящий момент не занимают ни одну должность.
SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN titles t
ON e.emp_no = t.emp_no AND t.to_date = '9999-01-01' -- если дата 9999-01-01, то потом в WHERE отсеится, если дата не 9999-01-01, то станет NULL
WHERE t.emp_no IS NULL
ORDER BY e.last_name, e.first_name;


-- задание 5:	
-- Получение списка сотрудников, которые когда-либо руководили отделами, с указанием названия отдела, которыми они руководили. 
-- Сотрудников нужно упорядочить по дате начала руководством отдела.
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, dm.from_date AS manager_from_date
FROM employees e 
JOIN dept_manager dm 
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
ORDER BY dm.from_date;

-- задание 6:
-- Получение списка сотрудников, которые в настоящий момент руководят каким-либо отделом, с указанием названия отдела. Сотрудников нужно упорядочить по дате принятия на работу
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, dm.from_date AS manager_from_date
FROM employees e 
JOIN dept_manager dm 
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
WHERE dm.to_date = '9999-01-01'
ORDER BY e.hire_date;


-- задание 7:
-- Получение сотрудника, который дольше всего руководит отделом (среди руководящих отделами в настоящий момент)
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, dm.from_date AS manager_from_date
FROM employees e 
JOIN dept_manager dm 
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
WHERE dm.to_date = '9999-01-01'
ORDER BY dm.from_date  DESC
LIMIT 1;

-- задание 8:
-- Получение названия отдела, в котором в настоящий момент работает сотрудник с наивысшей зарплатой.
SELECT d.dept_name
FROM employees e 
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
JOIN salaries s 
	ON e.emp_no = s.emp_no
WHERE de.to_date = '9999-01-01' AND s.to_date  = '9999-01-01'
ORDER BY salary DESC
LIMIT 1;




