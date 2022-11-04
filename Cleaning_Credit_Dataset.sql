-- This dataset was retreived from Kaggle. In this analysis, we will first clean the dataset so we can answer some questions. 

SELECT *
From train;

Begin;

-- How many null values are there for name column?
Select count(*)
From train t
WHERE Name is null;


-- Cleaning Age Column
UPDATE train 
set Age = Trim(REPLACE(Age,"_",""));

Alter table train 
Add column Ages int;

Update train  
Set Ages = Age;

Alter table train 
Drop Column Age;

Alter table train 
rename Column Ages to Age;

-- Deleting records from Age field that are not between 0-57 years old because other are too high or too low to be true.
DELETE From train 
where Age not BETWEEN 0 and 57;

-- what age range is there?
Select DISTINCT(Age)
From train t
order by Age asc;

-- Dropping the name column because we won't use it.
Alter table train 
Drop COLUMN Name;

-- What Occupations are there for the users?
Select DISTINCT(Occupation)
From train t;

-- There is a large amount of error values in occupation field. We can either fill in each of the value or drop it.
-- We can see that SSN column allows us to determine who the person is and what their occupation is from previous records.

-- How many records have this mistake.
Select Count(*)
From train  
where Occupation = "_______";

-- We could update the mistakes by using the Update statement in the Data Defination Language but instead we will just delete it because its not important.
Delete from train 
Where Occupation = "_______";


-- We can't convert Annual Income field into Integar right now because it contains a non numeric character (_). We can replace _ with 0 so we can convert Annual Income field into Int.
UPDATE train 
set Annual_Income = Replace(Annual_Income, "_", 0);

Alter table train
ADD column Annual_incomes float;

Update train 
Set Annual_incomes = Annual_Income;

Alter table train 
Drop column Annual_Income;

Alter table train 
rename Annual_incomes to Annual_Income;


-- Let's look at the highest Annual_Income and the lowest Annual_Income.
Select Min(Annual_Income) as min_annual_income, max(Annual_Income) as max_annual_income
From train;

-- We won't be using the Monthly_Inhand_Salary so we can just drop it.
Alter table train 
Drop column Monthly_Inhand_Salary;

-- Taking a look at the Num_Bank_Accounts to see if there are any outliers.
Select Num_Bank_Accounts 
From train t 
order by Num_Bank_Accounts desc;

-- We can see that there are many outliers so we will just delete records that are not in 0-11 range.
Delete FROM train 
where Num_Bank_Accounts not BETWEEN 0 and 11;

-- Let's look at the Interest_Rate.
SELECT Distinct Interest_Rate 
From train t
Order by  Interest_Rate desc;

-- We can delete records in Intrest_Rate field that don't have intrest rate within 0-100 range.
Delete from train 
where Interest_Rate not BETWEEN 0 and 100;


-- Deleting records in Payment_Behavior that we don't need.
Select Distinct Payment_Behaviour
From train;

-- We see that there is error which is !@9#%8.
DELETE from train 
where Payment_Behaviour = "!@9#%8";


-- Cleaning the Monthly_Balance Column.

Select Monthly_Balance
From train t 
Where Monthly_Balance not null
Order by Monthly_Balance DESC;

UPDATE train 
set Monthly_Balance = TRIM(Monthly_Balance) 

Alter table train 
Add column Month_Balances float;

Update train 
set Month_Balances = Monthly_Balance;

Alter table train 
drop column Monthly_Balance;

Select Month_Balances
From train t 
Where Month_Balances not null
Order by Month_Balances DESC;


-- What Credit Score are are possible?

SELECT DISTINCT Credit_Score
From train;




-- Now that we cleaned the dataset, we can analyze and answer questions about the dataset.


-- How many times did each Occupation fall into each Credit_Score category?

Select Occupation, 
Sum(Case when Credit_Score = "Good" then 1 else 0 end) as Good,
Sum(Case when Credit_Score = "Standard" then 1 else 0 end) as Standard,
Sum(Case when Credit_Score = "Poor" then 1 else 0 end) as Poor
fROM train t
Group by Occupation;

-- This can help determine, which Occupation is most likly to fall into each Credit Score.


/* What is the Average Annual Income for each age group? This can help bank company determine what age group likly to be able 
to afford to pay thier loans back. */

Select Age, Round(Avg(Annual_Income),2) as avg_income
From train t
Group by Age
Order by avg_income desc;


/* Which Occupations has the highest Credit Utlization Ratio? This can help determine, which occupation will most likely 
 use their credit card. */

Select Occupation, Round(Avg(Credit_Utilization_Ratio),2) as Avg_Credit_Utilization
From train t
Group by Occupation
Order by Avg_Credit_Utilization desc;

-- For each month, how many times was the Payment of Minimum Amount paid or not paid?
Select Month, 
Count(Case when Payment_of_Min_Amount = "Yes" then 1 else null end) as Paid,
Count(Case when Payment_of_Min_Amount = "No" then 1 else null end) as Not_Paid
From train t
Group by Month
Order by Not_Paid desc;







