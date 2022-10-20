-- We going to examine Kyler Murray's career stats using dataset imported from Pro Football Website. 

Use Nfl_Kyler;

-- Renaming Table 
Alter table nfl_kyler_clean
Rename to Kyler;

-- Renaming Column 
Alter table Kyler
Rename column `Cmp%` to Cmp_percentage;

-- What are Kyler Murray's top three highest career yards and which team were they against?
SELECT 
    Opp, MAX(Yds) AS most_yds
FROM
    Kyler
GROUP BY Opp
ORDER BY most_yds DESC
LIMIT 3;

-- What is Kyler's overall average rating, attempts and yards thrown?
Select round(avg(Rate),2) as Avg_Rating, Round(Avg(Att),0) as Avg_attemts,round(avg(yds),2) as Avg_Yards
From Kyler;

-- Against which opponent does Kyler average the most pass attemts aginst?
Select Opp, Round(Avg(Att),0) as Avg_attempts, Round(Avg(Yds),2) Avg_Yards, Round(Avg(Rate),2) as Avg_rating, Count(Opp) as Games_played
From Kyler
Group by Opp
Order by Avg_attempts desc, Avg_Yards desc;

/* Kyler threw the ball 49 times against the Las Vegas Raiders but only threw for 277 yards, which is why his rating was only 76.7.
This is lower than his average Rating which is 94.13. This could be due to him attempting to throw the ball more than usual but not throwing for as much yards.*/

-- How many differnt teams has Kyler played against in his career?
Select Count(Distinct(Opp))
From Kyler;

-- Ans: 29 teams, which mean he hasn't played aginst 3 other teams including his own team, since there are 32 teams in the league.

-- What was his second highest Completion percentage?
SELECT 
    MAX(Cmp_percentage)
FROM
    Kyler
WHERE
    NOT Cmp_percentage = (SELECT 
            MAX(Cmp_percentage)
        FROM
            Kyler);

-- What is Kyler's average TD to Int ratio against each team he played against?
SELECT 
    Opp,
    ROUND(AVG(Td), 2) AS Avg_Td,
    ROUND(AVG(`Int`), 2) AS Avg_Int
FROM
    Kyler
GROUP BY Opp
ORDER BY Avg_Td DESC , Avg_Int ASC;

-- Does Kyler Pass attempts always result in more yards thrown and Touchdowns?
SELECT 
    Opp, Att, Yds, TD, `Int`
FROM
    Kyler
ORDER BY Att DESC;

-- Ans: No, he does not always throw for more yards and touchdown when he throws more.

-- WHich are the top 3 teams that Kyler has played the most game against?
SELECT 
    Opp, COUNT(Opp) AS total_games
FROM
    Kyler
GROUP BY Opp
ORDER BY total_games DESC
LIMIT 3;

-- The three teams he played against the most are LAR, SEA and SFO. This makes sense as they are in his divison and he plays them twice per year.

-- What is Kyler's average touchdown against each of the division games and how do they compare to all his games played against them.
Select Opp, Date, Year, location, Result, TD,(Round(avg(TD) over (partition by Opp),2))
From Kyler
Where Opp in ("LAR", "SEA","SFO")
Order by Opp DESC, TD Desc; 

-- He averages the most touchdown againt SFO.



-- Cleaning data to use it for further exploration use. 

-- Using Temp table to split and replace columns 
Drop table if exists Results_split;
Create Temporary table Results_split
as (
Select MyUnknownColumn,
SUBSTRING_INDEX(Result, ' ', 1) as result, 
SUBSTRING_INDEX(Result, ' ', -1) as score
From Kyler);

Alter table Kyler
Add column Results char(1);

Alter table Kyler
Add column score Varchar(100);

-- Updating the Results column
Update Kyler k
set k.Results = (Select r.result From Results_split r where k.MyUnknownColumn = R.MyUnknownColumn);

-- Updating the score column
Update Kyler k
set k.score = (Select r.score From Results_split r where k.MyUnknownColumn = R.MyUnknownColumn); 

-- Dropping the Result Field.
Alter table Kyler 
Drop column Result;

-- Spliting the column into score by each team
Drop table if exists score_by;
Create Temporary table score_by
as (
Select MyUnknownColumn,
SUBSTRING_INDEX(score, '-', 1) as ARI_Score, 
SUBSTRING_INDEX(score, '-', -1) as OPP_Score
From Kyler);

Select *
From score_by;
 
-- Adding columns 
Alter table Kyler
Add column ARI_score int,
Add column Opp_score int;

-- Updating the columns using the temp table 
Update Kyler k
Set k.ARI_score = (select s.ARI_Score From score_by s where k.MyUnknownColumn = s.MyUnknownColumn);

Update Kyler k
Set k.Opp_score = (select s.OPP_Score From score_by s where k.MyUnknownColumn = s.MyUnknownColumn);

-- Droping the table 
Alter table Kyler 
drop score;


-- What is the average score that Kyler's team scored, and the average score his team allowed?
Select round(Avg(ARI_score),2) as avg_Kyler_team, round(Avg(Opp_score),2) as Avg_Opp_score
From Kyler;

-- Ans: Kyler's teams averages 24.42 points per game while his oppenents averages a close 24.10 points.

-- How many games has Kyler played?
Select Count(Results) as total_games
From Kyler;

-- Kyler has played a total of 52 games in his career thus far.

-- How many times has Kyler tied, won and lost?
Select Results, Count(Results)
From Kyler
Group by Results;

-- Kyler has tied once in his career, lost 27 games and won 24 games. 

-- Divisional games are the most important in Nfl because of the rivialary between the teams and the impact it has on each teams playoff standing.
-- What is Kyler's record against divisional teams.
Select Results, Count(Results)
From Kyler
Where Opp in ("LAR", "SEA","SFO")
Group by Results;

-- Kyler has a horrible record against divisional team with a record of 5 wins and 13 losses.

-- What is Kyler stats against divisional teams?
Create temporary table Divisional_games 
(Select *
From Kyler
Where Opp in ("LAR", "SEA","SFO"));

Select *
From Divisional_games;

-- What is his team's average score during each results?
Select Results, Round(Avg(ARI_score),2) as avg_score
From Kyler
Group by Results;

-- Ans: During tie games Arizona averages a score of 27 points, during loss they averages only 18.63 points, and during wins they average 30.83 points.

-- Does Kyler win more at home or away games?
Select Location, Count(Results) total_wins
From Kyler
Where Results = "W"
Group by Location;

-- Kyler suprising wins more game away than he does at home. With 15 away wins and 9 home wins.

-- Does Kyler lose more at home or away games?
Select Location, Count(Results) total_lose
From Kyler
Where Results = "L"
Group by Location;

-- Kyler loses more at home with total loses of 16 games and total loses of 11 games at away games.

-- Total throwing touchdown by Nfl weeks.
Select Week,Sum(TD) as total_td
From Kyler 
group by week 
Order by total_td desc;

-- We can see that Kyler best games are usually early to mid-season, then his total tds tend to drop of as season goes by.
-- Select Everything
Select * 
From Kyler;


-- Conclussion 
/* Overall, all though Kyler Murray is thought to be a very good as a former number 1 overall pick in the Nfl draft, he has not had the best early 
career. One of the biggest critic of his coming out of college was that he was too small and couldn't handle the long Nfl season.
This has been proven right thus far as he usally falls off as the season goes by all though he starts the season off great.
We have to conside the injuries to his Offensive linemans and his receiver, which also drastically impacts his overall stats. */
