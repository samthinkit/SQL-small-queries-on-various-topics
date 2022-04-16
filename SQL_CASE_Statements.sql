###############################################################
###############################################################
-- Guided Project: SQL CASE Statements
###############################################################
###############################################################
--CREATE DATABASE FOR CASE PROJECT

CREATE DATABASE "SQL CASE "
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- Create the customers table
CREATE TABLE customers
(
    Customer_ID CHAR(8) PRIMARY KEY,
	Bracket_cust_id CHAR(10),
    Customer_Name VARCHAR(255),
    Segment VARCHAR(255),
    Age INT,
	Country VARCHAR(255),
	City VARCHAR(255),
	State VARCHAR(255),
    Postal_Code INT,
	Region VARCHAR(255)
);

-- Create the sales table
CREATE TABLE sales
(
    Order_line INT,
	Order_ID VARCHAR(255),
	Order_Date DATE,
	Ship_Date DATE,
    Ship_Mode VARCHAR(255),
    Customer_ID CHAR(8),
	Product_ID VARCHAR(255),
	Sales DECIMAL(10,5),
	Quantity INT,
    Discount DECIMAL(4,2),
	Profit DECIMAL(10,5)
);

--SALES AND CUSTOMER TABLES IMPORTED VIA CSV FILE USING POSTGRESQL GUI







#############################
-- Task One: The SQL CASE Statement
-- In this task, we will learn how to write a conditional
-- statement using a single CASE clause
#############################

-- 1.1: Retrieve all the data in the employees table
SELECT * FROM employees;

-- 1.2: Change M to Male and F to Female in the employees table
SELECT emp_no,birth_date,first_name,last_name,hire_date, 
CASE
	WHEN GENDER = 'M' THEN  'MALE' 
	ELSE 'FEMALE'
END AS "NEWGENDER"
FROM employees
-- 1.3: This gives the same result as 1.2
SELECT emp_no,birth_date,first_name,last_name,hire_date, 
CASE
	WHEN GENDER = 'M' THEN  'MALE' 
	WHEN GENDER = 'F' THEN 'FEMALE'
	ELSE GENDER
END AS "NEWGENDER"
FROM employees


-- 1.4: This gives the same result as 1.2 & 1.3
SELECT emp_no,birth_date,first_name,last_name,hire_date, 
CASE GENDER
	WHEN  'M' THEN  'MALE' 
	WHEN  'F' THEN 'FEMALE'
	
END AS "NEWGENDER"
FROM employees


#############################
-- Task Two: Adding multiple conditions to a CASE statement
-- In this task, we will learn how to add multiple conditions to a 
-- CASE statement
#############################

-- 2.1: Retrieve all the data in the customers table
SELECT * FROM customers;

-- 2.2: Create a column called Age_Category that returns Young for ages less than 30,
-- Aged for ages greater than 60, and Middle Aged otherwise

SELECT *, 
CASE 
		WHEN AGE<30 THEN 'Young'
		WHEN AGE<60 THEN 'Middle Aged'
		ELSE 'Aged'
END "Age_Category"
FROM customers

-- 2.3: Retrieve a list of employees that were employed before 1990, between 1990 and 1995, and 
-- after 1995
SELECT *,
CASE 
	WHEN hire_date < '1990-01-01' THEN 'PRE 1990'
	WHEN hire_date < '1995-01-01' THEN 'PRE 1995'
	ELSE 'following 1995'
END AS EMP_DATE_SIGN
FROM employees

--SECOND SOLUTION
SELECT emp_no, hire_date, EXTRACT(YEAR FROM hire_date) AS Year,
CASE 
	WHEN EXTRACT(YEAR FROM hire_date) < 1990 THEN 'EMPLOYED BEFORE 1990'
	WHEN EXTRACT(YEAR FROM hire_date) < 1995 THEN 'EMPLOYED BEFORE 1995 AFTER 1990'
	ELSE 'EMPLOYED AFTER 1995'
END AS EMP_DATE_sgın
FROM employees
-- POSTGRESQL is considering both string and integer for date data that is why even if we could enter data type as string like '1990'

#############################
-- Task Three: The CASE Statement and Aggregate Functions
-- In this task, we will see how to use the CASE clause and
-- SQL aggregate functions to retrieve data
#############################

-- 3.1: Retrieve the average salary of all employees
SELECT * FROM salaries;

SELECT emp_no, AVG(salary)
FROM salaries S
GROUP BY emp_no
ORDER BY AVG(salary) DESC;

-- 3.2: Retrieve a list of the average salary of employees. If the average salary is more than
-- 80000, return Paid Well. If the average salary is less than 80000, return Underpaid,
-- otherwise, return Unpaid
SELECT emp_no, AVG(salary),
CASE
	WHEN AVG(salary) > 80000 THEN 'PAID WELL'
	ELSE 'underpaid'
END
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC;
 
 


-- 3.3: Retrieve a list of the average salary of employees. If the average salary is more than
-- 80000 but less than 100000, return Paid Well. If the average salary is less than 80000, 
-- return Underpaid, otherwise, return Manager

SELECT emp_no,  ROUND( AVG(salary) ,2),
CASE
	WHEN AVG(salary) < 80000 THEN 'UNDERPAID'
	WHEN AVG(salary)<100000  AND AVG(salary) > 80000 THEN 'Paid Well'
	ELSE 'Manager'
END
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC;


-- 3.4: Count the number of employees in each salary category
--SOLUTION I
WITH CTE AS (
SELECT emp_no,        ROUND( AVG(salary) ,2) AS AVEG ,
CASE
	WHEN AVG(salary) < 80000 THEN 'UNDERPAID'
	WHEN AVG(salary)<100000  AND AVG(salary) > 80000 THEN 'Paid Well'
	ELSE 'Manager'
END KINDOFSAL
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC
)
SELECT KINDOFSAL, COUNT(KINDOFSAL) 
FROM CTE
GROUP BY  1
--SOULUTION II
SELECT KINDOFSAL, COUNT(KINDOFSAL) 
FROM (
SELECT emp_no,        ROUND( AVG(salary) ,2) AS AVEG ,
CASE
	WHEN AVG(salary) < 80000 THEN 'UNDERPAID'
	WHEN AVG(salary)<100000  AND AVG(salary) > 80000 THEN 'Paid Well'
	ELSE 'Manager'
END KINDOFSAL
FROM salaries
GROUP BY emp_no
ORDER BY AVG(salary) DESC) T1

GROUP BY  1


--error I get this and solved      via below code message ""
--current transaction is aborted, commands ignored until end of 
--transaction block

connection.setAutoCommit(true);


#############################
-- Task Four: The CASE Statement and SQL Joins
-- -- In this task, we will see how to use the CASE clause and
-- SQL Joins to retrieve data
#############################

-- 4.1: Retrieve all the data from the employees and dept_manager tables
SELECT * FROM employees
ORDER BY emp_no DESC;

-- TRYING :/
SELECT salary, S.emp_no,  S.from_date FROM public.salaries S
JOIN public.dept_emp D ON S.emp_no= D.emp_no
WHERE S.emp_no < 20000




SELECT * FROM dept_manager;

-- 4.2: Join all the records in the employees table to the dept_manager table
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN dept_manager dm 
ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;
	
-- 4.3: Join all the records in the employees table to the dept_manager table
-- where the employee number is greater than 109990
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN dept_manager dm 
ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990;

-- 4.4: Obtain a result set containing the employee number, first name, and last name
-- of all employees. Create a 4th column in the query, indicating whether this 
-- employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name, 
CASE 	
	 WHEN dm.emp_no IS NOT NULL THEN 'MANAGER'
	 ELSE 'USUAL'
END AS "CHECKMANAGER"	
FROM employees e
LEFT JOIN dept_manager dm 
ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;

-- 4.5: Obtain a result set containing the employee number, first name, and last name
-- of all employees with a number greater than '109990'. Create a 4th column in the query,
-- indicating whether this employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee

SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name,
CASE 	
	 WHEN dm.emp_no IS NOT NULL THEN 'MANAGER'
	 ELSE 'USUAL'
END
FROM employees e
LEFT JOIN dept_manager dm 
ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990
ORDER BY dm.emp_no;




#############################
-- Task Five: The CASE Statement together with Aggregate Functions and Joins
-- In this task, we will see how to use the CASE clause together with
-- SQL aggregate functions and SQL Joins to retrieve data
#############################

-- 5.1: Retrieve all the data from the employees and salaries tables
SELECT * FROM employees;

SELECT * FROM salaries;

-- 5.2: Retrieve a list of all salaries earned by an employee
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no;

/* 5.3: Retrieve a list of employee number, first name and last name.
Add a column called 'salary difference' which is the difference between the
employees' maximum and minimum salary. Also, add a column called
'salary_increase', which returns 'Salary was raised by more than $30,000' if the difference 
is more than $30,000, 'Salary was raised by more than $20,000 but less than $30,000',
if the difference is between $20,000 and $30,000, 'Salary was raised by less than $20,000'
if the difference is less than $20,000 */

WITH CTE AS(
SELECT e.emp_no, e.first_name, e.last_name, MAX(salary) - MIN(salary) as "saldif" 

FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
	
GROUP BY 1,2,3
)
SELECT * ,

CASE 
	WHEN saldif > 30000 THEN 'Salary was raised by more than $30,000'
	WHEN saldif > 20000 AND saldif < 30000 THEN 'Salary was raised by more than $20,000 but less than $30,000'
	WHEN saldif <20000 THEN 'Salary was raised by less than $20,000'
END AS salary_increase

FROM CTE
WHERE last_name = 'Matteis'

-- 5.4: Retrieve all the data from the employees and dept_emp tables
SELECT * FROM employees;

SELECT * FROM dept_emp;

/* 5.5: Extract the employee number, first and last name of the first 100 employees, 
and add a fourth column called "current_employee" saying "Is still employed",
if the employee is still working in the company, or "Not an employee anymore",
if they are not more working in the company.
Hint: We will need data from both the 'employees' and 'dept_emp' table to solve this exercise */




SELECT e.emp_no, e.first_name, e.last_name, de.to_date,
CASE
	WHEN MAX(de.to_date) > CURRENT_DATE THEN 'Is still employed'
    ELSE 'Not an employee anymore'
END AS current_employee
FROM employees e
JOIN dept_emp de 
ON e.emp_no = de.emp_no
GROUP BY 1, 4
LIMIT 100;


#############################
-- Task Six: Transposing data using the CASE clause
-- In this task, we will learn how to use the SQL CASE statement to
-- transpose retrieved data
#############################

-- 6.1: Retrieve all the data from the sales table
SELECT * FROM sales;


-- 6.2: Retrieve the count of the different profit_category from the sales table
SELECT a.profit_category, COUNT(*)
FROM (
SELECT order_line, profit,
CASE
	WHEN profit < 0 THEN 'No Profit'
	WHEN profit > 0 AND profit < 500 THEN 'Low Profit'
	WHEN profit > 500 AND profit < 1500 THEN 'Good Profit'
	ELSE 'High Profit'
END AS profit_category 
FROM sales
) a
GROUP BY a.profit_category;

-- 6.3: Transpose 6.2 above
SELECT SUM(CASE WHEN profit < 0 THEN 1  ELSE 0 END) AS NOPROFIT,
	   SUM(CASE WHEN profit >0 and profit <500 THEN 1 ELSE 0 END ) AS LOW,
	   SUM (CASE WHEN profit > 500 AND profit < 1500  THEN 1 ELSE 0 END ) AS MID,
	   SUM(CASE WHEN profit > 1500 	then 1 else 0 end) as high
from sales



-- 6.4: Retrieve the number of employees in the first four departments in the dept_emp table

SELECT * FROM dept_emp;

SELECT dept_no, COUNT(*) 
FROM dept_emp
WHERE dept_no IN ('d001', 'd002', 'd003', 'd004')
GROUP BY dept_no
ORDER BY dept_no;

-- 6.5: Transpose 6.4 above

SELECT SUM(CASE WHEN dept_no = 'd001' THEN 1 ELSE 0 END ) AS D1,
	   SUM(CASE WHEN dept_no = 'd002' THEN 1 ELSE 0 END ) AS D2,
	   SUM(CASE WHEN dept_no = 'd003' THEN 1 ELSE 0 END ) AS D3,
	   SUM(CASE WHEN dept_no = 'd004' THEN 1 ELSE 0 END ) AS D4
FROM dept_emp
