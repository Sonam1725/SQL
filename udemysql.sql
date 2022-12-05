use employees;

SELECT 
    dept_no
FROM
    departments;
    
SELECT 
    *
FROM
    departments;
    
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';

-- Retrieve a list with all female employees whose first name is Kellie. 
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F' AND first_name = 'Kellie';

-- Retrieve a list with all employees whose first name is either Kellie or Aruna.
Select *
From employees
where first_name = "Kellie" or first_name = "Aruna";

-- Retrieve a list with all female employees whose first name is either Kellie or Aruna.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');
        
-- Use the IN operator to select all individuals from the “employees” table, whose first name is either “Denis”, or “Elvis”.
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' , 'Elvis');
    
-- Extract all records from the ‘employees’ table, aside from those with employees named John, Mark, or Jacob.
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('John' , 'Jacob');

-- Working with the “employees” table, use the LIKE operator to select the data about all individuals, whose first name starts with “Mark”; specify that the name can be succeeded by any sequence of characters.
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE 'Mark%';

-- Retrieve a list with all employees who have been hired in the year 2000.
SELECT 
    first_name, hire_date
FROM
    employees
WHERE
    hire_date LIKE '%2000%';
    
-- Retrieve a list with all employees whose employee number is written with 5 characters, and starts with “1000”. 
SELECT 
    emp_no, first_name
FROM
    employees
WHERE
    emp_no LIKE '1000_';
    
-- Extract all individuals from the ‘employees’ table whose first name contains “Jack”.
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE '%Jack%';
    
-- Once you have done that, extract another list containing the names of employees that do not contain “Jack”.
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE '%Jack%';
    
-- Select all the information from the “salaries” table regarding contracts from 66,000 to 70,000 dollars per year.
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000;

-- Retrieve a list with all individuals whose employee number is not between ‘10004’ and ‘10012’.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no NOT BETWEEN 10004 AND 10012;
    
-- Select the names of all departments with numbers between ‘d003’ and ‘d006’.
SELECT 
    dept_no, dept_name
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006';
    
-- Select the names of all departments whose department number value is not null.
SELECT 
    *
FROM
    departments
WHERE
    dept_no IS NOT NULL;

-- Retrieve a list with data about all female employees who were hired in the year 2000 or after.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date > '2000-01-01';

-- Extract a list with all employees’ salaries higher than $150,000 per annum.
SELECT 
    *
FROM
    salaries
WHERE
    salary > 150000;

-- Obtain a list with all different “hire dates” from the “employees” table.
SELECT DISTINCT
    hire_date
FROM
    employees
LIMIT 1000;
    
-- How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;
    
-- How many managers do we have in the “employees” database? Use the star symbol (*) in your code to solve this exercise.
SELECT 
    COUNT(*)
FROM
    dept_manager;
    
-- Select all data from the “employees” table, ordering it by “hire date” in descending order.
SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

-- Write a query that obtains two columns. The first column must contain annual salaries higher than 80,000 dollars. The second column, renamed to “emps_with_same_salary”, must show the number of employees contracted to that salary. Lastly, sort the output by the first column.
SELECT 
    salary AS total_salary,
    COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 8000
GROUP BY salary
ORDER BY salary;

-- Select all employees whose average salary is higher than $120,000 per annum.
SELECT 
    emp_no, AVG(salary)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

-- Select the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
SELECT 
    emp_no, COUNT(from_date)
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

-- Select the first 100 rows from the ‘dept_emp’ table. 
SELECT 
    *
FROM
    dept_emp
LIMIT 100;


Insert into employees (
emp_no,
birth_date,
first_name,
last_name,
gender,
hire_date)
values 
(999901,
"1986-04-21",
"John",
"Smith",
"M",
"2011-01-01");

-- Select ten records from the “titles” table to get a better idea about its content.
SELECT 
    *
FROM
    titles
LIMIT 10;


INSERT INTO employees

VALUES

(

    999903,

    '1977-09-14',

    'Johnathan',

    'Creek',

    'M',

    '1999-01-01'

);
-- Then, in the same table, insert information about employee number 999903. State that he/she is a “Senior Engineer”, who has started working in this position on October 1st, 1997.
Insert into titles (
emp_no,
title,
from_date)
values
(
999903,
"Senior Engineer",
"1997-10-01");

-- Insert information about the individual with employee number 999903 into the “dept_emp” table. He/She is working for department number 5, and has started work on  October 1st, 1997; her/his contract is for an indefinite period of time.
Insert into dept_emp (
emp_no,
dept_no,
from_date,
to_date)
Values
(999903,
"d005",
"1997-10-01",
"9999-01-01");

CREATE TABLE department_dup (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

Insert into department_dup(dept_no,dept_name)
(select dept_no,dept_name from departments);

-- Create a new department called “Business Analysis”. Register it under number ‘d010’.
Insert into departments (dept_no, dept_name)
Values ("d010", "Buisness Analysis");

use employees;

-- Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.

Drop procedure if exists emp_info;

Delimiter $$
Create Procedure emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no Integer)
Begin 
Select 
	e.emp_no
into p_emp_no From employees e
where e.first_name = p_first_name and e.last_name = p_last_name;
End $$
Delimiter ;


-- Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
-- Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.
set @v_emp_no = 0;
Call employees.emp_info('Aruna', 'Journel',@p_emp_no);
select @p_emp_no;


-- Creating Function
Delimiter $$
Create Function f_emp_avg_salary(p_emp_no integer) Returns decimal(10,2)
deterministic NO SQL reads sql data
Begin 

Declare v_avg_salary decimal(10,2);

Select 
	Avg(s.salary)
Into v_avg_salary From 
employees e
Join salaries s on e.emp_no = s.emp_no 
where e.emp_no = p_emp_no;
Return v_avg_salary;
End $$
Delimiter ;
 

-- Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee.
DELIMITER $$



CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)

DETERMINISTIC NO SQL READS SQL DATA

BEGIN

                DECLARE v_max_from_date date;

    DECLARE v_salary decimal(10,2);

SELECT

    MAX(from_date)

INTO v_max_from_date FROM

    employees e

        JOIN

    salaries s ON e.emp_no = s.emp_no

WHERE

    e.first_name = p_first_name

        AND e.last_name = p_last_name;

SELECT

    s.salary

INTO v_salary FROM

    employees e

        JOIN

    salaries s ON e.emp_no = s.emp_no

WHERE

    e.first_name = p_first_name

        AND e.last_name = p_last_name

        AND s.from_date = v_max_from_date;

       

                RETURN v_salary;

END$$
DELIMITER ;
SELECT EMP_INFO('Aruna', 'Journel');


-- Case Statement
SELECT 
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS 'Gender'
FROM
    employees;


-- obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN e.emp_no = d.emp_no THEN 'Manager'
        ELSE 'Regular employee'
    END AS 'Employee'
FROM
    employees e
        LEFT JOIN
    dept_manager d ON e.emp_no = d.emp_no
WHERE
    e.emp_no > 109990;
    
-- Extract a dataset containing the following information about the managers: employee number, first name, and last name. Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary),
    CASE
        WHEN (MAX(s.salary) - MIN(s.salary)) > 30000 THEN 'Greater then 30k'
        ELSE 'Not greater than 30k'
    END AS 'Difference'
FROM
    employees e
        JOIN
    dept_manager d ON e.emp_no = d.emp_no
        JOIN
    salaries s ON d.emp_no = s.emp_no
GROUP BY e.emp_no;

-- Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, called “current_employee” saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN max(d.to_date) = '9999-01-01' THEN 'Is still employeed'
        ELSE 'Not an employee anymore'
    END AS 'Current Status'
FROM
    employees e
        JOIN
    dept_emp d ON e.emp_no = d.emp_no
GROUP BY d.emp_no
LIMIT 100;

-- Row Number () Window Function
Select emp_no,
Salary,
Row_Number() over (partition by emp_no)
From Salaries;

-- Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).
Select e.emp_no,
d.dept_no,
row_number() over (order by e.emp_no asc) as "Ranking"
FROM
    employees e
        JOIN
    dept_manager d ON e.emp_no = d.emp_no;
    
-- Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).
Select e.emp_no,
e.first_name,
e.last_name,
row_number() over (partition by e.first_name order by e.last_name)
From employees e;


-- 	Different Window syntax
Select e.emp_no,
e.first_name,
e.last_name,
row_number() over w as row_n
From employees e
Window w as (partition by e.first_name order by e.last_name);

-- Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first names and ordering each partition by their employee number in ascending order.
Select 
	emp_no,
    first_name,
    last_name,
    row_number() over w as row_num
From employees
window w as (partition by first_name order by emp_no asc);

-- Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.
Select 
	a.emp_no,
    a.salary as min_salary
From (
	select s.emp_no,
    s.salary,
	row_number() over w as row_num
	From salaries s
    window w as (partition by s.emp_no order by s.salary)) as a
where row_num = 1;

-- Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
-- Order and display the obtained salary values from highest to lowest.
SELECT 
    emp_no, 
    salary,
    row_number() over w as ranking 
FROM
    salaries
WHERE
    emp_no = 10560
Window w as (partition by emp_no order by salary desc);
    
-- Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.
SELECT 
    d.emp_no, COUNT(salary) AS total_contracts
FROM
    dept_manager d
        JOIN
    salaries s ON d.emp_no = s.emp_no
GROUP BY d.emp_no
ORDER BY total_contracts DESC;

-- Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are allowed.
SELECT 
    emp_no, 
    salary,
    rank() over w as ranking
FROM
    salaries
WHERE
    emp_no = 10560
Window w as (partition by emp_no order by salary desc);
 
-- Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are not allowed.
SELECT 
    emp_no, 
    salary,
    dense_rank() over w as ranking
FROM
    salaries
WHERE
    emp_no = 10560
Window w as (partition by emp_no order by salary desc);

-- Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.
Select 
s.emp_no,
s.salary,
rank() over w as ranking
From employees e
join salaries s 
on e.emp_no = s.emp_no
where e.emp_no between 10500 and 10600
window w as (partition by s.emp_no order by salary desc);



Select 
s.emp_no,
s.salary,
dense_rank() over w as ranking
From employees e
join salaries s 
on e.emp_no = s.emp_no
where e.emp_no between 10500 and 10600
and (year(s.to_date) - year(s.from_date) > 4)
window w as (partition by s.emp_no order by salary desc);


-- The LAG() and LEAD() Value Window Functions - Exercise
Select 
	e.emp_no,
    s.salary,
    lag(s.salary) over w as previous_salary,
    lead(s.salary) over w as future_salary,
    s.salary - lag(s.salary) over w as diff_current_previous,
    lead(s.salary) over w - s.salary as diff
From employees e 
join salaries s 
on e.emp_no = s.emp_no
where e.emp_no between 10500 and 10600
and s.salary > 80000
Window w as (partition by e.emp_no order by salary);


SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;


-- Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, and end dates of the first ever contracts that each employee signed for the company.
SELECT
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;
    
    
-- AGG FUNCTION
SELECT 
	distinct d.dept_name, 
    e.emp_no,
    Avg(s.salary) over w as avg_salary
From salaries s
join dept_emp e
on s.emp_no = e.emp_no
join departments d
on e.dept_no = d.dept_no
WINDOW w as (partition by d.dept_name)
order by e.emp_no;


-- Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).
Select 
	distinct d.emp_no,
    s.salary,
    avg(s.salary) over (partition by dept_no),
    d.dept_no
From dept_emp d
join salaries s 
on d.emp_no = s.emp_no
Where d.from_date between "2000-01-01" and "2002-01-01";
