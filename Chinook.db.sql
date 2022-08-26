-- In this page I answer various questions about the Chinook database using SQL


-- #1 Show Customers (their full names, customer ID, and country) who are not in the US. 
SELECT FirstName, LastName, CustomerId, Country
FROM customers c 
WHERE NOT Country = "USA";


-- #2 Show only the Customers from Brazil.
SELECT *
FROM customers c 
WHERE Country = "Brazil";


-- #3 Find the Invoices of customers who are from Brazil. The resulting table should show the customer's full name, Invoice ID, Date of the invoice, and billing country.
SELECT c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
FROM customers c
LEFT JOIN invoices i 
ON c.CustomerId = i.CustomerId
WHERE I.BillingCountry = "Brazil";


-- #4 Show the Employees who are Sales Agents.
SELECT *
FROM employees e 
WHERE Title like "%Sales% %Agent%";


-- #5 Find a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM invoices i;


-- #6 Provide a query that shows the invoices associated with each sales agent. The resulting table should include the Sales Agent's full name.
SELECT i.invoiceId, e.Title, e.FirstName, e.LastName
FROM customers c 
join employees e ON C.SupportRepid=e.EmployeeId
join invoices i on c.CustomerId = i.CustomerId;


-- #7 Show the Invoice Total, Customer name, Country, and Sales Agent name for all invoices and customers.
SELECT i.Total, c.FirstName, C.LastName, c.Country, e.FirstName, E.LastName
FROM customers c 
join employees e ON C.SupportRepid=e.EmployeeId
join invoices i on c.CustomerId = i.CustomerId;


-- #8 How many Invoices were there in 2009?
SELECT Count(*) as total_invoices
FROM invoices i
WHERE InvoiceDate BETWEEN "2009-01-01" AND "2009-12-31";


-- #9 What are the total sales for 2009?
SELECT SUM(Total) as total_sales
FROM invoices i 
WHERE InvoiceDate BETWEEN "2009-01-01" AND "2009-12-31";;


-- #10 Write a query that includes the purchased track name with each invoice line item.
SELECT t.Name, it.InvoiceLineId
FROM tracks t 
JOIN invoice_items it
ON t.TrackId  = it.TrackId;


-- #11 Write a query that includes the purchased track name AND artist name with each invoice line item.
SELECT t.Name, t.Composer, it.InvoiceLineId
FROM invoice_items it
JOIN tracks t 
ON t.TrackId  = it.TrackId;


-- #12 Provide a query that shows all the Tracks, and include the Album name, Media type, and Genre.
SELECT t.TrackId, t.Name AS Track_Name, a.Title AS Album_Name , mt.Name AS MediaType, g.Name AS Genre
FROM tracks t 
LEFT JOIN media_types mt 
ON t.MediaTypeId = mt.MediaTypeId 
LEFT JOIN albums a 
ON t.AlbumId = a.AlbumId 
LEFT JOIN genres g 
ON t.GenreId = g.GenreId 



-- #13 Show the total sales made by each sales agent.
SELECT e.FirstName, e.LastName, e.Title,SUM(i.Total) as total 
FROM employees e
JOIN invoices i 
ON i.CustomerId =c.CustomerId 
JOIN customers c  
ON c.SupportRepId = e.EmployeeId  
WHERE Title LIKE "%Sales% %Agent%"
GROUP BY e.FirstName;



-- #14 Which sales agent made the most in sales in 2009?
SELECT (e.FirstName ||" "|| e.LastName) as Full_Name, SUM(i.total) as Total
FROM employees e 
JOIN invoices i 
ON i.CustomerId = c.CustomerId 
JOIN customers c 
ON c.SupportRepId = e.EmployeeId
WHERE (i.InvoiceDate like "%2009%")
AND Title like "%sales%"
GROUP BY Full_Name
ORDER BY Total DESC;






