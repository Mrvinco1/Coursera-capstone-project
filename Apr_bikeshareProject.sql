
--ANALYSIS OF CYCLYSTIC BIKE-SHARE DATA FOR APR2022

SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt1]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt2]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt3]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt4]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt5]

  Drop Table if exists bikeshareapr
  Create Table bikeshareapr
     (
      ride_id nvarchar (255)
      ,rideable_type nvarchar (255)
      ,started_at datetime
      ,ended_at  datetime
      ,member_casual nvarchar (255)
      ,ride_length float 
      ,day_of_week float
	  )

  Insert Into bikeshareapr
  SELECT
  [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt1]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt2]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt3]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt4]
  Union
  SELECT [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [bike_share_database].[dbo].[202204-pt5]
  
-- EDA On bikeshareapr 

Select *
From bikeshareapr
--- Total unique Users
Select Count(distinct ride_id) As 'Total_users'
From bikeshareapr
---Total casuals
Select Count(member_casual) As 'Total_casuals'
From bikeshareapr
Where member_casual ='casual'
---Total members
Select Count(member_casual) As 'Total_members'
From bikeshareapr
Where member_casual ='member'

--Determination of Considerable Users

CREATE VIEW UserS_ridetime4
AS
SELECT
ride_id,rideable_type,
started_at,ended_at,
member_casual,ride_length,
day_of_week,
CONVERT(VARCHAR, DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101'), 108) AS 'ride_time'
FROM bikeshareapr
WHERE DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101') >= '19000101 00:01:00';

---Total considered users

SELECT Count(Distinct ride_id) As 'Total_Considered_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

---Total considered casuals

SELECT Count(Distinct ride_id) As 'Total_Considered casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
AND member_casual ='casual'

---Total considered members

SELECT Count(Distinct ride_id) As 'Total_Considered members'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
AND member_casual ='member'

--Average ride time for different categories
 
---Average ride time for all users
 
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

---Average ride time for casuals
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'

---Average ride time for  members

 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'

---weekends averge ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)

---weekdays average ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)

---minimum ride time
Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime4]

---Maximum ride time
Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime4]

Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'casual'

Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'member'

Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'casual'

Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'member'

--Summary Statistics Table

Insert into [bike_share_database].[dbo].[Bkjan20222_Summary]
(Month,
Total_users,Total_considered_users,
Total_casuals,Total_considered_casuals,
Total_members,Total_considered_members,
Average_ride_time,Average_ride_time_members,
Average_ride_time_casuals,Weekdays_average_ride_time,
Weekends_average_ride_time,Minimum_ride_time,
Maximum_ride_time,Minimum_ride_time_casuals,
Maximum_ride_time_casuals,Minimum_ride_time_members,
Maximum_ride_time_members)Values
(
('apr'),

(Select Count(ride_id) As 'Total_users'
From bikeshareapr),

(SELECT Count(ride_id) As 'Considered_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),


(Select Count(member_casual) As 'Total_casuals'
 From bikeshareapr
 where member_casual = 'casual'),
 

 (Select Count (member_casual) As 'Total_considered_casuals'
 From [bike_share_database].[dbo].[UserS_ridetime4]
 where member_casual = 'casual'),
 
 (Select Count(member_casual) As 'Total_members'
 From bikeshareapr
 where member_casual = 'member'),
 
 (Select Count (member_casual) As 'Total_considered_members'
 From [bike_share_database].[dbo].[UserS_ridetime4]
 where member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime4]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)),

(Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime4]),

(Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime4]),

(Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'casual'),

(Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'casual'),

(Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'member'),

(Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime4]
Where member_casual = 'member')
)

Select *
From [bike_share_database].[dbo].[Bkjan20222_Summary]

--This summary statistics report provides a clear overview of the analysis 
--conducted on the cyclystic bike-share company Apr2022 data Using Microsoft SQL Server, 
--highlighting the total number of users, average ride times for different categories,
--and significant ride time statistics.