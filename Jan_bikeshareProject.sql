
--ANALYSIS OF CYCLYSTIC BIKE-SHARE DATA FOR JAN2022

Select *
From bike_share_database..[202201-Pt1]
Select*
From bike_share_database..[202201-pt2]
Select * 
From bike_share_database..[202201-Pt3]

--Create a comprehensive table

Drop Table if exists bikesharejan
Create Table bikesharejan
(
ride_id nvarchar(255),rideable_type nvarchar(255), Started_at nvarchar(255), ended_at nvarchar(255),
member_casual nvarchar(255),ride_length float, ride_length_datetime datetime,day_of_week float
)

--Insert into the table

Insert INTO bikesharejan
SELECT ride_id,rideable_type,started_at,ended_at,member_casual,ride_length,
   Column1 as ride_lenght_datetime,day_of_week
  FROM [bike_share_database].[dbo].[202201-Pt1]
  Union
  Select ride_id,rideable_type,started_at,ended_at,member_casual,ride_length,Column1,day_of_week
  From [bike_share_database].[dbo].[202201-Pt2]
 Union
 Select ride_id,rideable_type,started_at,ended_at,member_casual,ride_length,Column1,day_of_week
  From [bike_share_database].[dbo].[202201-Pt3]

--Explore the table

 Select Count(member_casual) As 'Total_casuals'
 From bikesharejan
 where member_casual = 'casual'

 --Convert the time column to HH:MM:SS
 
 SELECT ride_id,rideable_type,started_at,ended_at,member_casual,ride_length,
 ride_length_datetime,day_of_week,
    CONVERT(VARCHAR, DATEADD(SECOND, ROUND(CONVERT(FLOAT,ride_length * 3600), 0), '19000101'), 108)
	AS 'ride_time'
from bikesharejan
order by 'ride_time' desc

--EDA Part 1

---Determine total number of users

Select Count(ride_id) As 'Total_number_of_Users'
From bikesharejan

---Determine the number of considerable users

SELECT Count(Distinct ride_id) As 'Considerable_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

---Create A View
--CREATE VIEW UserS_ridetime AS
--SELECT DISTINCT
--ride_id,rideable_type,
--started_at,ended_at,
--member_casual,ride_length,
--ride_length_datetime,day_of_week,
--CONVERT(VARCHAR, DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101'), 108) AS 'ride_time'
--FROM bikesharejan
--WHERE DATEADD(SECOND, ROUND(CONVERT(FLOAT, ride_length * 3600), 0), '19000101') >= '19000101 00:01:00';

--EDA Part 2 using [bike_share_database.dbo.UserS_ridetime]

Select * 
From [bike_share_database].[dbo].[UserS_ridetime]

---No of casuals
 Select Count (ride_id) As 'No_of_casuals'
 From [bike_share_database].[dbo].[UserS_ridetime]
 where member_casual = 'casual'
 
 ---No of members
 
 Select Count (ride_id) As 'No_of_members'
 From [bike_share_database].[dbo].[UserS_ridetime]
 where member_casual = 'member'

 --Average ride time for different categories
 
 ---Average ride time for all users
 
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'

---Average ride time for casuals users
 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'

---Average ride time for subscribed members

 SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'

---weekends averge ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)

---weekdays average ride time

SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)

---minimum ride time
Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime]

---Maximum ride time
Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime]

Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'casual'

Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'member'

Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'casual'

Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'member'

--Summary Statistics Table
Drop Table If EXISTS Bkjan20222_Summary
Create Table Bkjan20222_Summary
(
Month nvarchar(255), 
Total_users numeric,Total_considered_users numeric,
Total_casuals numeric, Total_considered_casuals numeric, 
Total_members numeric, Total_considered_members numeric,
Average_ride_time varchar(30),Average_ride_time_members varchar(30),
Average_ride_time_casuals varchar(30),
Weekdays_average_ride_time varchar(30), Weekends_average_ride_time varchar(30),
Minimum_ride_time varchar(30), Maximum_ride_time varchar(30), 
Minimum_ride_time_casuals varchar(30),Maximum_ride_time_casuals varchar(30),
Minimum_ride_time_members varchar(30),Maximum_ride_time_members varchar(30)
)

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
('Jan'),

(Select Count(ride_id) As 'Total_users'
From bikesharejan),

(SELECT Count(ride_id) As 'Considered_Users'
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),


(Select Count(member_casual) As 'Total_casuals'
 From bikesharejan
 where member_casual = 'casual'),
 

 (Select Count (member_casual) As 'Total_considered_casuals'
 From [bike_share_database].[dbo].[UserS_ridetime]
 where member_casual = 'casual'),
 
 (Select Count(member_casual) As 'Total_members'
 From bikesharejan
 where member_casual = 'member'),
 
 (Select Count (member_casual) As 'Total_considered_members'
 From [bike_share_database].[dbo].[UserS_ridetime]
 where member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_members
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'member'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_of_casuals
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And member_casual = 'casual'),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekdays
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week NOT In (7,1)),

(SELECT 
    CAST(
        DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', ride_time)), '00:00:00') 
    AS TIME) AS Avg_ride_Time_on_weekends
FROM [bike_share_database].[dbo].[UserS_ridetime]
WHERE CAST(ride_time AS TIME) >= '00:01:00'
And day_of_week In (7,1)),

(Select Min(ride_time) As 'Minimum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime]),

(Select MAX(ride_time) As 'Maximum_ride_time'
FROM [bike_share_database].[dbo].[UserS_ridetime]),

(Select Min(ride_time) As 'Minimum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'casual'),

(Select Max(ride_time) As 'Maximum_ride_time_for_casuals'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'casual'),

(Select Min(ride_time) As 'Minimum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'member'),

(Select Max(ride_time) As 'Maximum_ride_time_for_members'
FROM [bike_share_database].[dbo].[UserS_ridetime]
Where member_casual = 'member')
)
 Select *
From [bike_share_database].[dbo].[Bkjan20222_Summary]

--This summary statistics report provides a clear overview of the analysis 
--conducted on the cyclystic bike-share company Jan2022 data Using Microsoft SQL Server, 
--highlighting the total number of users, average ride times for different categories,
--and significant ride time statistics.