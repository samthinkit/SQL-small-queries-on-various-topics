###############################################################
###############################################################
-- Guided Project: SQL Window Functions for Analytics
###############################################################
###############################################################

#############################
-- Task One: Getting Started
-- In this task, we will get started with the project
-- by retrieving all the data in the projectdb database
#############################
-- sales and customers tables imported from csv file using postgresql graphical user interface



-- 1.1: Retrieve all the data in the projectdb database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Window Functions - Refresher
-- In this task, we will refresh our understanding
-- of using window functions in SQL
#############################

-- 2.1: Retrieve a list of employee_id, first_name, hire_date, 
-- and department of all employees ordered by the hire date
SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER (ORDER BY hire_date) AS Row_N
FROM employees;

--SAME TABLE without ordering number column
SELECT employee_id, first_name, department, hire_date
FROM employees
ORDER BY hire_date;


-- 2.2: Retrieve the employee_id, first_name, 
-- hire_date of employees for different departments

SELECT employee_id, first_name, hire_date,department,
ROW_NUMBER() OVER  ( PARTITION BY department
	ORDER BY hire_date) AS "ROW_N"
FROM employees;


SELECT employee_id, first_name, hire_date,department,
RANK() OVER  ( PARTITION BY department
	ORDER BY hire_date) AS "ROW_N"
FROM employees;

#############################
-- Task Three: Ranking
-- In this task, we will learn how to rank the
-- rows of a result set
#############################

-- 3.1: Recall the use of ROW_NUMBER()
SELECT first_name, email, department, salary,
ROW_NUMBER() OVER(PARTITION BY department
				  ORDER BY salary DESC)
FROM employees;

-- 3.2: Let's use the RANK() function
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department
				  ORDER BY salary DESC) rank_n
FROM employees;


-- Exercise 3.1: Retrieve the hire_date. Return details of
-- employees hired on or before 31st Dec, 2005 and are in
-- First Aid, Movies and Computers departments 
SELECT first_name, email, department, salary, hire_date,
RANK() OVER(PARTITION BY department
			ORDER BY salary DESC)
FROM employees
WHERE hire_date <= '2005-12-31' AND department IN('First Aid', 'Movies', 'Computers' );

-- This returns how many employees are in each department
SELECT department, COUNT(*) dept_count
FROM employees
GROUP BY department
ORDER BY dept_count DESC;

-- 3.3: Return the fifth ranked salary for each department
WITH CTE AS (
SELECT salary, department,
RANK() OVER (PARTITION BY department ORDER BY salary ) AS RANKING
FROM employees
) 
SELECT salary,  department, RANKING
FROM CTE
WHERE RANKING = 5

--SECOND SOLUTION 

SELECT salary,  department, RANKING
FROM 
(SELECT salary, department,
RANK() OVER (PARTITION BY department ORDER BY salary ) AS RANKING
FROM employees ) RANK_TABLE
WHERE RANKING = 5


SELECT * FROM SALES

-- Create a common table expression to retrieve the customer_id, 
-- and how many times the customer has purchased from the mall 
WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)


-- 3.4: Understand the difference between ROW_NUMBER, RANK, DENSE_RANK
WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)

SELECT customer_id, purchase,
ROW_NUMBER() OVER (ORDER BY purchase DESC) AS Row_N,
RANK() OVER (ORDER BY purchase DESC) AS Rank_N,
DENSE_RANK() OVER (ORDER BY purchase DESC) AS Dense_Rank_N
FROM purchase_count
ORDER BY purchase DESC;

#############################
-- Task Four: Paging: NTILE()
-- In this task, we will learn how break/page
-- the result set into groups
#############################

-- 4.1: Group the employees table into five groups
-- based on the order of their salaries
SELECT *,
	NTILE(5) OVER (ORDER BY SALARY)
FROM EMPLOYEES

-- 4.2: Group the employees table into five groups for 
-- each department based on the order of their salaries
SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department
			  ORDER BY salary DESC)
FROM employees;

-- Create a CTE that returns details of an employee
-- and group the employees into five groups
-- based on the order of their salaries
WITH salary_ranks AS (
SELECT first_name, email, department, salary,
NTILE(5) OVER(ORDER BY salary DESC) AS rank_of_salary
FROM employees)

-- 4.3: Find the average salary for each group of employees
WITH salary_ranks AS (
SELECT first_name, email, department, salary,
NTILE(5) OVER(ORDER BY salary DESC) AS rank_of_salary
FROM employees)

SELECT first_name, email, department, rank_of_salary,
AVG(SALARY) OVER (PARTITION BY rank_of_salary )
FROM salary_ranks

--SECOND SOLUITION 
WITH salary_ranks AS (
SELECT first_name, email, department, salary,
NTILE(5) OVER(ORDER BY salary DESC) AS rank_of_salary
FROM employees)

SELECT rank_of_salary, AVG(SALARY)
FROM salary_ranks
GROUP BY 1
ORDER BY 1
#############################
-- Task Five: Aggregate Window Functions - Part One
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- 5.1: This returns how many employees are in each department
SELECT department, COUNT(*) AS dept_count
FROM employees
GROUP BY 1
ORDER BY 2 ;

-- 5.2: Retrieve the first names, department and 
-- number of employees working in that department
SELECT first_name, department, 
(SELECT COUNT(*) AS dept_count FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
GROUP BY department, first_name
ORDER BY department;



-- The solution
SELECT first_name, department,COUNT(first_name) OVER (PARTITION BY DEPARTMENT)
FROM employees
ORDER BY 2,1;

-- 5.3: Total Salary for all employees

SELECT SUM(SALARY) FROM public.employees

-- 5.4: Total Salary for each department
SELECT DISTINCT department, SUM(SALARY) OVER (PARTITION BY department)
FROM public.employees
order by 2

SELECT department, SUM(SALARY) FROM public.employees
group by 1
order by 2



-- Exercise 5.1: Total Salary for each department and
-- order by the hire date. Call the new column running_total
SELECT first_name, hire_date, department, salary,
SUM(SALARY) OVER(PARTITION BY department 
				 ORDER BY hire_date) AS running_total
FROM employees;

#############################
-- Task Six: Aggregate Window Functions - Part Two
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- Retrieve the different region ids
SELECT DISTINCT region_id
FROM employees;

-- 6.1: Retrieve the first names, department and 
-- number of employees working in that department and region
SELECT first_name, department,region_id,
count(*) over (partition by department) DEP_COUNT,
count(*) over (partition by region_id) REG_COUNT
from public.employees




-- Exercise 6.1: Retrieve the first names, department and 
-- number of employees working in that department and in region 2
SELECT first_name, department, 
COUNT(*) OVER (PARTITION BY department) AS dept_count
FROM employees
WHERE region_id = 2;

-- Create a common table expression to retrieve the customer_id, 
-- ship_mode, and how many times the customer has purchased from the mall
WITH purchase_count AS (
SELECT customer_id, ship_mode, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id, ship_mode
ORDER BY purchase DESC
)

-- Exercise 6.2: Calculate the cumulative sum of customers purchase
-- for the different ship mode
WITH purchase_count AS (
SELECT customer_id, ship_mode, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id, ship_mode
ORDER BY purchase DESC
)


SELECT customer_id, ship_mode, purchase, 
SUM(Purchase) OVER (PARTITION BY ship_mode ORDER BY customer_id ASC) AS sum_of_sales
FROM purchase_count;



#############################
-- Task Seven: Window Frames - Part One
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 7.1: Calculate the running total of salary
-- Retrieve the first_name, hire_date, salary
-- of all employees ordered by the hire date
SELECT first_name, hire_date, salary
FROM employees
ORDER BY hire_date;

-- The solution

SELECT first_name,  hire_date, salary,
SUM(SALARY) OVER ( ORDER BY  hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CUMULATIVE
FROM employees


-- below two is the same
SELECT first_name,  hire_date, salary,
SUM(SALARY) OVER ( ORDER BY  hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM employees


SELECT first_name,  hire_date, salary,
SUM(SALARY) OVER ( ORDER BY  hire_date )
FROM employees


-- 7.2: Add the current row and previous row
SELECT first_name,  hire_date, salary,
SUM(SALARY) OVER ( ORDER BY  hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
FROM employees





-- 7.3: Find the running average
SELECT first_name,  hire_date, salary,
AVG(SALARY) OVER (ORDER BY  hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM employees



-- What do you think the result of the query will be?
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date 
				 ROWS BETWEEN
				 3 PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

--IT WILL GIVE 3 PREVIOUS AND CURRENT ROW SUM OF THE SALARY FOR EVERY CELL OF SALARY


#############################
-- Task Eight: Window Frames - Part Two
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 8.1: Review of the FIRST_VALUE() function
SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department asc) first_department
FROM departments;

-- 8.2: Retrieve the last department in the departments table
SELECT * FROM departments
order by division

SELECT department,division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) FIRST_department,
FIRST_VALUE(department) OVER(ORDER BY department DESC) LAST_department
FROM departments;

---same output with "RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING"
SELECT department,division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) AS FIRST_department,
LAST_VALUE(department) OVER(ORDER BY department ASC
							RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
						     AS LAST_department
FROM departments;



-- Create a common table expression to retrieve the customer_id, 
-- ship_mode, and how many times the customer has purchased from the mall
WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)


-- What do you think this will return?
WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)


SELECT customer_id, purchase, 
MAX(purchase) OVER(ORDER BY customer_id ASC) AS max_of_sales,
MAX(purchase) OVER(ORDER BY customer_id ASC
				  ROWS BETWEEN
				  CURRENT ROW AND 1 FOLLOWING) AS next_max_of_sales
FROM purchase_count;

-- WE CANT USE COUNT AND MAX AT THE SAME TIME THATS WHY WE USE CTE THEN NORMAL SELECT FUNC.
-- CUSTOMERID, PURCHASE, CUMULATIVE MAX OF SALES IN TERMS OF CUSTOMERID IN AN ASCENDING ORDER,
-- CUMULATIVE MAXIMUM OF SALES BUT ONLY FOR CURRENT CELL(PURCHASE) AND THE NEXT AFTER


#############################
-- Task Nine: GROUPING SETS, ROLLUP() & CUBE()
-- In this task, we will learn how the GROUPING SETS, 
-- ROLLUP, and CUBE clauses work in SQL
#############################

-- 9.1: Find the sum of the quantity for different ship modes
SELECT ship_mode, SUM(quantity) 
FROM sales
GROUP BY ship_mode;

-- 9.2: Find the sum of the quantity for different categories
SELECT category, SUM(quantity) 
FROM sales
GROUP BY category;

-- 9.3: Find the sum of the quantity for different subcategories
SELECT sub_category, SUM(quantity) 
FROM sales
GROUP BY sub_category;

-- 9.4: Use the GROUPING SETS clause
-- NOTE THE DİFFERENCE BETWEEN GROUPING SETS AND GROUP BY IS THAT 
SELECT ship_mode, category, sub_category, SUM(quantity) 
FROM SALES
GROUP BY GROUPING SETS(  1, 2, 3, ()   )

--9.5: Use the ROLLUP clause
SELECT ship_mode, category, sub_category, SUM(quantity) 
FROM SALES
GROUP BY ROLLUP (  1, 2, 3 )

--IT GIVES SINGLE , DUAL AND TRİPLE COMBINATION OF CATEGORY   (1), (1,2), (1,2,3)

--9.6: Use the CUBE clause
SELECT ship_mode, category, sub_category, SUM(quantity) 
FROM SALES
GROUP BY CUBE (  1, 2, 3 ) 


--CUBE FUNCTION DIFFER THAN ROLLUP BECAUSE IT GIVES DIFFERENT COMBINATION ABOVE IS 3 BELOW IS 6 LOOK AT THAT 

--  (1,2,3), (1), (2,3), (2), (1,3), (3) PERMUTATION 