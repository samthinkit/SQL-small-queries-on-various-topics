##########################################################
##########################################################

# Data Definition and Manipulation in SQL

##########################################################
##########################################################

-- creating database called sql beginning

CREATE DATABASE "sql beginning"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
	
#############################
-- Task Two: Data Definition
-- In this task, you will learn how to create database objects (tables) in the database you created in task 1.
#############################

-- Creating the sales table
CREATE TABLE sales
(
    purchase_number INT PRIMARY KEY ,
	date_of_purchase date not null,
	customer_id int not null,
	item_code VARCHAR(10) not null
	
);





-- Creating the customers table


CREATE TABLE customers
(
    Customer_ID INT PRIMARY KEY,
	First_name VARCHAR(255) NOT null,
	last_name VARCHAR(255) NOT NULL,
	EMAIL  VARCHAR(255),
	NUMBER_COMPLAINT INT )






-- Creating the items table

CREATE TABLE ITEMS (
	
item_code VARCHAR(10) PRIMARY KEY,
item VARCHAR(255) 	,
Unit_price_usd DECIMAL (5,2),
Company_id int ,
company_name 	VARCHAR(255) NOT NULL  	
	);







#############################
-- Task Three: Data Manipulation
-- By the end of Task 3, you will be able to insert records into the tables created.
#############################

-- Insert five (5) records into the sales table
INSERT INTO SALES (purchase_number,date_of_purchase, customer_id, item_code )
VALUES
( 1,'2022-12-12',1,'A12'),
(2,'2022-12-13',2,'A13'),
(3,'2022-11-13',3,'A14'),
(4,'2022-10-13',4,'A16'),
(5,'2022-09-13',5,'A17');

SELECT * FROM SALES




-- Insert five (5) records into the customers table


--ANY VALUES CAN BE  INSERTED AS ARBITRARY SO DONT NEED BECAUSE  MOST OF THE TIME DATA ARE CREATED BY MACHINE	



-- Insert five (5) records into the items table

--ANY VALUES CAN BE  INSERTED AS ARBITRARY SO DONT NEED BECAUSE  MOST OF THE TIME DATA ARE CREATED BY MACHINE	




#############################
-- Task Four: Data Manipulation - Part 2
-- By the end of Task 4, you will be able to upload a csv file into your database 
-- and insert records into duplicate tables. 
#############################

-- Create the companies table and upload the CSV file into the table

CREATE TABLE  companies(
company_id INT PRIMARY KEY,
company_name VARCHAR(255),
headquarter_phone_number VARCHAR(255)
	);


SELECT * FROM companies



-- Create the sales_dup table

CREATE TABLE sales_2
(
    purchase_number INT PRIMARY KEY ,
	date_of_purchase date not null,
	customer_id int not null,
	item_code VARCHAR(10) not null
	
);





-- Create the customers_dup table
drop table if exists customers_DUB;

CREATE TABLE  customers_DUB( 


    Customer_ID INT PRIMARY KEY,
	First_name VARCHAR(255) NOT null,
	last_name VARCHAR(255) NOT NULL,
	EMAIL  VARCHAR(255),
	NUMBER_COMPLAINT INT )






-- Insert records from sales table into sales_dup table
INSERT INTO sales_2
SELECT * FROM SALES

select * from sales_2


-- Insert records from customers table into customers_dup table

INSERT INTO customers_DUB

SELECT * FROM public.customers

SELECT * FROM customers_DUB


#############################
-- Task Five: Data Definition and Manipulation
-- By the end of this task, you will be able to alter, rename and update data in tables in a database.
#############################

-- Add a new column gender after the last_name field
-- We will perform this task using ALTER on the customers_dup table

ALTER TABLE customers_DUB
ADD COLUMN GENDER CHAR(2);

SELECT * FROM customers_DUB

-- Insert new records to the customers_dup table

INSERT INTO customers_DUB 
VALUES  ( 6, 'ISRAEL', 'HAVKINS', 'HAVK@HOTMAİL.COM', 2, 'M')


-- Create a companies_dup table
DROP TABLE IF EXISTS companies_DUB;

CREATE TABLE  companies_DUB(
company_id INT PRIMARY KEY,
company_name VARCHAR(255),
headquarter_phone_number VARCHAR(255)
	);





-- Insert records from companies table into the companies_dup table

--renaming for table items
ALTER TABLE items
RENAME unit_price_usd TO item_price





-- ALTER the companies_dup table to add a UNIQUE KEY constraint
-- to the headquarters_phone_number field.



-- Change the company_id column to be auto_increment



-- Change the headquarters_phone_number field to VARCHAR(255) NOT NULL




-- Use RENAME to give the sales_dup table a new name called sales_data
ALTER TABLE SALES
RENAME TO SALESORIJIN;


-- We will UPDATE some records in the customers_dup table
SELECT * FROM public.customers_dub

UPDATE CUSTOMERS_DUB
SET first_name  = 'macedon'
WHERE customer_id = 6 ;

#############################
-- Task Six: Drop Vs. Truncate Vs. Delete
-- By the end of task 6, you will learn how to use SQL drop, truncate and delete statements. 
-- In addition, you will understand the difference between SQL drop, truncate and delete statements.
#############################


-- DROP the customers_dup table
DROP TABLE public.customers_dub


-- TRUNCATE the sales_data table

TRUNCATE TABLE public.salesorijin
SELECT * FROM public.salesorijin

-- DELETE records from the companies_dup table
SELECT * FROM  public.companies

DELETE FROM public.companies
WHERE  company_id = 2 ;


TRUNCATE TABLE public.companies



--note: truncate delete table inside but drop delete completely.
--you cant use where function with truncate. delete is similar to truncate but you can use where with it.  










