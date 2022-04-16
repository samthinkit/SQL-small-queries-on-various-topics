###############################################################
###############################################################
-- Guided Project: Introduction to SQL Window Functions
###############################################################
###############################################################

#############################
-- Task One: Getting Started
-- In this task, we will get started with the project
-- by retrieving all the data in the project-db database
#############################
--note:  sales and customers tables are imported via csv file using postgresql graphical userinterface
-- 1.1: Retrieve all the data in the project-db database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: ROW_NUMBER() - Part One
-- In this task, we will learn the ROW_NUMBER() 
-- and OVER() to assign numbers to each row
#############################

-- 2.1: Assign numbers to each row of the departments table
SELECT  *, ROW_NUMBER() OVER () as row
FROM public.departments

-- Exercise 2.1: Assign numbers to each row of 
-- the department for the Entertainment division
SELECT *,
ROW_NUMBER() OVER() AS Row_N
FROM public.departments
WHERE DIVISION = 'Entertainment'
ORDER BY Row_N ASC;

#############################
-- Task Three: ROW_NUMBER() - Part Two
-- In this task, we will continue to learn how to 
-- assign numbers to each row using ROW_NUMBER() and OVER()
#############################

-- 3.1: Retrieve all the data from the employees table
SELECT * FROM employees;

-- Order by inside OVER()
-- 3.2: Retrieve a list of employee_id, first_name, 
-- hire_date, and department of all employees in the sports
-- department ordered by the hire date

SELECT employee_id, first_name,hire_date, department
FROM public.employees
WHERE department = 'Sports'
ORDER BY hire_date

SELECT employee_id, first_name,hire_date, department,
ROW_NUMBER() OVER (ORDER BY hire_date)
FROM public.employees
WHERE department = 'Sports'

-- 3.3: Order by multiple columns
SELECT employee_id, first_name,hire_date, salary, department,
ROW_NUMBER() OVER (ORDER BY hire_date, salary DESC )
FROM public.employees

-- 3.4: Ordering in- and outside the OVER() clause
SELECT employee_id, first_name, hire_date, salary, department,
ROW_NUMBER() OVER(ORDER BY hire_date ASC, salary DESC) AS Row_N
FROM employees
WHERE department = 'Sports'
ORDER BY employee_id;
--outside order by clause is previledged by the sql logic
-- row_number is putting sequential number

#############################
-- Task Four: PARTITION BY
-- In this task, we will learn how to use
-- the PARTITION BY clause inside OVER()
#############################

-- 4.1: Retrieve the employee_id, first_name, 
-- hire_date of employees for different departments

SELECT employee_id, first_name, hire_date,department,
COUNT(*) OVER (PARTITION BY department)
FROM employees

SELECT employee_id, first_name, hire_date,department,
ROW_NUMBER(*) OVER (PARTITION BY department ORDER BY 4)
FROM employees



-- Exercise 4.1: Order by the hire_date
SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER  (PARTITION BY department
				   ORDER BY hire_date) AS Row_N
FROM employees
ORDER BY department ASC;

#############################
-- Task Five: PARTITION BY with CTE
-- In this task, we will learn how to write a conditional
-- statement using a single CASE clause
#############################

-- 5.1: Retrieve all data from the sales and customers tables
SELECT * FROM sales;
SELECT * FROM customers;

-- 5.2: Create a common table expression to retrieve the
-- customer_id, customer_name, segment and how many 
-- times the customer has purchased from the mall 
WITH customer_purchase AS (
	SELECT s.customer_id, c.customer_name, c.segment,
	COUNT(*) AS purchase_count
	FROM sales s
	JOIN customers c
	ON s.customer_id = c.customer_id
	GROUP BY s.customer_id, c.customer_name, c.segment
	ORDER BY customer_id)

-- 5.3: Number each customer by how many purchases they've made
-- THİS QUESTION IS NOT CLEAR. WHAT IS THE THING HE WANTS IS NOT CLEAR SINCE ROW_NUMBER OR RANK OR DENSE_RANK CAN BE USED.
-- THE POINT IS HOW HE WANTS TO NUMBER OR SEGMENT
SELECT *,
ROW_NUMBER() OVER (ORDER  BY purchase_count DESC ) AS "how many purchases they have made",
DENSE_RANK() OVER (ORDER  BY purchase_count DESC ) AS "how many purchases they have made DENSE",
RANK() OVER (ORDER  BY purchase_count DESC ) AS "how many purchases they have made CUMULATIVE"
FROM customer_purchase




-- Exercise 5.1: Number each customer by their customer segment
-- and by how many purchases they've made in descending order

WITH customer_purchase AS (
	SELECT s.customer_id, c.customer_name, c.segment,
	COUNT(*) AS purchase_count
	FROM sales s
	JOIN customers c
	ON s.customer_id = c.customer_id
	GROUP BY s.customer_id, c.customer_name, c.segment
	ORDER BY customer_id)

SELECT customer_id, customer_name, segment, purchase_count,
ROW_NUMBER() OVER (PARTITION BY segment ORDER BY  purchase_count DESC) AS Row_N
FROM customer_purchase
ORDER BY segment, purchase_count DESC;

#############################
-- Task Six: Fetching: LEAD() & LAG()
-- In this task, we will learn how to fetch data
-- using the LEAD() and LAG() clauses
#############################

-- 6.1: Retrieve all employees first name, department, salary
-- and the salary after that employee
SELECT first_name, department, salary,
LEAD(salary, 1) OVER ()
FROM public.employees

-- 6.2: Retrieve all employees first name, department, salary
-- and the salary before that employee
SELECT first_name, department, salary,
LAG(salary, 1) OVER ()
FROM public.employees

-- 6.3: Retrieve all employees first name, department, salary
-- and the salary after that employee in order of their salaries
SELECT first_name, department, salary,
LEAD(salary, 1) OVER (ORDER BY salary)
FROM public.employees



SELECT first_name, department, salary,
LEAD(salary, 1) OVER (ORDER BY salary DESC), (salary- LEAD(salary, 1) OVER (ORDER BY salary DESC )) AS DIFF
FROM public.employees
ORDER BY 1


-- Exercise 6.1: Retrieve all employees first name, department, salary
-- and the salary before that employee in order of their salaries in
-- descending order. Call the new column closest_higher_salary
SELECT first_name, department, salary,
LAG(SALARY) OVER (ORDER BY SALARY DESC) closest_higher_salary
FROM employees;

-- Exercise 6.2: Retrieve all employees first name, department, salary
-- and the salary after that employee for each department in descending order
-- of their salaries. Call the new column closest_lowest_salary 
SELECT first_name, department, salary,
LEAD(SALARY) OVER (PARTITION BY department
				    ORDER BY salary DESC ) closest_lowest_salary
FROM employees;

-- What do you think this query will return?
SELECT first_name, department, salary,
LEAD(salary, 1) OVER (ORDER BY salary DESC) closest_salary,
LEAD(salary, 2) OVER (ORDER BY salary DESC) next_closest_salary
FROM employees
WHERE department = 'Clothing';


--This will give first_name, department, salary, and SALARY OF NEXT EMPLOYEE , SALARY OF THE NEXT OF NEXT EMPOLYEE DESCENDING ORDER WHERE DEPARTMENT IS CLOTHING 
#############################
-- Task Seven: FIRST_VALUE() - Part One
-- In this task, we will learn how to use the
-- FIRST_VALUE() clause with the OVER() clause
#############################

-- 7.1: Retrieve the first_name, last_name, department, and 
-- hire_date of all employees. Add a new column called first_emp_date 
-- that returns the hire date of the first hired employee

SELECT  first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER() first_emp_date
FROM employees



-- 7.2: Find the difference between the hire date of the first employee
-- hired and every other employees
SELECT  first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER(),
AGE(hire_date, FIRST_VALUE(hire_date) OVER()) DIFF,
FIRST_VALUE(hire_date) OVER() - hire_date
FROM employees
ORDER BY 4

-- Exercise 7.1: Partition by department
SELECT first_name, last_name, department, hire_date,

FIRST_VALUE(hire_date) OVER (PARTITION BY DEPARTMENT
					 ORDER BY hire_date) AS first_emp_date
FROM employees;

-- Exercise 7.2: Find the difference between the hire date of the 
-- first employee hired and every other employees partitioned by department
SELECT *, AGE(hire_date,first_emp_date) AS DIFF
FROM (
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (PARTITION BY DEPARTMENT
							 ORDER BY hire_date) AS first_emp_date
FROM employees) a
ORDER BY department;

#############################
-- Task Eight: FIRST_VALUE() - Part Two
-- In this task, we will continue to learn how to 
-- use the FIRST_VALUE() clause with the OVER() clause
#############################

-- Exercise 8.1: Return the first salary for different departments
-- Order by the salary in descending order
SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER (PARTITION BY DEPARTMENT
						 ORDER BY SALARY DESC) first_salary
FROM employees;

-- OR
SELECT first_name, email, department, salary,
MAX(salary) OVER (PARTITION BY department
				 ORDER BY salary DESC) first_salary
FROM employees;

-- Exercise 8.2: Return the first salary for different departments
-- Order by the first_name in ascending order
SELECT first_name, email, department, salary,
FIRST_VALUE(SALARY) OVER(PARTITION BY department
						 ORDER BY FIRST_NAME ASC)
FROM employees;

-- 8.1: Return the fifth salary for different departments
-- Order by the first_name in ascending order

WITH CTE AS (SELECT first_name, department, salary,
ROW_NUMBER() OVER  (PARTITION BY department
					ORDER BY salary	DESC ) AS "NUMBER"

FROM employees
)

SELECT * FROM CTE 
WHERE "NUMBER" = 5
ORDER BY FIRST_NAME ASC

------------------------------- second solution

SELECT first_name, email, department, salary,
NTH_VALUE(SALARY,5) OVER(PARTITION BY department
						 ORDER BY SALARY DESC)
FROM employees
ORDER BY 1
