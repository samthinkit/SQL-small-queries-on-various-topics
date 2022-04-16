###############################################################
###############################################################
-- Guided Project: SQL Date-Time Functions
###############################################################
###############################################################
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
	Category VARCHAR(255),
	Sub_Category VARCHAR(255),
	Sales DECIMAL(10,5),
	Quantity INT,
    Discount DECIMAL(4,2),
	Profit DECIMAL(10,5)
);




TRUNCATE TABLE sales 
RESTART IDENTITY;


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data in the employees, sales, dept_manager, salaries table
SELECT * FROM public.employees;
SELECT * FROM public.sales
SELECT * FROM public.dept_manager
SELECT * FROM public.salaries
#############################
-- Task Two: Current Date & Time
-- In this task, we will learn how to use a number of functions 
-- that return values related to the current date and time. 
#############################

-- 2.1: Retrieve the current date
SELECT CURRENT_DATE;

-- 2.2: Retrieve the current time
SELECT CURRENT_TIME;

-- 2.3: Retrieve the current timestamp
SELECT CURRENT_TIMESTAMP;

-- 2.4: Retrieve the current date, current date, time, and timestamp
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIME(1), CURRENT_TIME(3), CURRENT_TIMESTAMP;

-- 2.5: Retrieve the time of the day
SELECT transaction_timestamp();
SELECT timeofday();
SELECT now();

#############################
-- Task Three: 
() - Part One
-- In this task, we will learn how to use the AGE() function to subtract arguments, 
-- producing a "symbolic" result that uses years and months
#############################

-- 3.1: Check the difference between February 28th, 2021 and December 31st, 2019
SELECT age(timestamp '2021-02-28', timestamp '2019-12-31');
SELECT age('2021-02-28', '2019-12-31');
-- 3.2: How old is the Batman movie that was released March 30, 1939
SELECT age(now(), timestamp '1939-03-30');
SELECT age(CURRENT_DATE, timestamp '1939-03-30');
-- 3.3: Retrieve a list of the current age of all employees
SELECT  first_name, last_name, AGE( CURRENT_DATE,  birth_date) FROM public.employees;


-- 3.4: Retrieve a list of all employees ages as at when they were employed
SELECT  first_name, last_name, AGE( hire_date,  birth_date) FROM public.employees;

-- 3.5: Retrieve a list of how long a manager worked at the company
SELECT first_name, last_name, AGE(to_date , from_date ) FROM public.dept_manager DM
JOIN public.employees E ON DM.emp_no=E.emp_no;

-- 3.6: Retrieve a list of how long a manager have been working at the company
SELECT emp_no, AGE(CURRENT_DATE, from_date) AS Age
FROM dept_manager
WHERE emp_no IN ('110039', '110114', '110228', '110420', '110567', '110854', '111133', '111534','111939');

SELECT DM.emp_no ,first_name, last_name, AGE(NOW() , from_date ) FROM public.dept_manager DM
JOIN public.employees E ON DM.emp_no=E.emp_no
WHERE DM.emp_no IN ('110039', '110114', '110228', '110420', '110567', '110854', '111133', '111534','111939');

#############################
-- Task Four: AGE() - Part Two
-- In this task, we will learn how the AGE() function to subtract arguments, 
-- producing a "symbolic" result that uses years and months
#############################

-- 4.1: Retrieve a list of how long a manager worked at the company
SELECT DM.emp_no , first_name, last_name,
CASE 
	WHEN AGE(to_date , from_date ) < AGE(NOW() , from_date ) THEN AGE(to_date , from_date )
	ELSE AGE(NOW() , from_date )
END

FROM public.dept_manager DM
JOIN public.employees E ON DM.emp_no=E.emp_no


-- 4.2: Retrieve a list of how long it took to ship a product to a customer
SELECT *, AGE( ship_date   ,order_date) FROM sales
ORDER BY AGE( ship_date   ,order_date) DESC;


-- 4.3: Retrieve all the data from the salaries table
SELECT * FROM salaries;


-- 4.4: Retrieve a list of the first name, last name, salary 
-- and how long the employee earned that salary
SELECT first_name, last_name, salary, to_date, from_date, AGE(to_date , from_date)
FROM public.salaries S
JOIN public.employees E ON S.emp_no=E.emp_no;



-- A better result
SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date,
CASE
	WHEN AGE(to_date, from_date) < AGE(CURRENT_DATE, from_date) THEN AGE(to_date, from_date)
	ELSE AGE(CURRENT_DATE, from_date)
END 
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no;

#############################
-- Task Five: EXTRACT() - Part One
-- In this task, we will see how the EXTRACT() function 
-- to retrieve subfields like year or hour from date/time values
#############################

-- 5.1: Extract the day of the month from the current date
SELECT EXTRACT(DAY FROM CURRENT_DATE);

-- 5.2: Extract the day of the week from the current date

SELECT EXTRACT(WEEK FROM CURRENT_DATE);
SELECT EXTRACT(ISODOW FROM CURRENT_DATE);
SELECT EXTRACT(DOW FROM CURRENT_DATE);
-- 5.3: Extract the hour of the day from the current date
SELECT EXTRACT(HOUR FROM NOW());
SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP);


-- 5.4: What do you think this result will be?
SELECT EXTRACT(DAY FROM DATE('2019-12-31'));
/*######   31   ######*/

-- 5.5: What do you think this result will be?
SELECT EXTRACT(YEAR FROM DATE('2019-12-31'));
/*######   2019   ######*/
-- 5.6: What about this one?
SELECT EXTRACT(MINUTE from '084412'::TIME);
/* *****  44 *******/
-- 5.7: Retrieve a list of the ship mode and how long (in seconds) it took to ship a product to a customer

select ship_mode, (extract(epoch FROM ship_date) - EXTRACT(epoch from order_date)) AS how_long 
from sales ORDER BY 2 DESC





-- 5.8: Retrieve a list of the ship mode and how long (in days) it took to ship a product to a customer
SELECT ship_mode, AGE(ship_date,order_date) FROM SALES ORDER BY 2 DESC

SELECT order_line, order_date, ship_date, 
(EXTRACT(DAY FROM ship_date) - EXTRACT(DAY FROM order_date)) AS days_taken
FROM sales
ORDER BY days_taken DESC;

-- 5.9: Retrieve a list of the current age of all employees
SELECT first_name,last_name, (EXTRACT( YEAR FROM CURRENT_DATE ) - EXTRACT(YEAR FROM birth_date)) AS AGE  from public.employees
SELECT first_name,last_name, AGE(CURRENT_DATE,birth_date) from public.employees

-- 5.10: Retrieve a list of the current age of all employees
SELECT first_name, last_name, birth_date, 
(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)) || ' years' AS emp_age
FROM employees;

#############################
-- Task Six: EXTRACT() - Part Two
-- In this task, we will see how the EXTRACT() function 
-- to retrieve subfields like year or hour from date/time values
#############################

-- 6.1: Retrieve a list of all employees ages as at when they were employed
SELECT first_name, last_name, birth_date,
(EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) || ' years' AS emp_age
FROM employees;


-- 6.2: Retrieve a list of all employees who were 25 or less than 25 years as at when they were employed
SELECT first_name, last_name, birth_date, hire_date, 
(EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) AS Employed_25
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25;

-- 6.3: How many employees were 25 or less than 25 years as at when they were employed
SELECT  COUNT((EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25) AS COUNTED
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25;




------SOLUTION 2  FOR 6.3
SELECT  SUM(COUNT(*)) OVER (ORDER BY first_name) AS COUNTED
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25
GROUP BY first_name 
ORDER BY 1 DESC
FETCH FIRST 1 ROW ONLY;



-- 6.4: What do you think will be the result of this query?
SELECT (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) || ' years' AS Age_group,
COUNT((EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date))) AS Num_Employed
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25
GROUP BY age_group
ORDER BY age_group;

--SAME RESULT AS PREVIOUS
SELECT  (DATE_PART('year', hire_date)-DATE_PART('year', birth_date))   || ' years'  AS Age_group,  COUNT(*)
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25
GROUP BY 1
ORDER BY 1

-- IT WILL GIVE  employees who were 25 or less than 25 years as at when they were employed GROUP BY AGE_GROUP

-- 6.5: Retrieve all data from the sales table
SELECT * FROM sales;

-- 6.6: Retrieve a list of the product_id, the month of sales and sales
-- for chair sub category in the year 2015
SELECT product_id, DATE_PART('month', ship_date), sales
FROM sales
WHERE sub_category = 'Chairs' and  EXTRACT(year from order_date) = 2015

-- 6.7: Retrieve a list of the month of sales and sum of sales
-- for each month for chair sub category in the year 2015
SELECT DATE_PART('month', ship_date), sum(sales)
FROM sales
WHERE sub_category = 'Chairs' and  EXTRACT(year from order_date) = 2015
GROUP BY 1
order by 1
#############################
-- Task Seven: Converting Date to Strings
-- In this task, we will see how to convert dates to strings
#############################

-- 7.1: Change the order date in the sales table to strings
SELECT TO_CHAR(order_date,'MM-DD-YYYY') FROM public.sales

-- 7.2: Change the order date in the sales table to strings

SELECT TO_CHAR(order_date,'MONTH/DAY/YYYY') FROM public.sales
-- 7.3: Change the order date in the sales table to strings
SELECT TO_CHAR(order_date,'MONTH.DD.YYYY') FROM public.sales

-- 7.4: What do you think will be the result of this?
SELECT order_date, TO_CHAR(order_date, 'Month DAY, YYYY')
FROM sales;

-- Month like November TUESDAY, 2015


-- 7.5: What do you think will be the result of this?
SELECT *, TO_CHAR(hire_date, 'Day, Month DD YYYY') AS hired_date
FROM employees;


--- Monday, November 05  2015

-- 7.6: Retrieve a list of the month of sales and sum of sales
-- for each month for chair sub category in the year 2015
SELECT TO_CHAR(ship_date, 'MONTH')  , SUM(SALES)
FROM public.sales
WHERE sub_category = 'Chairs' and  EXTRACT(year from order_date) = 2015
GROUP BY 1
ORDER BY 1


-- 7.7: Retrieve a list of the month of sales and sum of sales
-- for each month in the right order for chair sub category in the year 2015
SELECT DATE_PART('month', ship_date) , TO_CHAR(ship_date, 'MONTH')  , SUM(SALES)
FROM public.sales
WHERE sub_category = 'Chairs' and  EXTRACT(year from order_date) = 2015
GROUP BY 1,2
ORDER BY 1

-- 7.8: Add a currency (dollars) to the sum of monthly sales
SELECT EXTRACT(MONTH FROM ship_date) AS sales_month, 
TO_CHAR(ship_date, 'Month') AS full_sales_month, TO_CHAR(SUM(sales), '$99999.99') AS monthly_total
FROM sales
WHERE sub_category = 'Chairs' AND order_id LIKE '%2015%'
GROUP BY full_sales_month, sales_month
ORDER BY sales_month;

#############################
-- Task Eight: Converting Strings to Date
-- In this task, we will see how to convert strings to dates
#############################

-- 8.1: Change '2019/12/31' to the correct date format
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD' )

-- 8.2: Change '20191231' to the correct date format

SELECT TO_DATE('20191231', 'YYYYMMDD' )

-- 8.3: Change '191231' to the correct date format
SELECT TO_DATE('191231', 'YYMMDD' )

-- 8.4: What do you think will be the result of this?
SELECT TO_DATE('123119', 'MMDDYY');

--2019-12-31

-- 8.5: Retrieve all the data from the employees table
SELECT * FROM employees;

-- Start transaction
BEGIN;

ALTER TABLE employees
ALTER COLUMN hire_date TYPE VARCHAR(10);

SELECT * FROM employees;

-- Change the hire_date to a correct date format
SELECT *,TO_DATE(hire_date, 'YY-MM-DD' ) FROM employees;

-- End the transaction
ROLLBACK;

ALTER TABLE employees ALTER COLUMN hire_date TYPE DATE 
using to_date(hire_date, 'YYYY-MM-DD');

