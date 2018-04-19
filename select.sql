SELECT release_year, title FROM films;
SELECT count(*) FROM films;

SELECT count(distinct budget) FROM films
Where budget > 100000;

SELECT AVG(budget)
FROM films;
SELECT MAX(budget)
FROM films;
SELECT SUM(budget)
FROM films;
SELECT MAX(budget) AS max_budget,
       MAX(duration) AS max_duration
FROM films;

SELECT title, (gross - budget) AS net_profit 
FROM films;

SELECT title, (duration / 60.0) AS duration_hours
FROM films; 

SELECT AVG(duration / 60.0) AS avg_duration_hours
FROM films;

SELECT name
FROM people
ORDER BY name DESC;

SELECT birthdate, name
FROM people
ORDER BY birthdate, name;

-- group 一般用在aggregate function中
SELECT sex, count(*)
FROM employees
GROUP BY sex
ORDER BY count DESC;

-- having 条件语句
SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;

-- group by 在where 之后
select  release_year, avg(budget) as avg_budget, avg(gross) as avg_gross
from films
where release_year > 1990
group by release_year

-- having 在group by 之后
select  release_year, avg(budget) as avg_budget, avg(gross) as avg_gross
from films
where release_year > 1990
group by release_year
having avg(budget) > 60000000

--Get the country, average budget, and average gross take of countries that have made more than 10 films. Order the result by country name, and limit the number of results displayed to 5. You should alias the averages as avg_budget and avg_gross respectively.
-- select country, average budget, average gross
select country, avg(budget) as avg_budget, avg(gross) as avg_gross
-- from the films table
from films
-- group by country 
group by country
-- where the country has a title count greater than 10
having count(country) > 10
-- order by country
order by country
-- limit to only show 5 results
limit 5

-- 多张表的合并搜索
SELECT title, imdb_score
FROM films
JOIN reviews
ON films.id = reviews.film_id
WHERE title = 'To Kill a Mockingbird';