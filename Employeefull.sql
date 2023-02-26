-- Data Modeling--
-- Inspect CSV files
-- Entity relationship diagram of the tables sketched using QuickDBD and stored as PNG

-- Drop Tables if existing
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS dept_emp CASCADE;
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS titles CASCADE;

-- Data Engineering
-- Create tables and import CSV files into correct SQL table
CREATE TABLE departments (
	dept_no VARCHAR(4) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(30) NOT NULL
);

CREATE TABLE titles (
	title_id VARCHAR(5) PRIMARY KEY NOT NULL,
	title VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR(5) NOT NULL,
	birth_date VARCHAR(10) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE "salaries" (
	"emp_no" INT NOT NULL,
	"salary" INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Query each table to verify data
SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;

-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
JOIN salaries as s ON
e.emp_no = s.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT e.first_name, e.last_name, e.hire_date
FROM employees as e
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date;

--List the manager of each department along with their department number, department name, employee number,
-- last name, and first name.
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments as d
JOIN dept_manager as dm ON
d.dept_no = dm.dept_no
JOIN employees as e ON
e.emp_no = dm.emp_no;

--List the department number for each employee along with that employee's employee number, last name,
--first name, and department name.
SELECT de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp as de
JOIN employees as e ON
de.emp_no = e.emp_no
JOIN departments as d ON
de.dept_no = d.dept_no
ORDER BY dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose
-- last name begins with the letter B
SELECT e.first_name, e.last_name, e.sex
FROM employees as e
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List each employee in the sales department, including their number, last name and first name
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_emp as de
JOIN employees as e ON
de.emp_no = e.emp_no
JOIN departments as d ON
de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- List each employee in Sales and development departments, including their employee number, last name
-- first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp as de
JOIN employees as e ON
de.emp_no = e.emp_no
JOIN departments as d ON
d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales'
OR d.dept_name ='Development';

--List the frequency counts, in descending order, 
-- of all the employee last names(that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "frequency counts"
FROM employees
GROUP BY last_name
ORDER BY "frequency counts" DESC;

