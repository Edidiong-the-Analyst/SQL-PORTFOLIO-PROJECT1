
Select *
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]

 -------------------------------------------------------------------------------------------------
 --Total Number of Subscribers for each Subject

 Select Distinct(Subject), Sum(Num_Subscribers) as TotalNum_Sub
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Subject 
 Order by 2 desc

 ---------------------------------------------------------------------------------------------------
 -- Top Subscribed Courses

 Select Course_ID, Course_Title, Num_Subscribers, Subject
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Order by 3 desc


  ---------------------------------------------------------------------------------------------------
 -- Subjects with Total Revenue Generated

 Select Distinct(Subject), Sum(Price) as TotalRevenue
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Subject 
 Order by 2 desc


 ---------------------------------------------------------------------------------------------------
 -- Subjects with Total Revenue Generated at different Levels

 Select Distinct(Subject), (Select Distinct(Level)) Level, Sum(Price) as TotalRevenue
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Subject,Level
 Order by 3 desc


  ---------------------------------------------------------------------------------------------------
 -- Num of Free and Paid Courses

 Select Course_Type, Count(Course_Type) TypeCount 
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Course_Type
 --Order by 2 desc


 ---------------------------------------------------------------------------------------------------
 -- AVG Rating for Subjects at different Levels

 Select Distinct(Subject), (Select Distinct(Level)) Level, Round(AVG(Rating),1) as AvgRating
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Subject,Level
 Order by 3 desc


  ---------------------------------------------------------------------------------------------------
 -- AVG Content Duration for Subjects

 Select Distinct(Subject), Round(AVG(Content_Duration),1) as AvgDuration
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Subject
 

 -------------------------------------------------------------------------------------------------
 --Convert Date
ALTER Table [ProjectPortfolio].[dbo].[UdemyCourses]
ADD Date_PublishedConverted Date 

Update UdemyCourses
SET Date_Published = Convert (Date, Date_Published)

Update UdemyCourses
SET Date_PublishedConverted = Convert (Date, Date_Published)

Select *
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]

 --Total Number of Subscribers vs Publication Date

 Select Distinct(Date_PublishedConverted), Sum(Num_Subscribers) as TotalNum_Sub
 FROM [ProjectPortfolio].[dbo].[UdemyCourses]
 Group by Date_PublishedConverted 
 Order by 2 desc

