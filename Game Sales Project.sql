--Top 10 best selling games each year of this century and final query for visualization
SELECT *
FROM 
(
	SELECT
		Year_of_Release,
		Name,
		Platform,
		Genre,
		developer_new,
		Global_Sales,
		NA_Sales,
		EU_Sales,
		JP_Sales,
		Other_Sales,
		Critic_Score,
		User_Score,
		Rank () Over(Partition by Year_of_Release Order by Global_Sales DESC) as salesrank
	FROM
		PortfolioProject.dbo.Games
		) as tbl
WHERE (Year_of_Release BETWEEN 2000 and 2016) and salesrank <= 10
Order by
	Year_of_Release,
	salesrank


--Below are queries that were used to explore the data and gather insights before developing the final above query for visualization
-----------------------------------
--Data exploration

Select 
	developer_new
From
	PortfolioProject.dbo.Games

---Needed to populate null values in Developer column, replaced with Publisher when null
ALTER TABLE Games
ADD developer_new Nvarchar(255)

Update Games
Set
	developer_new = isnull(Developer,Publisher)

--------------------------------------------------------------------------------------------------

--Global Sales by Developer-----------------------------------------------------------------------
Select
	developer_new,
	Count(developer_new) as games_made,
	Sum(Global_Sales) as global_sales,
	Sum(Global_Sales)/Count(developer_new) as avg_per_game
From
	PortfolioProject.dbo.Games
Where
	Year_of_Release between 2000 and 20016
Group by
	developer_new
Order by
	3 DESC

--NA Sales by Developer-----------------------------------------------------------------------------
Select
	developer_new,
	Count(developer_new) as games_made,
	Sum(NA_Sales) as na_sales,
	Sum(NA_Sales)/Count(developer_new) as avg_per_game
From
	PortfolioProject.dbo.Games
Where
	Year_of_Release between 2000 and 20016
Group by
	developer_new
Order by
	3 DESC

--European Sales by Developer----------------------------------------------------------------------
Select
	developer_new,
	Count(developer_new) as games_made,
	Sum(EU_Sales) as eu_sales,
	Sum(EU_Sales)/Count(developer_new) as avg_per_game
From
	PortfolioProject.dbo.Games
Where
	Year_of_Release between 2000 and 20016
Group by
	developer_new
Order by
	3 DESC

--Japan Sales by Developer------------------------------------------------------------------------

Select
	developer_new,
	Count(developer_new) as games_made,
	Sum(JP_Sales) as jp_sales,
	Sum(JP_Sales)/Count(developer_new) as avg_per_game
From
	PortfolioProject.dbo.Games
Where
	Year_of_Release between 2000 and 20016
Group by
	developer_new
Order by
	3 DESC

--Other sales by developer-----------------------------------------------------------------------
Select
	developer_new,
	Count(developer_new) as games_made,
	Sum(Other_Sales) as other_sales,
	Sum(Other_Sales)/Count(developer_new) as avg_per_game
From
	PortfolioProject.dbo.Games
Where
	Year_of_Release between 2000 and 20016
Group by
	developer_new
Order by
	3 DESC

--With the Success of the Wii, Nintendo dominated their competition since Wii Sports came packaged with every console leading to that game's high sales numbers

--Interesting note that Good Science Studio (Kinect games) had highest avg in EU and NA but not in JP since it's sales are connected to 360 sales and Microsoft does not sell well in the Japanese market

--Number of games made by genre this century
Select
	Year_of_Release,
	Genre,
	Count(Genre) as games_made,
	Sum(Global_Sales) as genre_sales
From
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release Between 2000 AND 2016
Group by
	Year_of_Release,
	Genre
Order by
	1


--Best selling Genre of each year this century
Select
	top (1) with ties
	Year_of_Release,
	Genre,
	Count(Genre) as games_made,
	Sum(Global_Sales) as genre_sales
From
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release Between 2000 AND 2016
Group by
	Year_of_Release,
	Genre
Order by
	Row_Number() Over (
	Partition by Year_of_Release
	Order by Max(Global_Sales) DESC)

--Best selling game globally by year this century
Select
	top (1) with ties
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Max(Global_Sales) as total_sales,
	Critic_Score,
	User_Score
FROM
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release between 2000 and 2016
Group by
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Critic_Score,
	User_Score
Order by
	Row_Number () over (
	Partition by Year_of_Release
	Order by max(Global_Sales) DESC)

--Best selling NA game by year this century

Select
	top (1) with ties
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Max(NA_Sales) as total_sales,
	Critic_Score,
	User_Score
FROM
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release between 2000 and 2016
Group by
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Critic_Score,
	User_Score
Order by
	Row_Number () over (
	Partition by Year_of_Release
	Order by max(NA_Sales) DESC)

--Best selling EU game by year this century

Select
	top (1) with ties
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Max(EU_Sales) as total_sales,
	Critic_Score,
	User_Score
FROM
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release between 2000 and 2016
Group by
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Critic_Score,
	User_Score
Order by
	Row_Number () over (
	Partition by Year_of_Release
	Order by max(EU_Sales) DESC)

--Best selling JP game by year this century

Select
	top (1) with ties
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Max(JP_Sales) as total_sales,
	Critic_Score,
	User_Score
FROM
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release between 2000 and 2016
Group by
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Critic_Score,
	User_Score
Order by
	Row_Number () over (
	Partition by Year_of_Release
	Order by max(JP_Sales) DESC)

--Best selling Other game by year this century

Select
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Max(Other_Sales) as total_sales,
	Critic_Score,
	User_Score
FROM
	PortfolioProject.dbo.Games
WHERE
	Year_of_Release between 2000 and 2016
Group by
	Year_of_Release,
	Name,
	developer_new,
	Platform,
	Genre,
	Critic_Score,
	User_Score
Order by
	Row_Number () over (
	Partition by Year_of_Release
	Order by max(Other_Sales) DESC)
