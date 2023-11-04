
--ANALYSIS OF CYCLYSTIC BIKE-SHARE DATA FOR FEB2022
Select *
From bike_share_database.dbo.[202202-pt1]
Union
Select *
From bike_share_database.dbo.[202202-pt2]
Union
Select *
From bike_share_database.dbo.[202202-pt3]
Union
Select *
From bike_share_database.dbo.[202202-pt4]

Drop Table if exists bikesharefeb
Create Table bikesharefeb
     (
      ride_id nvarchar (255)
      ,rideable_type nvarchar (255)
      ,started_at datetime
      ,ended_at  datetime
      ,start_station_name nvarchar (255)
      ,end_station_name nvarchar (255)
      ,member_casual nvarchar (255)
      ,ride_length float 
      ,day_of_week float
	  )

 Insert Into bikesharefeb
 Select  *
From bike_share_database.dbo.[202202-pt1]
Union
Select *
From bike_share_database.dbo.[202202-pt2]
Union
Select *
From bike_share_database.dbo.[202202-pt3]
Union
Select *
From bike_share_database.dbo.[202202-pt4]
	  
-- EDA On bikesharefeb 

Select *
From bikesharefeb
--- Total unique Users
Select Count(distinct ride_id) As 'Total_users'
From bikesharefeb
---Total casuals
Select Count(member_casual) As 'Total_casuals'
From bikesharefeb
Where member_casual ='casual'
---Total members
Select Count(member_casual) As 'Total_members'
From bikesharefeb
Where member_casual ='member'

--Determination of Considerable Users
Select *,
CONVERT(VARCHAR, DATEADD(SECOND, ROUND(CONVERT(FLOAT,ride_length * 3600), 0), '19000101'), 108)
	AS 'ride_time'
from bikesharefeb
order by 'ride_time' desc

CREATE VIEW UserS_ridetime2 AS
SELECT
ride_id,rideable_type,
started_at,ended_at,
member_casual,ride_length,
day_of_week,start_station_name, end_station_name,
CONVERT(VARCHAR, DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101'), 108) AS 'ride_time'
FROM bikesharefeb
WHERE DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101') >= '19000101 00:01:00';

SELECT Count(Distinct ride_id) As 'Total_Considered_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

SELECT Count(Distinct ride_id) As 'Total_Considered casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
AND member_casual ='casual'

SELECT Count(Distinct ride_id) As 'Total_Considered members'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
AND member_casual ='member'

--Average ride time for different categories
 
 ---Average ride time for all users
 
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

---Average ride time for casuals users
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'

---Average ride time for subscribed members

 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'

---weekends averge ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)

---weekdays average ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)

---minimum ride time
Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime2]

---Maximum ride time
Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime2]

Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'casual'

Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'member'

Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'casual'

Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
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
('feb'),

(Select Count(ride_id) As 'Total_users'
From bikesharefeb),

(SELECT Count(ride_id) As 'Considered_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),


(Select Count(member_casual) As 'Total_casuals'
 From bikesharefeb
 where member_casual = 'casual'),
 

 (Select Count (member_casual) As 'Total_considered_casuals'
 From [bike_share_database].[dbo].[UserS_ridetime2]
 where member_casual = 'casual'),
 
 (Select Count(member_casual) As 'Total_members'
 From bikesharefeb
 where member_casual = 'member'),
 
 (Select Count (member_casual) As 'Total_considered_members'
 From [bike_share_database].[dbo].[UserS_ridetime2]
 where member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime2]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)),

(Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime2]),

(Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime2]),

(Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'casual'),

(Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'casual'),

(Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'member'),

(Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime2]
Where member_casual = 'member')
)

 Select *
From [bike_share_database].[dbo].[Bkjan20222_Summary]

--This summary statistics report provides a clear overview of the analysis 
--conducted on the cyclystic bike-share company Feb2022 data Using Microsoft SQL Server, 
--highlighting the total number of users, average ride times for different categories,
--and significant ride time statistics.