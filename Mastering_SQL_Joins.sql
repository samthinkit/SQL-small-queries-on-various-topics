
##########################################################
##########################################################
-- Guided Project: Mastering SQL Joins in PostgreSQL
##########################################################
##########################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the dept_manager_dup and
-- departments_dup tables in the database
#############################

-- 1.1: Retrieve all data from the dept_manager_dup table
SELECT * FROM dept_manager_dup

-- 1.2: Retrieve all data from the departments_dup table
SELECT * FROM departments_dup

#############################
-- Task Two: INNER JOIN
-- In this task, you will retrieve data from the two 
-- tables using INNER JOIN
#############################

##########
-- INNER JOIN

-- 2.1: Extract all managers' employees number, department number, 
-- and department name. Order by the manager's department number

-- Solution I
SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager M
INNER JOIN public.departments D 
ON M.dept_no = D.dept_no
ORDER BY dept_no
------------------------------------------------

--WITHOUT DEPT NAME
SELECT M.EMP_NO, M.dept_no FROM 
public.dept_manager M
WHERE dept_no IN (SELECT dept_no FROM public.departments )
----------------------------------------------

-- Solution II
SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager M
INNER JOIN public.departments D 
USING (dept_no)
ORDER BY dept_no

---------------------------------------------------

-- Solution III
SELECT M.EMP_NO, M.dept_no, D.dept_name
FROM dept_manager M , departments D
WHERE M.dept_no=D.dept_no
ORDER BY dept_no
--------------------------------------------------------------------


-- Solution IV
SELECT M.EMP_NO, M.dept_no, D.dept_name
FROM dept_manager M 
NATURAL JOIN departments D
ORDER BY dept_no





--- FOR DUB TABLES

SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager M
INNER JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no

-- add m.from_date and m.to_date

SELECT M.EMP_NO, M.dept_no, D.dept_name,m.from_datE ,  m.to_date   FROM 
public.dept_manager_dup M
INNER JOIN public.departments D 
ON M.dept_no=D.dept_no
ORDER BY dept_no





-- 2.2 (Ex.): Extract a list containing information about all managers'
-- employee number, first and last name, dept_number and hire_date
-- Hint: Use the employees and dept_manager tables

-- Retrieve data from the employees and dept_manager

SELECT * FROM employees;
SELECT * FROM dept_manager;

-- Solution to 2.2

SELECT E.EMP_NO, E.FIRST_NAME, E.LAST_NAME , D.DEPT_NO, E.HIRE_DATE
FROM employees E INNER JOIN dept_manager D 
ON E.EMP_NO=D.EMP_NO







#############################
-- Task Three: Duplicate Records
-- In this task, you will retrieve data from the two 
-- tables with duplicate records using INNER JOIN
#############################

###########
-- Duplicate Records

-- 3.1: Let us add some duplicate records
-- Insert records into the dept_manager_dup and departments_dup tables respectively

INSERT INTO dept_manager_dup 
VALUES 	('110228', 'd003', '1992-03-21', '9999-01-01');
        
INSERT INTO departments_dup 
VALUES	('d009', 'Customer Service');

-- 3.2: Select all records from the dept_manager_dup table

SELECT *
FROM dept_manager_dup
ORDER BY dept_no ASC;

-- 3.3: Select all records from the departments_dup table

SELECT *
FROM departments_dup
ORDER BY dept_no ASC;

-- 3.4: Perform INNER JOIN as before

SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
INNER JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no

-- 3.5: add a GROUP BY clause. Make sure to include all the fields in the GROUP BY clause

SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
INNER JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
GROUP BY 1,2,3
ORDER BY M.dept_no
-- SO IN ORDER TO GET UNİQUE VALES ADD GROUP BY CLAUSE SO THAT GET NON-DUBLICATE VALUES OR ROWS
-- SO AS DINTINCT FUNCTION DO THE SAME
SELECT DISTINCT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
INNER JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no



#############################
-- Task Four: LEFT JOIN
-- In this task, you will retrieve data from the two tables using LEFT JOIN
#############################

###########
-- LEFT JOIN

-- 4.1: Remove the duplicates from the two tables
DELETE FROM dept_manager_dup 
WHERE emp_no = '110228';
        
DELETE FROM departments_dup 
WHERE dept_no = 'd009';

-- 4.2: Add back the initial records
INSERT INTO dept_manager_dup 
VALUES 	('110228', 'd003', '1992-03-21', '9999-01-01');
        
INSERT INTO departments_dup 
VALUES	('d009', 'Customer Service');

-- 4.3: Select all records from dept_manager_dup
SELECT  *
FROM dept_manager_dup
ORDER BY dept_no;

-- 4.4: Select all records from departments_dup
SELECT *
FROM departments_dup
ORDER BY dept_no;

-- Recall, when we had INNER JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- 4.5: Join the dept_manager_dup and departments_dup tables
-- Extract a subset of all managers' employee number, department number, 
-- and department name. Order by the managers' department number
SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
LEFT JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no


-- FIRST 2 IS EMTY DEP NAME BCS NO SUCH NAME OF THE DATA IN THE LEFT WING OF THE SET


-- 4.6: What will happen when we d LEFT JOIN m? INTERCHANGE TABLES ??
-- THE ANSWERS IS GIVING THE WHOLE DEPARTMENT TABLE 
--ORDER OF THE TABLES MATTERS




SELECT M.EMP_NO, M.dept_no, D.dept_name  FROM 
public.departments_dup D 
LEFT JOIN public.dept_manager_dup M
ON M.dept_no=D.dept_no
ORDER BY M.dept_no

-- D.DEPT_NO AND M.DEPT_NO ALSO MATTERS SINCE DEPARTMENT OR DEP.MANAGER TABLE MAY LACK SOME VALUES ENDING UP WITH NULL VALUES

SELECT M.EMP_NO, D.dept_no, D.dept_name  FROM 
public.departments_dup D 
LEFT JOIN public.dept_manager_dup M
ON M.dept_no=D.dept_no
ORDER BY M.dept_no


-- 4.7: Let's select d.dept_no
SELECT M.EMP_NO, D.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
LEFT JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no



-- LEFT OUTER JOIN
SELECT M.EMP_NO, D.dept_no, D.dept_name  FROM 
public.dept_manager_dup M
LEFT OUTER JOIN public.departments_dup D 
ON M.dept_no=D.dept_no
ORDER BY M.dept_no

#############################
-- Task Five: RIGHT JOIN
-- In this task, you will retrieve data from the two tables using RIGHT JOIN
#############################

###########
-- RIGHT JOIN

-- We have seen LEFT JOIN in the previous task

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY dept_no;

-- 5.1: Let's use RIGHT JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
RIGHT JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY dept_no;


-- 5.2: SELECT d.dept_no
SELECT d.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
RIGHT JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY dept_no;



-- 5.3: d LEFT JOIN m
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup d  
LEFT JOIN dept_manager_dup m
ON m.dept_no = d.dept_no
ORDER BY dept_no;

--WHEN you CHANGE TABLE NAMES FOR LEFT AND RIGHT JOINS SO interchangeably they will give you same result

#############################
-- Task Six: JOIN and WHERE Used Together
-- In this task, you will retrieve data from tables
-- using JOIN and WHERE together
#############################



###########
-- JOIN and WHERE Used Together

-- 6.1: Extract the employee number, first name, last name and salary
-- of all employees who earn above 145000 dollars per year

-- Let us retrieve all data in the salaries table
SELECT * FROM salaries;

-- Solution to 6.1

SELECT E.EMP_NO, E.FIRST_NAME, E.LAST_NAME, S.SALARY
FROM salaries S 
INNER JOIN employees E
ON S.EMP_NO=E.EMP_NO
WHERE SALARY > 145000



-- 6.2: What do you think will be the output of this query?

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.salary > 145000;


--same thing with the above solution

-- 6.3 (Ex.): Select the first and last name, the hire date and the salary
-- of all employees whose first name is 'Mario' and last_name is 'Straney'
SELECT E.EMP_NO, E.FIRST_NAME, E.LAST_NAME, HIRE_DATE , S.SALARY
FROM salaries S 
INNER JOIN employees E
ON S.EMP_NO=E.EMP_NO
WHERE FIRST_NAME = 'Mario' and LAST_NAME = 'Straney'



-- 6.4: Join the 'employees' and the 'dept_manager' tables to return a subset
-- of all the employees whose last name is 'Markovitch'. 
-- See if the output contains a manager with that name

SELECT E.EMP_NO,E.FIRST_NAME, E.LAST_NAME
FROM public.employees E
LEFT JOIN dept_manager D
ON D.EMP_NO=E.EMP_NO
WHERE LAST_NAME =  'Markovitch'


-- 6.5: Join the 'employees' and the 'dept_manager' tables to return a subset
-- of all the employees who were hired before 31st of January, 1985

SELECT E.EMP_NO,E.FIRST_NAME, E.LAST_NAME
FROM public.employees E
LEFT JOIN dept_manager D
ON D.EMP_NO=E.EMP_NO
WHERE HIRE_DATE < '1985-01-31'



#############################
-- Task Seven: Using Aggregate Functions with Joins
-- In this task, you will retrieve data from tables in the employees database,
-- using Aggregate Functions with Joins
#############################

###########
-- Using Aggregate Functions with Joins

-- 7.1: What is the average salary for the different gender?
   SELECT ROUND(AVG(SALARY),2) AS  "AVERAGE SALARY", GENDER
   FROM SALARIES S 
   INNER JOIN EMPLOYEES E 
   ON S.EMP_NO=E.EMP_NO
   GROUP BY 2
   
   
   
   
   --SECOND SOLUTION TRY
 SELECT   FIRST_NAME, LAST_NAME, GENDER, AVG(SALARY) OVER(PARTITION BY GENDER ORDER BY 1 DESC)
 FROM SALARIES S 
 INNER JOIN EMPLOYEES E 
 ON S.EMP_NO=E.EMP_NO

   
   
-- 7.2: What do you think will be the output if we SELECT e.emp_no?
SELECT e.emp_no, e.gender, AVG(s.salary) AS average_salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
GROUP BY e.emp_no, gender; 

--soluiton --
--Resul is set and group by emp_no and gender 

-- 7.3: How many males and how many females managers do we have in
-- employees database?
SELECT GENDER, COUNT(GENDER) FROM EMPLOYEES E
JOIN public.dept_manager D 
ON e.emp_no = D.emp_no
GROUP BY GENDER



--SECOND SOL
SELECT GENDER, COUNT(GENDER) FROM EMPLOYEES E
JOIN public.dept_manager D 
ON e.emp_no = D.emp_no
GROUP BY GENDER


#############################
-- Task Eight: Join more than Two Tables in SQL
-- In this task, you will retrieve data from tables in the employees database,
-- by joining more than two Tables in SQL
#############################

###########
-- Join more than Two Tables in SQL

-- 8.1: Extract a list of all managers' first and last name, dept_no, hire date, to_date,
-- and department name


SELECT first_name, last_name, D.dept_no, hire_date,to_date, dept_name
FROM public.employees E INNER JOIN public.dept_manager D
ON E.emp_no=D.emp_no
LEFT JOIN public.departments DEP
ON DEP.dept_no = D.dept_no


-- 8.2: What do you think will be the output of this?
SELECT e.first_name, e.last_name, m.dept_no, e.hire_date, m.to_date, d.dept_name
FROM departments d
JOIN dept_manager m 
ON d.dept_no = m.dept_no
JOIN employees e 
ON m.emp_no = e.emp_no;


-- 8.3: Retrieve the average salary for the different departments



-- Retrieve all data from departments table
SELECT * FROM departments

-- Retrieve all data from dept_emp table
SELECT * FROM dept_emp

-- Retrieve all data from salaries table
SELECT * FROM salaries

-- Solution to 8.3

SELECT CEIL(AVG(SALARY)), dept_name FROM salaries S
JOIN dept_emp D ON S.emp_no=D.emp_no
LEFT JOIN departments DEP 
ON DEP.dept_no=D.dept_no
GROUP BY 2
ORDER BY 1 DESC



SELECT DISTINCT AVG(SALARY) OVER (PARTITION BY dept_name), dept_name  FROM salaries S
JOIN dept_emp D ON S.emp_no=D.emp_no
LEFT JOIN departments DEP 
ON DEP.dept_no=D.dept_no


-- 8.4 (Ex.): Retrieve the average salary for the different departments where the
-- average_salary is more than 60000
WITH CTE AS (
SELECT DISTINCT AVG(SALARY) OVER (PARTITION BY dept_name) AVEGARAGE, dept_name  FROM salaries S
JOIN dept_emp D ON S.emp_no=D.emp_no
LEFT JOIN departments DEP 
ON DEP.dept_no=D.dept_no
)

SELECT CEIL(AVEGARAGE), dept_name
FROM CTE
WHERE AVEGARAGE > 60000


