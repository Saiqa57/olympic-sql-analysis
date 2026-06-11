-- EDA
SELECT * FROM saiqa.athlete_event;
USE saiqa;
-- Checking for Duplicate records
SELECT COUNT(*) AS totalrows,
COUNT(DISTINCT ID , NAME, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal)
AS unique_rows
FROM athlete_event;
-- Data quality check: Identifying Missing values (NULL)
SELECT EXISTS (SELECT 1 
FROM athlete_event
WHERE
ID IS NULL
OR NAME IS NULL
OR Sex IS NULL
OR Age IS NULL
OR Height IS NULL
OR Weight IS NULL 
OR Team IS NULL 
OR NOC IS NULL 
OR Games IS NULL 
OR Year IS NULL
OR Season IS NULL 
OR City IS NULL
OR Sport IS NULL 
OR Event IS NULL
OR Medal IS NULL) AS has_null;
-- Data quality check: Identifying Missing values (NA)
SELECT EXISTS (SELECT 1 
FROM athlete_event
WHERE
ID = 'NA'
OR NAME = 'NA'
OR Sex = 'NA'
OR Age = 'NA'
OR Height = 'NA'
OR Weight = 'NA' 
OR Team = 'NA' 
OR NOC = 'NA'
OR Games = 'NA'
OR Year = 'NA'
OR Season = 'NA'
OR City = 'NA'
OR Sport = 'NA'
OR Event = 'NA'
OR Medal = 'NA') AS na_count;
-- Column-wise count of Missing (NA) Values
SELECT
SUM(CASE WHEN ID = 'NA' THEN 1 END) AS na_id,
SUM(CASE WHEN Name = 'NA' THEN 1 END) na_name,
SUM(CASE WHEN Sex = 'NA' THEN 1 END) na_sex,
SUM(CASE WHEN Age = 'NA' THEN 1 END) na_Age,
SUM(CASE WHEN Height = 'NA' THEN 1 END) na_height,
SUM(CASE WHEN Weight = 'NA' THEN 1 END) na_weight,
SUM(CASE WHEN Team = 'NA' THEN 1 END)na_Team,
SUM(CASE WHEN NOC = 'NA' THEN 1 END) na_NOC,
SUM(CASE WHEN Games = 'NA' THEN 1 END) na_Games,
SUM(CASE WHEN Year = 'NA' THEN 1 END) na_year,
SUM(CASE WHEN Season = 'NA' THEN 1 END) na_season,
SUM(CASE WHEN City = 'NA' THEN 1 END) na_city,
SUM(CASE WHEN Sport = 'NA' THEN 1 END) na_sport,
SUM(CASE WHEN Event = 'NA' THEN 1 END) na_event,
SUM(CASE WHEN Medal = 'NA' THEN 1 END) na_Medal
FROM athlete_event;
-- Adding a PK
ALTER TABLE athlete_event
ADD COLUMN rid BIGINT AUTO_INCREMENT PRIMARY KEY;
-- Data cleaning: Deleting Duplicate records
WITH cte AS (
    SELECT rid,
    ROW_NUMBER()OVER(PARTITION BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal ORDER BY rid) AS C
	FROM athlete_event
  ) 
DELETE FROM athlete_event
WHERE rid IN (SELECT rid FROM cte WHERE C > 1);
-- Checking for Duplicate records after preprocessing
SELECT COUNT(*) AS totalrows,
COUNT(DISTINCT ID , NAME, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal)
AS unique_rows
FROM athlete_event;
-- Updating NA values to NULL
UPDATE athlete_event
SET Age = null
WHERE Age = 'NA';
UPDATE athlete_event
SET Height = null
WHERE Height = 'NA';
UPDATE athlete_event
SET Weight = null
WHERE Weight = 'NA';


SHOW PROCESSLIST;
KILL 5;



