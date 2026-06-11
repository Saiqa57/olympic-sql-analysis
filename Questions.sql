
-- Questions
-- Q1. How many Olympics games have been held.
SELECT COUNT(DISTINCT Games) AS total_games
FROM athlete_event;
-- Q2. List down all Olympics Games held so far.
SELECT DISTINCT Games
FROM athlete_event;
-- Q3. Mention the total number of nations that participated in each olympic games.
SELECT Games, COUNT(DISTINCT region) AS Total_participated_nations
FROM athlete_event a
JOIN noc_regions b
ON a.NOC = b.NOC
GROUP BY Games
ORDER BY Games;
-- Q4. which year saw the highest and lowest number of countries participating in the olympics
(SELECT Year, COUNT(DISTINCT region) AS cnt
FROM athlete_event a
JOIN noc_regions b
ON a.noc = b.noc
GROUP BY Year
ORDER BY cnt
LIMIT 1)
UNION 
(SELECT Year, COUNT(DISTINCT region) AS cnt
FROM athlete_event a
JOIN noc_regions b
ON a.noc = b.noc
GROUP BY Year
ORDER BY cnt DESC
LIMIT 1);
-- Using window-function
WITH cte AS (SELECT Year,
COUNT(DISTINCT region) AS cnt,
RANK()OVER(ORDER BY COUNT(DISTINCT region) DESC) AS participated_desc_rnk, 
RANK()OVER(ORDER BY COUNT(DISTINCT region) ASC) AS participated_asc_rnk
FROM athlete_event a
JOIN noc_regions b
ON a.noc = b.noc
GROUP BY Year)
SELECT Year, cnt
FROM cte 
WHERE participated_desc_rnk=1
OR participated_asc_rnk=1 ;
-- Q5. Which nation has participated in all of the Olympic Games.
SELECT region, COUNT(DISTINCT Games)  FROM noc_regions a
JOIN athlete_event b
ON a.noc = b.noc
GROUP BY region
HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM athlete_event);
-- Q6. Identify the sports played in all Summer olympics.
SELECT * FROM athlete_event;
SELECT sport
FROM athlete_event
WHERE Season = 'Summer'
GROUP BY sport
HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM athlete_event
                                 WHERE Season = 'Summer'
                                 );
-- Q7. Which sports were played only once in the olympics.
SELECT sport
FROM athlete_event
GROUP BY sport
HAVING COUNT(DISTINCT Games) = 1;
-- Q8. Fetch the total number of sports played in each olympic game.
SELECT Games, COUNT(DISTINCT Sport) as number_of_sports
FROM athlete_event
GROUP BY Games;
-- Q9. Fetch details of the oldest athletes to win the Gold medal
-- using where clause
SELECT * FROM athlete_event
WHERE Medal = 'Gold'
ORDER BY Age DESC
LIMIT 1;
-- using subquery
SELECT * FROM athlete_event
WHERE Medal = 'Gold'
AND Age = (SELECT MAX(Age) FROM athlete_event WHERE Medal = 'Gold');
-- Using window function
WITH cte AS (SELECT *,
RANK()OVER(ORDER BY Age DESC) AS rnk
FROM athlete_event
WHERE Medal = 'Gold')
SELECT *
FROM cte
WHERE rnk=1;
-- Q10. Find the ratio of Male and Female athletes participation in olympic Games.
SELECT Games,
COALESCE(CONCAT('1 : ',
ROUND(COUNT(DISTINCT CASE WHEN Sex = 'M' THEN Name END)/
COUNT(DISTINCT CASE WHEN Sex = 'F' THEN Name END),0)), '1 : 0')AS female_male_ratio
FROM athlete_event
GROUP BY Games;
-- Q11. Fetch the top 5 athletes who won the most Gold Medals
WITH CTE AS (SELECT ID, Name, row_number()OVER(PARTITION BY ID) AS rnk
FROM athlete_event
WHERE Medal ='Gold')
SELECT Name, MAX(rnk)
FROM CTE 
GROUP BY Name
ORDER BY MAX(rnk) DESC
LIMIT 5;
-- Q12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
SELECT Name, COUNT(Medal) AS medal_cnt FROM athlete_event
WHERE Medal in ('Gold', 'Silver', 'Bronze')
GROUP BY Name
ORDER BY medal_cnt DESC
LIMIT 5;
-- Q13. Fetch the top 5 most successful countries in the Olympics based on the number of medals won.
SELECT region, count(Medal) AS medal_cnts FROM athlete_event tb1
JOIN noc_regions tb2
ON tb1.NOC = tb2.NOC
WHERE Medal in ('Gold', 'Silver', 'Bronze')
GROUP BY region
ORDER BY medal_cnts DESC
LIMIT 5;
-- Q14. List down total Gold, Silver and Bronze medals won by each country.
SELECT region, sum(Medal = 'Gold') as gold_med, 
sum(Medal = 'Silver') as silver_med, sum(Medal = 'Bronze') as Bronze_med, 
COUNT(Medal) as total_med FROM athlete_event tb1
JOIN noc_regions tb2
ON tb1.NOC = tb2.NOC
WHERE Medal in ('Gold', 'Silver', 'Bronze')
GROUP BY region
ORDER BY total_med DESC;
-- Q15. In which Sport/event did India win the highest number of medals?
SELECT Sport, COUNT(DISTINCT CONCAT(Games, Event, Medal)) AS medal_cnt 
FROM saiqa.athlete_event as t1
JOIN noc_regions as t2
ON t1.NOC =  t2.NOC
WHERE team = 'INDIA'
AND Medal <> 'NA'
GROUP BY Sport
ORDER BY medal_cnt DESC
LIMIT 1;
