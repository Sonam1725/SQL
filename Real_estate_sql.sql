/* In this project, we will perform data wrangling process on a Real Estate dataset retreived from Data.gov and help a real estate company make the best
 * investment. This dataset consists of sales of different property from the year 2001 to 2020 in the state of Connecticut. */


Select * 
From Real_Estate;


/* We know that each property had a Assessed_value of atleast 2,000 and sale_amount for atleast 2,000. 
Update these columns so each property is worth no less than 2000? */

Update Real_Estate 
Set Assessed_Value = 2000
Where Assessed_Value < 2000;

Update Real_Estate 
Set Sale_Amount = 2000
Where Sale_Amount < 2000;

-- Updating the Null values with average value.
Update Real_Estate 
Set Assessed_Value = (Select Avg(Assessed_Value) 
From Real_Estate)
where Assessed_Value = Null;

-- Updating the Null values with average value.
Update Real_Estate 
Set Sale_Amount = (Select Avg(Sale_Amount) 
From Real_Estate)
where Sale_Amount = Null;

-- Checking for outliers in Assessed value
Select Min(Assessed_value), Max(Assessed_Value), Round(avg(Assessed_Value),0) as avg_assessed_price
From Real_Estate;

Select Assessed_value
From Real_Estate
Order by Assessed_Value desc;

Select * 
From Real_Estate
where Assessed_Value = 881510000;

/* Looking at the max assessed value, it seems like an outlier due the assessed value being so much different than the sale amount.
 * We can either delete this record or we can replace it with the average price. */

Update Real_Estate 
Set Assessed_Value = (Select Avg(Assessed_Value) 
From Real_Estate)
where Assessed_Value = 881510000;

-- Checking for outliers in sale amount.
Select Min(Sale_Amount), Max(Sale_Amount), Round(avg(Sale_Amount),0) as avg_sale_amount
From Real_Estate;

Select * 
From Real_Estate
Order by Sale_Amount desc;

/* There seems to be an outlier in max sale amount. The assessed value is 2 million so the sale amount seems unrealisic to be sold for 5 billion.
 * We will update this using the average sale amount. */

Update Real_Estate 
Set Sale_Amount = (Select Avg(Sale_Amount) 
From Real_Estate)
where Sale_Amount = 5000000000;


-- For the Property_Type field we will replace null values with unknown.
Update Real_Estate 
Set Property_Type = 'Unknown'
where Property_Type is Null;

-- We will drop the Residential_Type Field because we don't need it.

Alter table Real_Estate 
Drop column Residential_Type;


-- Updating all the other fields with null to unkown.
Update Real_Estate 
Set Non_Use_Code = "Unkown"
where Non_Use_Code is null;

Update Real_Estate 
Set Assessor_Remarks = "Unkown"
where Assessor_Remarks is null;

Update Real_Estate 
Set OPM_remarks = "Unkown"
where OPM_remarks is null;

Update Real_Estate 
Set Location = "Unkown"
where Location is null;



-- Using the Real Estate dataset from Connecticut, a real estate company wants to know which property would be the best investment in the future?


-- Which town sold the most propertites and what was the average price of these properties?
Select Town, Count(DISTINCT Address) as total_properties, Round(avg(Sale_Amount),0) as avg_sold_price
FROM Real_Estate
Where Town != '***Unknown***'
Group by Town 
Order by total_properties desc;

-- Did the overall property value increase by year? 
Select STRFTIME('%Y', Date_Recorded) as year_sold, Property_Type,Round(Avg(Assessed_value),0) as avg_accessed_price, 
Round(Avg(Sale_Amount),0) as avg_sale_amount,Count(DISTINCT Address) as total_properties
From Real_Estate
Where year_sold not null
Group by year_sold,Property_Type;


-- From the top 5 towns with the  most sold propertites, how many of each property type did each town sell?
Select Town,
Sum(Case when Property_Type = "Commercial" then 1 else 0 end) as Commercial,
Sum(Case when Property_Type = "Residential" then 1 else 0 end) as Residential,
Sum(Case when Property_Type = "Vacant Land" then 1 else 0 end) as Vacant_Land,
Sum(Case when Property_Type = "Unknown" then 1 else 0 end) as Unknown_type,
Sum(Case when Property_Type = "Apartments" then 1 else 0 end) as Apartments,
Sum(Case when Property_Type = "Industrial" then 1 else 0 end) as Industrial,
Sum(Case when Property_Type = "Public Utility" then 1 else 0 end) as Public_Utility,
Sum(Case when Property_Type = "Condo" then 1 else 0 end) as Condo,
Sum(Case when Property_Type = "Two Family" then 1 else 0 end) as Two_Family,
Sum(Case when Property_Type = "Three Family" then 1 else 0 end) as Three_Family,
Sum(Case when Property_Type = "Single Family" then 1 else 0 end) as Single_Family,
Sum(Case when Property_Type = "Four Family" then 1 else 0 end) as Four_Family
From Real_Estate
Where Town != "***Unknown***"
Group by Town
Order by Count(DISTINCT Address) desc
Limit 5; 

-- Did the difference in length of the year listed and year sold affect the sales ratio?
With time_diff as
(Select Sales_Ratio, Listed_Year, STRFTIME('%Y', Date_Recorded) as Year_sold 
From Real_Estate)
Select Sales_Ratio, (Year_sold - Listed_Year) as time_diff
From time_diff;








-- For the top 5 towns with the most properties sold, many times did each property type sell within the same year and how many took longer to sell.
With town_group as
(Select Address, Town, (STRFTIME('%Y', Date_Recorded) - Listed_Year) as time_diff
From Real_Estate
where Town != "***Unknown***")
Select Town,
Count(Case when time_diff = 0 then 1 else null end) as less_than_0,
Count(Case when time_diff >= 1 then 1 else null end) as more_than_1_year
From town_group
Group by Town
Order by Count(DISTINCT Address) desc
Limit 5;


-- Did the increase in price impact the overall amount of property sold for each property type?
Select Property_Type, Count(DISTINCT Address) as total_properties, Round(avg(Sale_Amount),0) as avg_sold_price 
From Real_Estate
Group by Property_Type
Order by avg_sold_price;





