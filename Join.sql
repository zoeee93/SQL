-- 1/ INNER JOIN

SELECT cities.name AS city, countries.name AS country, region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

-- table的化名
SELECT c1.name AS city, c2.name AS country
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code;

SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
Inner JOIN Economies as e
ON c.code = e.code;

-- 3张table 用化名， 且注意匹配（年份和code同时匹配）
select c.code, name, region, e.year, fertility_rate,unemployment_rate
from countries as c
inner join populations as p
on c.code = p.country_code
inner join economies as e
on c.code= e.code and p.year = e.year

-- 当 on 后面的列表名是一样时，用using
SELECT c.name AS country, continent, l.name AS language, official
FROM countries AS c
inner JOIN languages AS l
using (code);

-- Join a table to itself? 记得用化名  on 语句中加 and 可排除一些情况
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015,
       ((p2.size - p1.size) / p1.size * 100.0) AS growth_perc
FROM populations AS p1
inner JOIN populations AS p2
ON p1.country_code = p2.country_code and p1.year = p2.year - 5

/* case when and then
Using the countries table, create a new field AS geosize_group that groups the countries into three groups:
If surface_area is greater than 2 million, geosize_group is 'large'.
If surface_area is greater than 350 thousand but not larger than 2 million, geosize_group is 'medium'.
Otherwise, geosize_group is 'small'.
get name, continent, code, and surface area */

select name, continent, code, surface_area,
    -- first case
    case when surface_area > 2000000
    -- first then
            then 'large'
    -- second case
       when surface_area > 350000
    -- second then
            then 'medium'
    -- else clause + end
       else 'small' end
    -- alias resulting field of CASE WHEN
       as geosize_group
-- create new table to save the result
INTO countries_plus      
-- from the countries table
from countries;

/* Using the populations table focused only on 2015, create a new field AS popsize_group to organize population size into
'large' (> 50 million),
'medium' (> 1 million), and
'small' groups.
Select only the country code, population size, and this new popsize_group as fields. */ 

SELECT country_code,size,
  -- start CASE here with WHEN and THEN
     case when size > 50000000
          then 'large'
  -- layout other CASE conditions here
     when size > 1000000
          then 'medium'
  -- end CASE here with ELSE & END
     else 'small' end
  -- provide the alias of popsize_group to SELECT the new field
     as popsize_group
-- which table?
from populations
-- any conditions to check?
where year = 2015;

/* Use INTO to save the result of the previous query as pop_plus. You can see an example of this in the countries_plus code in the assignment text. Make sure to include a ; at the end of your WHERE clause!
Then, include another query below your first query to display all the records in pop_plus using SELECT * FROM pop_plus; so that you generate results and this will display pop_plus in query result. */
SELECT country_code,size,
  -- start CASE here with WHEN and THEN
     case when size > 50000000
          then 'large'
  -- layout other CASE conditions here
     when size > 1000000
          then 'medium'
  -- end CASE here with ELSE & END
     else 'small' end
  -- provide the alias of popsize_group to SELECT the new field
     as popsize_group

INTO pop_plus
-- which table?
from populations
-- any conditions to check?
where year = 2015;

Select * from pop_plus


/* Keep the first query intact that creates pop_plus using INTO.
Remove the SELECT * FROM pop_plus; code and instead write a second query to join countries_plus AS c on the left with pop_plus AS p on the right matching on the country code fields.
Select country name, continent, the surface area grouping (NOT surface_area), and the population grouping fields. (Four fields total.)
Sort the data based on geosize_group, in ascending order so that large appears on top. */

SELECT country_code,size,
  -- start CASE here with WHEN and THEN
     case when size > 50000000
          then 'large'
  -- layout other CASE conditions here
     when size > 1000000
          then 'medium'
  -- end CASE here with ELSE & END
     else 'small' end
  -- provide the alias of popsize_group to SELECT the new field
     as popsize_group

INTO pop_plus
-- which table?
from populations
-- any conditions to check?  注意句尾的分号哦，因为重新有了下面的select语句
where year = 2015;

Select name, continent, geosize_group, popsize_group
from countries_plus as c
inner join pop_plus as p
on c.code = p.country_code
order by geosize_group;



-- 2/ OUTER JOIN


--LEFT and RIGHT JOINs


-- Modify your code to calculate the average GDP per capita AS avg_gdp for each region in 2010. Select the region and avg_gdp fields.-- select name, region, and gdp_percapita
select region, avg(gdp_percapita) as avg_gdp
-- countries (alias c) on the left
from countries AS c
-- join with economies (alias e)
left JOIN economies AS e
-- match on code fields
on c.code = e.code
-- focus on 2010 entries
where year = 2010
-- group by each region
group by region
--Arrange this data on average GDP per capita for each region in 2010 from highest to lowest average GDP per capita.
order by avg_gdp desc


