--1. Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick Chicken Bites’.
create function stuffchicken(@prefix varchar(50),  @suffix varchar(50)) 
returns varchar(100)
AS
begin
      return @prefix+ ' Chicken '+ @suffix
end
 

select dbo.stuffchicken('Quick','Bites') as newname



--2. Use the function to display the restaurant name and cuisine type which has the maximum number of rating.
create function display_output()
returns table
AS 
  return 
  (select top 1 RestaurantName,CuisinesType 
  from jomato
  order by No_of_Rating)


select * from dbo.display_output()



/*
3. Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4
start rating, ‘Good’ if it has above 3.5 and below 5 star rating, ‘Average’ if it is above 3
and below 3.5 and ‘Bad’ if it is below 3 star rating.
*/
select *, 
case 
when Rating > 4 then 'Excellent'
when Rating > 3.5 and Rating <= 4 then 'Good'
when Rating > 3 and Rating <= 3.5 then 'Average'
else 'bad'
end  as Rating_Status
from jomato



--4. Find the Ceil, floor and absolute values of the rating column and display the current date and separately display the year, month_name and day.
select rating,
       ceiling(rating) as ratings_Ceil_values,
       floor(rating) as ratings_floor_values,
       abs(rating) as ratings_abs_values,

       convert(date, getdate()) as curr_Date ,
       year(getdate()) as year_val,
       datename(month, getdate()) as day_val,
       day(getdate()) as day_val
from jomato



--5. Display the restaurant type and total average cost using rollup.
select restaurantType, sum(averageCost) from jomato
group by rollup(restaurantType)


--6. Create a stored procedure to display the restaurant name, type and cuisine where the table booking is not zero.

create procedure detailsGreaterThanZero
AS
begin
select RestaurantName,RestaurantType,cuisinesType from jomato
where tableBooking > 0
end

Exec dbo.detailsGreaterThanZero



--7. Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result and rollback it.
begin transaction 
update jomato
set cuisinesType = 'Cafeteria'
where cuisinesType = 'Cafe'

select * from jomato
where cuisinesType = 'Cafeteria'

rollback



--8. Generate a row number column and find the top 5 areas with the highest rating of restaurants.
select top 5  Area, rating
from (select Area,rating,row_number()over(order by rating desc) as RowNum from jomato) as jom
order by RowNum



--9. Use the while loop to display the 1 to 50.
declare @Startnum int = 1

while (@Startnum <= 50)
begin
print(@Startnum)

set @Startnum = @Startnum+1
end



--10. Write a query to Create a Top rating view to store the generated top 5 highest rating of restaurants.
create view TopRatingView as
select top 5 * from jomato
order by rating desc

select * from TopRatingView 


--11. Create a trigger that give an message whenever a new record is inserted.
create trigger insertMessage
on jomato
After insert
as
begin
print 'A new record has been inserted successfully!';
end

insert into jomato 
values
(3749,'Wosti','chinese',4.5,156,200,1,1,'chinese food','Mankhurd','near mankhurd east railway Station',54)


--12. Top 10 most popular cuisines
SELECT TOP 10 CuisinesType, COUNT(*) AS TotalRestaurants
FROM jomato
GROUP BY CuisinesType
ORDER BY TotalRestaurants DESC;


--13. Area with highest average restaurant rating
SELECT Area, AVG(Rating) AS AvgRating
FROM jomato
GROUP BY Area
ORDER BY AvgRating DESC;


--14. Count of restaurants offering online delivery
SELECT COUNT(*) AS DeliveryRestaurants
FROM jomato
WHERE onlineDelivery = 1;


--15. Average cost comparison: online vs dine-in
SELECT 
    CASE WHEN onlineDelivery = 1 THEN 'Online Delivery' ELSE 'No Online Delivery' END AS ServiceType,
    AVG(averageCost) AS AvgCost
FROM jomato
GROUP BY onlineDelivery;


--15. Rating distribution
SELECT 
    FLOOR(Rating) AS RatingRange,
    COUNT(*) AS RestaurantCount
FROM jomato
GROUP BY FLOOR(Rating)
ORDER BY RatingRange DESC;


--16. Top 5 expensive restaurants
SELECT TOP 5 RestaurantName, averageCost, Area
FROM jomato
ORDER BY averageCost DESC;


--17. Which restaurants give the best value for money based on rating per cost?
SELECT TOP 10 RestaurantName, Rating, averageCost,
       ROUND(Rating / NULLIF(averageCost,0), 3) AS ValueForMoneyScore
FROM jomato
ORDER BY ValueForMoneyScore DESC;



--18. Which cuisines are the most popular considering both rating & number of ratings?
SELECT CuisinesType,
       ROUND(AVG(Rating),2) AS AvgRating,
       SUM(No_of_Rating) AS TotalRatings,
       ROUND(AVG(Rating) * SUM(No_of_Rating),2) AS PopularityScore
FROM jomato
GROUP BY CuisinesType
ORDER BY PopularityScore DESC;



--19. Top 5 areas with the highest concentration of highly rated restaurants
SELECT TOP 5 Area, COUNT(*) AS HighRatedRestaurants
FROM jomato
WHERE Rating >= 4.0
GROUP BY Area
ORDER BY HighRatedRestaurants DESC;



--20. Which restaurant type has the highest table bookings compared to total restaurants?
SELECT RestaurantType,
       COUNT(*) AS TotalRestaurants,
       SUM(CASE WHEN TableBooking > 0 THEN 1 ELSE 0 END) AS RestaurantsWithBooking,
       ROUND(100.0 * SUM(CASE WHEN TableBooking > 0 THEN 1 ELSE 0 END) / COUNT(*),2) AS BookingAvailabilityPercentage
FROM jomato
GROUP BY RestaurantType
ORDER BY BookingAvailabilityPercentage DESC;



--21. Identify potential “hidden gems” (low cost, high rating, low popularity)
SELECT TOP 10 RestaurantName, Rating, No_of_Rating, AverageCost
FROM jomato
WHERE Rating >= 4 AND No_of_Rating < 200 AND AverageCost < 300
ORDER BY Rating DESC, AverageCost ASC;



--22. Find the most expensive cuisines and compare with their rating score
SELECT CuisinesType,
       AVG(AverageCost) AS AvgCost,
       AVG(Rating) AS AvgRating
FROM jomato
GROUP BY CuisinesType
ORDER BY AvgCost DESC;



--23. Rank restaurants within each area by popularity score
SELECT Area, RestaurantName, Rating, No_of_Rating,
       DENSE_RANK() OVER(PARTITION BY Area ORDER BY Rating*No_of_Rating DESC) AS PopularityRank
FROM jomato;



--24. Which restaurants have consistently above-average ratings compared to their area?
SELECT j.RestaurantName, j.Area, j.Rating
FROM jomato j
JOIN (
    SELECT Area, AVG(Rating) AS AvgAreaRating
    FROM jomato
    GROUP BY Area
) A ON j.Area = A.Area
WHERE j.Rating > A.AvgAreaRating
ORDER BY Rating DESC;



--25. Highest cost restaurants that still maintain excellent ratings
SELECT TOP 10 RestaurantName, Rating, AverageCost
FROM jomato
WHERE Rating >= 4
ORDER BY AverageCost DESC;



--26. Restaurant category where users are willing to pay the most per rating unit
SELECT RestaurantType,
       ROUND(AVG(AverageCost)/NULLIF(AVG(Rating),0),2) AS CostPerRatingUnit
FROM jomato
GROUP BY RestaurantType
ORDER BY CostPerRatingUnit DESC;