
175. Combine two tables
Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.

Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table.

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
FirstName, LastName, City, State

solution:
drop table if exists person;
drop table if exists address;
create table Person (PersonId int AUTO_INCREMENT PRIMARY KEY, FirstName varchar(255), LastName varchar(255))
Create table Address (AddressId int AUTO_INCREMENT PRIMARY KEY, PersonId int, City varchar(255), State varchar(255));

select p.FirstName, p.LastName, a.City, a.State 
from Person as p 
left join Address as a 
on p.PersonId = a.PersonId


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



176. Write a SQL query to get the second highest salary from the Employee table.
 
Limit 的用法：

SELECT 
    select_list
FROM
    table_name
LIMIT [offset,] row_count;

-- The offset specifies the offset of the first row to return. The offset of the first row is 0, not 1.
-- The row_count specifies the maximum number of rows to return.

solution:

drop table if exists employee;
Create table Employee (Id int, Salary int);
Truncate table Employee;
insert into Employee (Id, Salary) values ('1', '100');
insert into Employee (Id, Salary) values ('2', '200');
insert into Employee (Id, Salary) values ('3', '300');


# select max(Salary) as SecondHighestSalary  from Employee where Salary not in (select max(salary) from employee);

or:

# select Salary as SecondHighestSalary from Employee GROUP BY Salary ORDER BY Salary desc LIMIT 1,1 

However, this solution will be judged as 'Wrong Answer' if there is no such second highest salary since there might be only one record in this table. To overcome this issue, we can take this as a temp table.

MySQL

SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary
;

SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


177. Nth Highest Salary
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+

这里用function了！！！
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT; # 不要忘记;
SET M = N - 1; # 不要忘记;
  RETURN (
      # Write your MySQL query statement below.
      select distinct salary from employee order by salary desc limit M, 1
  );
END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



603. Consecutive Available Seats
Several friends at a cinema ticket office would like to reserve consecutive available seats.
Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?

seat_id	free
1	1
2	0
3	1
4	1
5	1
Your query should return the following result for the sample case above.

seat_id
3
4
5
Note:
The seat_id is an auto increment int, and free is bool (‘1’ means free, and ‘0’ means occupied.).
Consecutive available seats are more than 2(inclusive) seats consecutively available.

Create table If Not Exists cinema (seat_id int primary key auto_increment, free bool);
Truncate table cinema;
insert into cinema (seat_id, free) values ('1', '1');
insert into cinema (seat_id, free) values ('2', '0');
insert into cinema (seat_id, free) values ('3', '1');
insert into cinema (seat_id, free) values ('4', '1');
insert into cinema (seat_id, free) values ('5', '1');


要用abs(c1.id - c2.id ) =1
SELECT DISTINCT(a.seat_id) FROM cinema a INNER JOIN cinema b ON abs(a.seat_id - b.seat_id) = 1 WHERE a.free = 1 and b.free = 1 ORDER BY a.seat_id
 
 解释：
 select * from cinema a INNER JOIN cinema b ON abs(a.seat_id - b.seat_id) = 1;
+---------+------+---------+------+
| seat_id | free | seat_id | free |
+---------+------+---------+------+
|       2 |    0 |       1 |    1 |
|       1 |    1 |       2 |    0 |
|       3 |    1 |       2 |    0 |
|       2 |    0 |       3 |    1 |
|       4 |    1 |       3 |    1 |
|       3 |    1 |       4 |    1 |
|       5 |    1 |       4 |    1 |
|       4 |    1 |       5 |    1 |
+---------+------+---------+------+


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


180. Consecutive Numbers
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+

create table If Not Exists Logs (Id int, Num int);
Truncate table Logs;
insert into Logs (Id, Num) values ('1', '1');
insert into Logs (Id, Num) values ('2', '1');
insert into Logs (Id, Num) values ('3', '1');
insert into Logs (Id, Num) values ('4', '2');
insert into Logs (Id, Num) values ('5', '1');
insert into Logs (Id, Num) values ('6', '2');
insert into Logs (Id, Num) values ('7', '2');

不会


select distinct a.num as ConsecutiveNums
from logs a
where
a.num = (select b.num from logs b where b.id > a.id order by b.id limit 0,1) and
a.num = (select c.num from logs c where c.id > a.id order by c.id limit 1,1);

or:
容易理解：

select distinct a.num as ConsecutiveNums
from logs a, logs b, logs c
where
a.id = b.id -1 and b.id = c.id -1
and a.num = b.num and b.num = c.num


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


184. Department Highest Salary
The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+

drop table if exists employee;
drop table if exists department;
Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, DepartmentId int);
Create table If Not Exists Department (Id int, Name varchar(255));
Truncate table Employee;
insert into Employee (Id, Name, Salary, DepartmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('4', 'Max', '90000', '1');
Truncate table Department;
insert into Department (Id, Name) values ('1', 'IT');
insert into Department (Id, Name) values ('2', 'Sales');



select d.Name as Department, e.Name as Employee, e.Salary
from Department d, Employee e
where (e.DepartmentId, e.salary) in (select DepartmentId, max(Salary) as max from Employee group by DepartmentId )
and d.id = e.DepartmentId;


注意这里使用：WHERE
    (Employee.DepartmentId , Salary) IN

    组合了（E.id，salary）如果只用salary in 的话，可能会出现A部门最高800，还有500， B部门最高500，然后把A部门的800，500，B部门的500 都选出来。

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

185. Department top 3 salaries
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+

drop table if exists employee;
drop table if exists department;
Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, DepartmentId int);
Create table If Not Exists Department (Id int, Name varchar(255));
Truncate table Employee;
insert into Employee (Id, Name, Salary, DepartmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('4', 'Max', '90000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('6', 'Randy', '85000', '1');
Truncate table Department;
insert into Department (Id, Name) values ('1', 'IT');
insert into Department (Id, Name) values ('2', 'Sales');


根据sql 50 第18题

个人觉得刷SQL题，能不用函数就不要用函数，基本的语法明明能做的。对于这种分组内取前几名的问题，可以先group by然后用having count()来筛选，
比如这题，找每个部门的工资前三名，那么先在子查询中用Employee和自己做连接，连接条件是【部门相同但是工资比我高】，那么接下来按照having count(distinct Salary) <= 2来筛选的原理是：
如果【跟我一个部门而且工资比我高的人数】不超过2个，那么我一定是部门工资前三，这样内层查询可以查询出所有符合要求的员工ID，接下来外层查询就简单了。 distinct 是因为如果部门里有几个工资一样的且都属于前三，那么都要包括

select d.name as Department, e.name as Employee, e.salary 
from Employee e
join Department d
on e.DepartmentId = d.id
where e.id in 
(
    select e1.id
    from Employee e1
    left join Employee e2
    on e1.DepartmentId = e2.DepartmentId
    and e1.salary < e2.salary
    group by e1.id
    having count(distinct e2.Salary) <= 2
)

或者

select d.Name as Department, e.Name as Employee, e.Salary
from Department d, Employee e
where d.id = e.DepartmentId
and (select count(distinct e2.salary) from Employee e2 where e.DepartmentId =e2.DepartmentId and e.Salary < e2.Salary) <3 # 查询出大于e.salary的salary记录条数（需要对salary去重），如果这个条数小于3，那么e.salary肯定是前三内的
order by Department, e.Salary desc


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

595. Big Countries
There is a table World

+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries’ name, population and area.

For example, according to the above table, we should output:

+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+

drop table if exists world;
Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp bigint);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');


select name,population,area from World
where area > 3000000 or population > 25000000;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
196. Delete duplicate emails
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+

drop table if exists person;
create table person (id int, email text);
truncate table person;
insert into person values(1, 'john@example.com');
insert into person values(2, 'bob@example.com');
insert into person values(3, 'john@example.com');


delete的用法：
There are two ways to delete rows in a table using information contained in other tables in the database: 
1.using sub-selects
2.or specifying additional tables in the USING clause. Which technique is more appropriate depends on the specific circumstances.

delete from person using person, person b where person.email = b.email and person.id > b.id;
select * from person;


or:

我们可以使用以下代码，将此表与它自身在电子邮箱列中连接起来。
SELECT p1.* FROM Person p1,Person p2 WHERE  p1.Email = p2.Email
复制代码然后我们需要找到其他记录中具有相同电子邮件地址的更大 ID。所以我们可以像这样给 WHERE 子句添加一个新的条件。
SELECT p1.* FROM Person p1,Person p2 WHERE  p1.Email = p2.Email AND p1.Id > p2.Id
复制代码因为我们已经得到了要删除的记录，所以我们最终可以将该语句更改为 DELETE。
DELETE p1 FROM Person p1, Person p2  WHERE   p1.Email = p2.Email AND p1.Id > p2.Id



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

626. Exchange Seats
Mary is a teacher in a middle school and she has a table seat storing students’ names and their corresponding seat ids.

The column id is continuous increment.
Mary wants to change seats for the adjacent students.
Can you write a SQL query to output the result for Mary?

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+

Note:
If the number of students is odd, there is no need to change the last one’s seat.


drop table if exists seat;
Create table If Not Exists seat(id int, student varchar(255));
Truncate table seat;
insert into seat (id, student) values ('1', 'Abbot');
insert into seat (id, student) values ('2', 'Doris');
insert into seat (id, student) values ('3', 'Emerson');
insert into seat (id, student) values ('4', 'Green');
insert into seat (id, student) values ('5', 'Jeames');



select 
case
when s1.id = (select max(s2.id) from seat s2) and s1.id % 2 <> 0
then s1.id
when s1.id % 2 = 0
then s1.id -1
when s1.id % 2 > 0 
then s1.id + 1
end as id,student
from seat s1
order by id



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
569. Median Empployee Salary
The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

Id	Company	Salary
1	A	2341
2	A	341
3	A	15
4	A	15314
5	A	451
6	A	513
7	B	15
8	B	13
9	B	1154
10	B	1345
11	B	1221
12	B	234
13	C	2345
14	C	2645
15	C	2645
16	C	2652
17	C	65
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

Id	Company	Salary
5	A	451
6	A	513
12	B	234
9	B	1154
14	C	2645


drop table if exists employee;
Create table If Not Exists Employee (Id int, Company varchar(255), Salary int);
Truncate table Employee;
insert into Employee (Id, Company, Salary) values ('1', 'A', '2341');
insert into Employee (Id, Company, Salary) values ('2', 'A', '341');
insert into Employee (Id, Company, Salary) values ('3', 'A', '15');
insert into Employee (Id, Company, Salary) values ('4', 'A', '15314');
insert into Employee (Id, Company, Salary) values ('5', 'A', '451');
insert into Employee (Id, Company, Salary) values ('6', 'A', '513');
insert into Employee (Id, Company, Salary) values ('7', 'B', '15');
insert into Employee (Id, Company, Salary) values ('8', 'B', '13');
insert into Employee (Id, Company, Salary) values ('9', 'B', '1154');
insert into Employee (Id, Company, Salary) values ('10', 'B', '1345');
insert into Employee (Id, Company, Salary) values ('11', 'B', '1221');
insert into Employee (Id, Company, Salary) values ('12', 'B', '234');
insert into Employee (Id, Company, Salary) values ('13', 'C', '2345');
insert into Employee (Id, Company, Salary) values ('14', 'C', '2645');
insert into Employee (Id, Company, Salary) values ('15', 'C', '2645');
insert into Employee (Id, Company, Salary) values ('16', 'C', '2652');
insert into Employee (Id, Company, Salary) values ('17', 'C', '65');


不会
# 不会
-- 方法一： 利用 中位数 的定义
-- 思路:

-- 对于一个 奇数 长度数组中的 中位数，大于这个数的数值个数等于小于这个数的数值个数。

-- 算法

-- 根据上述的定义，我们来找一下 [1, 3, 2] 中的中位数。首先 1 不是中位数，因为这个数组有三个元素，却有两个元素 (3，2) 大于 1。3 也不是中位数，因为有两个元素小于 3。对于最后一个 2 来说，大于 2 和 小于 2 的元素数量是相等的，因此 2 是当前数组的中位数。

-- 当数组长度为 偶数，且元素唯一时，中位数等于排序后 中间两个数 的平均值。对这两个数来说，大于当前数的数值个数跟小于当前数的数值个数绝对值之差为 1，恰好等于这个数出现的频率。

-- 总的来说，不管是数组长度是奇是偶，也不管元素是不是唯一，中位数出现的频率一定>= 大于它的数的频率和小于它的数的频率的差的绝对值。这个规律是这道题的关键，可以通过下面这个搜索条件来过滤。

-- MySQL
-- SUM(CASE
--     WHEN Employee.Salary = alias.Salary THEN 1
--     ELSE 0
-- END) >= ABS(SUM(SIGN(Employee.Salary - alias.Salary)))
-- 根据上述的搜索条件，可以轻松写出下面的 MySQL 代码。

SELECT t1.Id, t1.Company, t1.Salary
FROM Employee t1
	LEFT JOIN Employee t2 ON t1.Company = t2.Company
GROUP BY t1.Company, t1.Salary
HAVING SUM(CASE 
	WHEN t1.Salary = t2.Salary THEN 1
	ELSE 0
END) >= abs(SUM(sign(t1.Salary - t2.Salary)))
ORDER BY t1.Id;


-- 方法二：
-- abs(rn - (cnt+1)/2) < 1

-- 解释下上面的公式:

-- rn是给定长度为cnt的数列的序号排序，

-- eg:对于1,2,3,4,5,它的中位数所在序号是3,3-(5+1)/2 = 0

-- 对于1,2,3,4，它的中位数所在序号是2,3

-- 2 - (4+1)/2 = -0.5

-- 3-(4+1)/2 = 0.5

-- 可见(cnt+1)/2是一个数列的中间位置,如果是奇数数列，这个位置刚好是中位数所在

-- 如果是偶数,abs(rn - (cnt+1)/2) < 1

select
	id, company, salary
from
	(select
		id, company, salary,
		row_number() over (partition by company order by salary) as rn, -- 各薪水记录在其公司内的顺序编号
		count(1) over (partition by company) as cnt -- 各公司的薪水记录数
	from employee
	) t
where abs(rn - (cnt+1)/2) < 1 -- 顺序编号在公司薪水记录数中间的，即为中位数


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

615. Average Salary: Departments vs. Company
Given two tables as below, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the company’s average salary.
Table: salary

id	employee_id	amount	pay_date
1	1	9000	2017-03-31
2	2	6000	2017-03-31
3	3	10000	2017-03-31
4	1	7000	2017-02-28
5	2	6000	2017-02-28
6	3	8000	2017-02-28
The employee_id column refers to the employee_id in the following table employee.

employee_id	department_id
1	1
2	2
3	2
So for the sample data above, the result is:

pay_month	department_id	comparison
2017-03	1	higher
2017-03	2	lower
2017-02	1	same
2017-02	2	same
Explanation

In March, the company’s average salary is (9000+6000+10000)/3 = 8333.33…

The average salary for department ‘1’ is 9000, which is the salary of employee_id ‘1’ since there is only one employee in this department. So the comparison result is ‘higher’ since 9000 > 8333.33 obviously.

The average salary of department ‘2’ is (6000 + 10000)/2 = 8000, which is the average of employee_id ‘2’ and ‘3’. So the comparison result is ‘lower’ since 8000 < 8333.33.

With he same formula for the average salary comparison in February, the result is ‘same’ since both the department ‘1’ and ‘2’ have the same average salary with the company, which is 7000.


drop table if exists salary;
drop table if exists employee;
Create table If Not Exists salary (id int, employee_id int, amount int, pay_date date);
Create table If Not Exists employee (employee_id int, department_id int);
Truncate table salary;
insert into salary (id, employee_id, amount, pay_date) values ('1', '1', '9000', '2017/03/31');
insert into salary (id, employee_id, amount, pay_date) values ('2', '2', '6000', '2017/03/31');
insert into salary (id, employee_id, amount, pay_date) values ('3', '3', '10000', '2017/03/31');
insert into salary (id, employee_id, amount, pay_date) values ('4', '1', '7000', '2017/02/28');
insert into salary (id, employee_id, amount, pay_date) values ('5', '2', '6000', '2017/02/28');
insert into salary (id, employee_id, amount, pay_date) values ('6', '3', '8000', '2017/02/28');
Truncate table employee;
insert into employee (employee_id, department_id) values ('1', '1');
insert into employee (employee_id, department_id) values ('2', '2');
insert into employee (employee_id, department_id) values ('3', '2');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
570. Managers with at least 5 direct reports
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+
Note:
No one would report to himself.


drop table if exists employee;
Create table If Not Exists Employee (Id int, Name varchar(255), Department varchar(255), ManagerId int);
Truncate table Employee;
insert into Employee (Id, Name, Department, ManagerId) values ('101', 'John', 'A', null);
insert into Employee (Id, Name, Department, ManagerId) values ('102', 'Dan', 'A', '101');
insert into Employee (Id, Name, Department, ManagerId) values ('103', 'James', 'A', '101');
insert into Employee (Id, Name, Department, ManagerId) values ('104', 'Amy', 'A', '101');
insert into Employee (Id, Name, Department, ManagerId) values ('105', 'Anne', 'A', '101');
insert into Employee (Id, Name, Department, ManagerId) values ('106', 'Ron', 'B', '101');

select e1.name 
from employee e1, employee e2
where e1.id = e2.managerid
group by e1.id
having count(*) >=5

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

597. Friend Requests I: Overall Acceptance Rate
In social network like Facebook or Twitter, people send friend requests and accept others’ requests as well. Now given two tables as below:

Table: friend_request

sender_id	send_to_id	request_date
1	2	2016_06-01
1	3	2016_06-01
1	4	2016_06-01
2	3	2016_06-02
3	4	2016-06-09
Table: request_accepted

requester_id	accepter_id	accept_date
1	2	2016_06-03
1	3	2016-06-08
2	3	2016-06-08
3	4	2016-06-09
3	4	2016-06-10
Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divide the number of requests.
For the sample data above, your query should return the following result.

accept_rate
0.80
Note:
* The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
* It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
* If there is no requests at all, you should return 0.00 as the accept_rate.

Explanation: There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.

Follow-up:
* Can you write a query to return the accept rate but for every month?
* How about the cumulative accept rate for every day?



drop table if exists friend_request;
drop table if exists request_accepted;
Create table If Not Exists friend_request ( sender_id INT NOT NULL, send_to_id INT NULL, request_date DATE NULL);
Create table If Not Exists request_accepted ( requester_id INT NOT NULL, accepter_id INT NULL, accept_date DATE NULL);
Truncate table friend_request;
insert into friend_request (sender_id, send_to_id, request_date) values ('1', '2', '2016/06/01');
insert into friend_request (sender_id, send_to_id, request_date) values ('1', '3', '2016/06/01');
insert into friend_request (sender_id, send_to_id, request_date) values ('1', '4', '2016/06/01');
insert into friend_request (sender_id, send_to_id, request_date) values ('2', '3', '2016/06/02');
insert into friend_request (sender_id, send_to_id, request_date) values ('3', '4', '2016/06/09');
Truncate table request_accepted;
insert into request_accepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/10');

错误：
select count(distinct requester_id, accepter_id) from request_accepted / count(distinct sender_id, send_to_id) from friend_request;
正确：

# If there is no requests at all, you should return 0.00 as the accept_rate. --- 用 ifnull
# distinct 后面不接括号，直接distinct a,b

select ifnull(Round(count(distinct requester_id, accepter_id)/ count(distinct sender_id, send_to_id),2),0) as  accept_rate from  request_accepted, friend_request
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

574. Winning Candidate
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+
Notes:
You may assume there is no tie, in other words there will be at most one winning candidate.

drop table if exists candidate;
drop table if exists vote;
Create table If Not Exists Candidate (id int, Name varchar(255));
Create table If Not Exists Vote (id int, CandidateId int);
Truncate table Candidate;
insert into Candidate (id, Name) values ('1', 'A');
insert into Candidate (id, Name) values ('2', 'B');
insert into Candidate (id, Name) values ('3', 'C');
insert into Candidate (id, Name) values ('4', 'D');
insert into Candidate (id, Name) values ('5', 'E');
Truncate table Vote;
insert into Vote (id, CandidateId) values ('1', '2');
insert into Vote (id, CandidateId) values ('2', '4');
insert into Vote (id, CandidateId) values ('3', '3');
insert into Vote (id, CandidateId) values ('4', '2');
insert into Vote (id, CandidateId) values ('5', '5');


select name 
from candidate c
left join vote v
on v.CandidateId = c.id
group by v.CandidateId
order by count(v.id) desc
limit 1

或者
select name 
from candidate c
where c.id in (select v.CandidateId 
from vote v 
group by v.CandidateId 
having count(v.id) >= all(select count(id) from vote group by CandidateId))



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

178. Rank Scores
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no “holes” between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+

drop table if exists scores;
Create table If Not Exists Scores (Id int, Score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (Id, Score) values ('1', '3.5');
insert into Scores (Id, Score) values ('2', '3.65');
insert into Scores (Id, Score) values ('3', '4.0');
insert into Scores (Id, Score) values ('4', '3.85');
insert into Scores (Id, Score) values ('5', '4.0');
insert into Scores (Id, Score) values ('6', '3.65');


Algorithm
To determine the ranking of a score, count the number of distinct scores that are >= to that score

MySQL Solution
SELECT
    S1.Score,
    (SELECT COUNT(DISTINCT Score) FROM Scores AS S2 WHERE S2.Score >= S1.Score) AS Rank
FROM Scores AS S1
ORDER BY Score DESC


或者

select s1.Score,count(distinct(s2.score)) AS 'Rank'
from
Scores s1,Scores s2
where
s1.score<=s2.score
group by s1.Id
order by s1.Score DESC

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
181. Employees earning more than their managers
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+

select E.name as Employee from Employee E
join Employee F
on E.ManagerId = F.Id
where E.Salary > F.Salary


或者
SELECT
    *
FROM
    Employee AS a,
    Employee AS b # Select from two tables will get the Cartesian product of these two tables. In this case, the output will be 4*4 = 16 records. 
WHERE
    a.ManagerId = b.Id
        AND a.Salary > b.Salary
;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
182. Duplicate Emails
Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+

select distinct P1.Email from Person as P1
join Person as P2
on P1.Email = P2.Email and P1.Id <> P2.Id

注意要用distinct 不然就会出现两个一样的值


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
197. Rising temperature
Given a Weather table, write a SQL query to find all dates’ Ids with higher temperature compared to its previous (yesterday’s) dates.

+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
For example, return the following Ids for the above Weather table:

+----+
| Id |
+----+
|  2 |
|  4 |
+----+

use leetcode;
drop table if exists weather;
Create table If Not Exists Weather (Id int, RecordDate date, Temperature int);
Truncate table Weather;
insert into Weather (Id, RecordDate, Temperature) values ('1', '2015-01-01', '10');
insert into Weather (Id, RecordDate, Temperature) values ('2', '2015-01-02', '25');
insert into Weather (Id, RecordDate, Temperature) values ('3', '2015-01-03', '20');
insert into Weather (Id, RecordDate, Temperature) values ('4', '2015-01-04', '30');

# 要用datediff
select w1.Id from Weather w1
join Weather w2
on w1.Temperature > w2.Temperature
and DATEDIFF(w1.RecordDate,w2.RecordDate) =1 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


. Swap Salary
Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.

For example:

id	name	sex	salary
1	A	m	2500
2	B	f	1500
3	C	m	5500
4	D	f	500
After running your query, the above salary table should have the following rows:

id	name	sex	salary
1	A	f	2500
2	B	m	1500
3	C	f	5500
4	D	m	500

use leetcode;
drop table if exists salary;
create table if not exists salary(id int, name varchar(100), sex char(1), salary int);
Truncate table salary;
insert into salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into salary (id, name, sex, salary) values ('4', 'D', 'f', '500');


update 的用法

IF 表达式
IF( expr1 , expr2 , expr3 )
expr1 的值为 TRUE，则返回值为 expr2 
expr1 的值为FALSE，则返回值为 expr3


update salary
	set sex = if (sex = "m", 'f',"m");



case用法： case a when cond1 then exp1 else cond2 then exp2 else exp3
当a满足条件cond1时， 返回exp1 当a满足条件cond2时， 返回exp2 否则 返回exp3

UPDATE salary 

SET 
   sex = CASE sex 
        WHEN "m" THEN "f" 
        ELSE "m" 
    END;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1179. Reformat Department Table
Table: Department

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| revenue       | int     |
| month         | varchar |
+---------------+---------+
(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].
 

Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.

The query result format is in the following example:

Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+

Result table:
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+

Note that the result table has 13 columns (1 for the department id + 12 for the months).


不会

select id,
    sum(case month when 'jan' then revenue else null end) as Jan_Revenue,
    sum(case when month = 'feb' then revenue else null end) as Feb_Revenue,
	sum(case when month = 'mar' then revenue else null end) as Mar_Revenue,
	sum(case when month = 'apr' then revenue else null end) as Apr_Revenue,
	sum(case when month = 'may' then revenue else null end) as May_Revenue,
	sum(case when month = 'jun' then revenue else null end) as Jun_Revenue,
	sum(case when month = 'jul' then revenue else null end) as Jul_Revenue,
	sum(case when month = 'aug' then revenue else null end) as Aug_Revenue,
	sum(case when month = 'sep' then revenue else null end) as Sep_Revenue,
	sum(case when month = 'oct' then revenue else null end) as Oct_Revenue,
	sum(case when month = 'nov' then revenue else null end) as Nov_Revenue,
	sum(case when month = 'dec' then revenue else null end) as Dec_Revenue
from department
group by id
order by id

或者
SELECT 
    id, 
    sum( if( month = 'Jan', revenue, null ) ) AS Jan_Revenue,
    sum( if( month = 'Feb', revenue, null ) ) AS Feb_Revenue,
    sum( if( month = 'Mar', revenue, null ) ) AS Mar_Revenue,
    sum( if( month = 'Apr', revenue, null ) ) AS Apr_Revenue,
    sum( if( month = 'May', revenue, null ) ) AS May_Revenue,
    sum( if( month = 'Jun', revenue, null ) ) AS Jun_Revenue,
    sum( if( month = 'Jul', revenue, null ) ) AS Jul_Revenue,
    sum( if( month = 'Aug', revenue, null ) ) AS Aug_Revenue,
    sum( if( month = 'Sep', revenue, null ) ) AS Sep_Revenue,
    sum( if( month = 'Oct', revenue, null ) ) AS Oct_Revenue,
    sum( if( month = 'Nov', revenue, null ) ) AS Nov_Revenue,
    sum( if( month = 'Dec', revenue, null ) ) AS Dec_Revenue
FROM 
    Department
GROUP BY 
    id;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
601. Human Traffic Of Stadium
X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:

id  date  people
1 2017-01-01  10
2 2017-01-02  109
3 2017-01-03  150
4 2017-01-04  99
5 2017-01-05  145
6 2017-01-06  1455
7 2017-01-07  199
8 2017-01-08  188
For the sample data above, the output is:

id  date  people
5 2017-01-05  145
6 2017-01-06  1455
7 2017-01-07  199
8 2017-01-08  188
Note:
Each day only have one row record, and the dates are increasing with id increasing.------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 建议时常思考复习
# Considering t1, t2 and t3 are identical, we can take one of them to consider what conditions we should add to filter the data and get the final result. Taking t1 for example, it could exist in the beginning of the consecutive 3 days, or the middle, or the last.

t1 in the beginning: (t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1) -- t1, t2, t3
t1 in the middle: (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
t1 in the end: (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1

select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
      (t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
order by t1.id
;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
262. Trips and Users

The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.

For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+
Credits:
Special thanks to @cak1erlizhou for contributing this question, writing the problem description and adding part of the test cases.



# Write your MySQL query statement below
# Cancellation Rate 因为中间有空格，所以要加‘Cancellation Rate’，查错查了半天
select tmp.Request_at as Day,
round(sum(tmp.status!='completed')/count(tmp.status), 2) as 'Cancellation Rate'
from (
select *
from trips
where client_id in (select users_id from users where banned ='No')
and driver_id in (select users_id from users where banned ='No')) tmp
where tmp.Request_at between "2013-10-01" and "2013-10-03" 
group by tmp.Request_at
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
182. Duplicate Emails
SQL架构
Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
Note: All emails are in lowercase.


# Write your MySQL query statement below
select email
from person
group by email
having count(*)>1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
183. Customers Who Never Order
Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+


# Write your MySQL query statement below
select name as customers
from customers
where id not in (select customerid from orders)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
511. Game Play Analysis I
SQL架构
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports the first login date for each player.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+


select player_id, min(event_date) as first_login
from Activity
group by player_id


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
512. Game Play Analysis II
SQL架构
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write a SQL query that reports the device that is first logged in for each player.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+-----------+
| player_id | device_id |
+-----------+-----------+
| 1         | 2         |
| 2         | 3         |
| 3         | 1         |
+-----------+-----------+


select player_id, device_id
from Activity
where (player_id,event_date) in (select player_id, min(event_date) from Activity group by player_id)

# where event_date in (select min(event_date) from Activity group by player_id)会报错
# 因为这样会造成有些event_date和player_id不对应
# 可能有不同的player_id 都存在同一个event_date


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

577. Employee Bonus

Select all employee‘s name and bonus whose bonus is < 1000.

Table:Employee

+-------+--------+-----------+--------+
| empId |  name  | supervisor| salary |
+-------+--------+-----------+--------+
|   1   | John   |  3        | 1000   |
|   2   | Dan    |  3        | 2000   |
|   3   | Brad   |  null     | 4000   |
|   4   | Thomas |  3        | 4000   |
+-------+--------+-----------+--------+
empId is the primary key column for this table.
Table: Bonus

+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
empId is the primary key column for this table.
Example ouput:

+-------+-------+
| name  | bonus |
+-------+-------+
| John  | null  |
| Dan   | 500   |
| Brad  | null  |
+-------+-------+

需要熟悉 is null 用法
Brad 和 John 的 bonus 值为空，在数据库中会被记为 NULL。从概念上来说，NULL 意味着 “一个缺失的未知的值” 。除此以外，我们使用 IS NULL 和 IS NOT NULL 来将一个值与 NULL 做比较

select e.name, b.bonus from employee e
left join bonus b
on e.empid = b.empid
where bonus < 1000 or bonus is null



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
584

Given a table customer holding customers information and the referee.

+------+------+-----------+
| id   | name | referee_id|
+------+------+-----------+
|    1 | Will |      NULL |
|    2 | Jane |      NULL |
|    3 | Alex |         2 |
|    4 | Bill |      NULL |
|    5 | Zack |         1 |
|    6 | Mark |         2 |
+------+------+-----------+
Write a query to return the list of customers NOT referred by the person with id '2'.

For the sample data above, the result is:

+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+

需要熟悉 is null 用法

select name 
from customer
where referee_id <> 2 or referee_id is null

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
586. Customer Placing the Largest Number of Orders

Query the customer_number from the orders table for the customer who has placed the largest number of orders.

It is guaranteed that exactly one customer will have placed more orders than any other customer.

The orders table is defined as follows:

| Column            | Type      |
|-------------------|-----------|
| order_number (PK) | int       |
| customer_number   | int       |
| order_date        | date      |
| required_date     | date      |
| shipped_date      | date      |
| status            | char(15)  |
| comment           | char(200) |
Sample Input

| order_number | customer_number | order_date | required_date | shipped_date | status | comment |
|--------------|-----------------|------------|---------------|--------------|--------|---------|
| 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
| 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
| 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
| 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |
Sample Output

| customer_number |
|-----------------|
| 3               |
Explanation

The customer with number '3' has two orders, which is greater than either customer '1' or '2' because each of them  only has one order. 
So the result is customer_number '3'.
Follow up: What if more than one customer have the largest number of orders, can you find all the customer_number in this case?



SELECT customer_number 
FROM orders 
GROUP BY customer_number 
ORDER BY COUNT(*) DESC Limit 1

或者
select customer_number from orders
group by customer_number
having count(*) >= all(select count(*) from orders group by customer_number)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
596. Classes More Than 5 Students

There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:

+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
Should output:

+---------+
| class   |
+---------+
| Math    |
+---------+
 

Note:
The students should not be counted duplicate in each course.

select class from courses
group by class
having count(distinct student) >= 5
# disctinct 的用处：当出现两个{"A","Math"}的时候，是不应该判断为两个学生的，因为这两个人重复了。
# 之所以会出现这个问题，是因为在录入数据的时候A、Math被重复录入了，一开始自己没考虑到这个问题，但是上面的表确实没说过它有主键约束或者唯一约束，所以左侧的student字段是可能会重复的。为了去除重复值，要对student前加个distinct。


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
607. Sales Person
SQL架构
Description

Given three tables: salesperson, company, orders.
Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

Example
Input

Table: salesperson

+----------+------+--------+-----------------+-----------+
| sales_id | name | salary | commission_rate | hire_date |
+----------+------+--------+-----------------+-----------+
|   1      | John | 100000 |     6           | 4/1/2006  |
|   2      | Amy  | 120000 |     5           | 5/1/2010  |
|   3      | Mark | 65000  |     12          | 12/25/2008|
|   4      | Pam  | 25000  |     25          | 1/1/2005  |
|   5      | Alex | 50000  |     10          | 2/3/2007  |
+----------+------+--------+-----------------+-----------+
The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name.
Table: company

+---------+--------+------------+
| com_id  |  name  |    city    |
+---------+--------+------------+
|   1     |  RED   |   Boston   |
|   2     | ORANGE |   New York |
|   3     | YELLOW |   Boston   |
|   4     | GREEN  |   Austin   |
+---------+--------+------------+
The table company holds the company information. Every company has a com_id and a name.
Table: orders

+----------+------------+---------+----------+--------+
| order_id | order_date | com_id  | sales_id | amount |
+----------+------------+---------+----------+--------+
| 1        |   1/1/2014 |    3    |    4     | 100000 |
| 2        |   2/1/2014 |    4    |    5     | 5000   |
| 3        |   3/1/2014 |    1    |    1     | 50000  |
| 4        |   4/1/2014 |    1    |    4     | 25000  |
+----------+----------+---------+----------+--------+
The table orders holds the sales record information, salesperson and customer company are represented by sales_id and com_id.
output

+------+
| name | 
+------+
| Amy  | 
| Mark | 
| Alex |
+------+
Explanation

According to order '3' and '4' in table orders, it is easy to tell only salesperson 'John' and 'Alex' have sales to company 'RED',
so we need to output all the other names in table salesperson.


select s.name from salesperson s
where s.sales_id not in 
(select o.sales_id from orders o
left join company c
on c.com_id = o.com_id
where c.name = 'RED')

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
610. Triangle Judgement
SQL架构
A pupil Tim gets homework to identify whether three line segments could possibly form a triangle.
 

However, this assignment is very heavy because there are hundreds of records to calculate.
 

Could you help Tim by writing a query to judge whether these three sides can form a triangle, assuming table triangle holds the length of the three sides x, y and z.
 

| x  | y  | z  |
|----|----|----|
| 13 | 15 | 30 |
| 10 | 20 | 15 |
For the sample data above, your query should return the follow result:
| x  | y  | z  | triangle |
|----|----|----|----------|
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |


# case when 的用法
select x,y,z,
case when x+y > z and x+z>y and y+z > x then 'Yes' else 'No'
End as triangle
from triangle


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
613. Shortest Distance in a Line
SQL架构
Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
 

Write a query to find the shortest distance between two points in these points.
 

| x   |
|-----|
| -1  |
| 0   |
| 2   |
 

The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
 

| shortest|
|---------|
| 1       |
 

Note: Every point is unique, which means there is no duplicates in table point.
 

Follow-up: What if all these points have an id and are arranged from the left most to the right most of x axis?


select distinct min(abs(p1.x-p2.x)) as shortest
from point p1, point p2
where p1.x != p2.x

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
619. Biggest Single Number
SQL架构
Table my_numbers contains many numbers in column num including duplicated ones.
Can you write a SQL query to find the biggest number, which only appears once.

+---+
|num|
+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 | 
For the sample data above, your query should return the following result:
+---+
|num|
+---+
| 6 |
Note:
If there is no such number, just output null.

错误：
select max(num) from my_numbers group by num having count(*)=1
# 以上解法错误，因为这样取出来的是每一分组里的最大值，select里的聚合函数是针对每一分组的，不能直接作用于聚合键

select num
from my_numbers
group by num
having count(num) = 1
order by num desc
limit 1
#以上解法错误，因为如果没有符合条件的，上述不会返回null

正确：
# 解法1：
-- 使用子查询找出仅出现一次的数字。

SELECT
    num
FROM
    my_numbers
GROUP BY num
HAVING COUNT(num) = 1;

-- 然后使用 MAX() 函数找出其中最大的一个。


SELECT
    MAX(num) AS num
FROM
    (SELECT
        num
    FROM
        number
    GROUP BY num
    HAVING COUNT(num) = 1) AS t
;


-- 解法2：
select 
(select num from my_numbers group by num having count(num)=1 order by num desc limit 1) 
as num

# 不需要ifnull，直接在内层select上套一层select，就可以自动在找不到的时候返回null

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

620. Not Boring Movies
SQL架构
X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.

 

For example, table cinema:

+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
For the example above, the output should be:
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+


select * from cinema
where mod(id,2) <> 0
and description <> 'boring'
order by rating desc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1050. Actors and Directors Who Cooperated At Least Three Times
SQL架构
Table: ActorDirector

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| actor_id    | int     |
| director_id | int     |
| timestamp   | int     |
+-------------+---------+
timestamp is the primary key column for this table.
 

Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.

Example:

ActorDirector table:
+-------------+-------------+-------------+
| actor_id    | director_id | timestamp   |
+-------------+-------------+-------------+
| 1           | 1           | 0           |
| 1           | 1           | 1           |
| 1           | 1           | 2           |
| 1           | 2           | 3           |
| 1           | 2           | 4           |
| 2           | 1           | 5           |
| 2           | 1           | 6           |
+-------------+-------------+-------------+

Result table:
+-------------+-------------+
| actor_id    | director_id |
+-------------+-------------+
| 1           | 1           |
+-------------+-------------+
The only pair is (1, 1) where they cooperated exactly 3 times.


select actor_id, director_id 
from ActorDirector
group by actor_id, director_id
having count(*) >= 3

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1068. Product Sales Analysis I
SQL架构
Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key of this table.
product_id is a foreign key to Product table.
Note that the price is per unit.
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key of this table.
 

Write an SQL query that reports all product names of the products in the Sales table along with their selling year and price.

For example:

Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+

Result table:
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+

select product_name, year, price
from product p
right join sales s
on p.product_id = s.product_id

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1069. Product Sales Analysis II
SQL架构
Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
sale_id is the primary key of this table.
product_id is a foreign key to Product table.
Note that the price is per unit.
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key of this table.
 

Write an SQL query that reports the total quantity sold for every product id.

The query result format is in the following example:

Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+

Result table:
+--------------+----------------+
| product_id   | total_quantity |
+--------------+----------------+
| 100          | 22             |
| 200          | 15             |
+--------------+----------------+


select s.product_id, 
sum(quantity) as total_quantity
from sales s
left join product p
on s.product_id = p.product_id
group by product_id


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1075. Project Employees I

Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
 

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

The query result format is in the following example:

Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

Result table:
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50


# Write your MySQL query statement below
select p.project_id,
round(avg(experience_years),2) as average_years
from project p, employee e 
where p.employee_id = e.employee_id
group by project_id

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1076. Project Employees II
SQL架构
Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
 

Write an SQL query that reports all the projects that have the most employees.

The query result format is in the following example:

Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

Result table:
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+
The first project has 3 employees while the second one has 2.

错误：

select project_id
from project p
group by project_id
order by count(distinct employee_id) desc
limit 1

以上解法错误，因为可能有多个项目含有最多的员工，

正确：
all 和 any 的用法
The ANY and ALL operators are used with a WHERE or HAVING clause.
The ANY operator returns true if any of the subquery values meet the condition.
The ALL operator returns true if all of the subquery values meet the condition.

比如
select * from student where 班级=’01’ and age > all (select age from student where 班级=’02’);
就是说，查询出01班中，年龄大于 02班所有人的同学
相当于
select * from student where 班级=’01’ and age > (select max(age) from student where 班级=’02’);

而
select * from student where 班级=’01’ and age > any (select age from student where 班级=’02’);
就是说，查询出01班中，年龄大于 02班任意一个 的 同学
相当于
select * from student where 班级=’01’ and age > (select min(age) from student where 班级=’02’);x


# Write your MySQL query statement below

select project_id
from project p
group by project_id
having count(distinct employee_id) >= all(select count(employee_id) from Project group by project_id)





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1082. Sales Analysis I
SQL架构
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.
 

Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.

The query result format is in the following example:

Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+
Both sellers with id 1 and 3 sold products with the most total price of 2800.



select seller_id
from sales s 
group by seller_id
having sum(price) >= all(select sum(price) from sales group by seller_id)

# 用all
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1083. Sales Analysis II
SQL架构
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.
 

Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

The query result format is in the following example:

Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+
| buyer_id    |
+-------------+
| 1           |
+-------------+
The buyer with id 1 bought an S8 but didnt buy an iPhone. The buyer with id 3 bought both.



#思路是先选择买了S8的用户，再剔除其中又买了iPHONE的用户
# 要用buyer_id来做筛选

select distinct buyer_id
from sales s 
where s.product_id in (select p.product_id from product p where p.product_name = 'S8')
and buyer_id not in (select buyer_id from sales,product where sales.product_id = product.product_id and product.product_name = 'iPhone')



-- select buyer_id
-- from sales s 
-- where s.product_id in (select p.product_id from product p where p.product_name = 'S8' and p.product_name != 'iPhone' )
 ## 不知道哪儿错了
 ## 可能是因为 select p.product_id from product p where p.product_name = 'S8' and p.product_name != 'iPhone'  返回的是 product_id =1 
 ## 然而买了product_id =1 的用户有1，3

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1084. Sales Analysis III
SQL架构
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.
 

Write an SQL query that reports the products that were only sold in spring 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.

The query result format is in the following example:

Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+



学到了
sum 等式为真=1 为假=0

select p.product_id, p.product_name
from sales s, product p
where s.product_id = p.product_id
group by s.product_id
having sum(s.sale_date> '2019-03-31')=0 and sum(s.sale_date < '2019-01-01') = 0

或者
感觉这样更简单粗暴，因为是仅在，只要有在春季以外销售的就可以了。

select distinct p.product_id, p.product_name
from product p 
join sales s 
on p.product_id = s.product_id
where p.product_id not in (select product_id from sales where sale_date > '2019-03-31' or sale_date < '2019-01-01' )

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1113. Reported Posts
SQL架构
Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    | 
| action        | enum    |
| extra         | varchar |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action such as a reason for report or a type of reaction. 
 

Write an SQL query that reports the number of posts reported yesterday for each report reason. Assume today is 2019-07-05.

The query result format is in the following example:

Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 4       | 2019-07-04  | view   | null   |
| 2       | 4       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-04  | view   | null   |
| 5       | 2       | 2019-07-04  | report | racism |
| 5       | 5       | 2019-07-04  | view   | null   |
| 5       | 5       | 2019-07-04  | report | racism |
+---------+---------+-------------+--------+--------+

Result table:
+---------------+--------------+
| report_reason | report_count |
+---------------+--------------+
| spam          | 1            |
| racism        | 2            |
+---------------+--------------+ 
Note that we only care about report reasons with non zero number of reports.



隐藏条件：多个用户 以 同一个理由 举报 同一个贴子，只能给该理由对应的举报次数增加 1
存在duplicate

select extra as report_reason,
count(distinct post_id) as report_count
from actions
where action_date = '2019-07-04' and extra is not null and action = 'report'
group by extra
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1141. User Activity for the Past 30 Days I
SQL架构
Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity_type column is an ENUM of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
 

Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on some day if he/she made at least one activity on that day.

The query result format is in the following example:

Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+

Result table:
+------------+--------------+ 
| day        | active_users |
+------------+--------------+ 
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
+------------+--------------+ 
Note that we do not care about days with zero active users.




select activity_date as day, 
count(distinct user_id )as active_users
from activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date

或者datediff的使用

select activity_date day, count(distinct user_id) as active_users
from activity
where datediff('2019-07-27', activity_date) < 30
group by activity_date


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1142. User Activity for the Past 30 Days II
SQL架构
Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity_type column is an ENUM of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website.
Note that each session belongs to exactly one user.
 

Write an SQL query to find the average number of sessions per user for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places. The sessions we want to count for a user are those with at least one activity in that time period.

The query result format is in the following example:

Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 3       | 5          | 2019-07-21    | open_session  |
| 3       | 5          | 2019-07-21    | scroll_down   |
| 3       | 5          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+

Result table:
+---------------------------+ 
| average_sessions_per_user |
+---------------------------+ 
| 1.33                      |
+---------------------------+ 
User 1 and 2 each had 1 session in the past 30 days while user 3 had 2 sessions so the average is (1 + 1 + 2) / 3 = 1.33.


# 注意null
select ifnull(round(count(distinct session_id) / count(distinct user_id),2),0) as average_sessions_per_user
from activity
where activity_date between '2019-06-28' and '2019-07-27'


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1148. Article Views I
SQL架构
Table: Views

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write an SQL query to find all the authors that viewed at least one of their own articles, sorted in ascending order by their id.

The query result format is in the following example:

Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+

Result table:
+------+
| id   |
+------+
| 4    |
| 7    |
+------+


select distinct author_id as id
from views
where author_id = viewer_id
order by id asc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1173. Immediate Food Delivery I
SQL架构
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise its called scheduled.

Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places.

The query result format is in the following example:

Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 5           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-11                  |
| 4           | 3           | 2019-08-24 | 2019-08-26                  |
| 5           | 4           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
+-------------+-------------+------------+-----------------------------+

Result table:
+----------------------+
| immediate_percentage |
+----------------------+
| 33.33                |
+----------------------+
The orders with delivery id 2 and 3 are immediate while the others are scheduled.



# Write your MySQL query statement below
select round(sum(order_date = customer_pref_delivery_date)/count(delivery_id) * 100,2) as immediate_percentage
from delivery

#我们还可以直接使用 sum。当 order_date = customer_pref_delivery_date 为真时，sum 值加 1。


select round(sum(if(order_date = customer_pref_delivery_date,1,0))/count(delivery_id) * 100,2) as immediate_percentage
from delivery



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1179. Reformat Department Table
SQL架构
Table: Department

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| revenue       | int     |
| month         | varchar |
+---------------+---------+
(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].
 

Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.

The query result format is in the following example:

Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+

Result table:
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+

Note that the result table has 13 columns (1 for the department id + 12 for the months).



select id, 
sum(case month when 'Jan' then revenue else null end ) as Jan_Revenue,
sum(case month when 'Feb' then revenue else null end) as Feb_Revenue,
sum(case month when 'Mar' then revenue else null end) as Mar_Revenue,
sum(case month when 'Apr' then revenue else null end) as Apr_Revenue,
sum(case month when 'May' then revenue else null end) as May_Revenue,
sum(case month when 'Jun' then revenue else null end) as Jun_Revenue,
sum(case month when 'Jul' then revenue else null end) as Jul_Revenue,
sum(case month when 'Aug' then revenue else null end) as Aug_Revenue,
sum(case month when 'Sep' then revenue else null end) as Sep_Revenue,
sum(case month when 'Oct' then revenue else null end) as Oct_Revenue,
sum(case month when 'Nov' then revenue else null end) as Nov_Revenue,
sum(case month when 'Dec' then revenue else null end) as Dec_Revenue
from department
group by id


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1211. Queries Quality and Percentage
SQL架构
Table: Queries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
There is no primary key for this table, it may have duplicate rows.
This table contains information collected from some queries on a database.
The position column has a value from 1 to 500.
The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 

We define query quality as:

The average of the ratio between query rating and its position.

We also define poor query percentage as:

The percentage of all queries with rating less than 3.

Write an SQL query to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

The query result format is in the following example:

Queries table:
+------------+-------------------+----------+--------+
| query_name | result            | position | rating |
+------------+-------------------+----------+--------+
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |
+------------+-------------------+----------+--------+

Result table:
+------------+---------+-----------------------+
| query_name | quality | poor_query_percentage |
+------------+---------+-----------------------+
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |
+------------+---------+-----------------------+

Dog queries quality is ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50
Dog queries poor_ query_percentage is (1 / 3) * 100 = 33.33

Cat queries quality equals ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66
Cat queries poor_ query_percentage is (1 / 3) * 100 = 33.33


select query_name,
round(avg(rating/position),2)as quality,
round(100*sum(rating < 3)/count(distinct result),2) as poor_query_percentage
from queries
group by query_name


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1241. Number of Comments per Post
SQL架构
Table: Submissions

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| sub_id        | int      |
| parent_id     | int      |
+---------------+----------+
There is no primary key for this table, it may have duplicate rows.
Each row can be a post or comment on the post.
parent_id is null for posts.
parent_id for comments is sub_id for another post in the table.
 

Write an SQL query to find number of comments per each post.

Result table should contain post_id and its corresponding number_of_comments, and must be sorted by post_id in ascending order.

Submissions may contain duplicate comments. You should count the number of unique comments per post.

Submissions may contain duplicate posts. You should treat them as one post.

The query result format is in the following example:

Submissions table:
+---------+------------+
| sub_id  | parent_id  |
+---------+------------+
| 1       | Null       |
| 2       | Null       |
| 1       | Null       |
| 12      | Null       |
| 3       | 1          |
| 5       | 2          |
| 3       | 1          |
| 4       | 1          |
| 9       | 1          |
| 10      | 2          |
| 6       | 7          |
+---------+------------+

Result table:
+---------+--------------------+
| post_id | number_of_comments |
+---------+--------------------+
| 1       | 3                  |
| 2       | 2                  |
| 12      | 0                  |
+---------+--------------------+

The post with id 1 has three comments in the table with id 3, 4 and 9. The comment with id 3 is repeated in the table, we counted it only once.
The post with id 2 has two comments in the table with id 5 and 10.
The post with id 12 has no comments in the table.
The comment with id 6 is a comment on a deleted post with id 7 so we ignored it.



# 可以把这个表与自己连接，然后通过left join或者right join来确保所有的帖子都能取到
# 根据post和对应的comment进行匹配，形成联合表（sub_id=parent_id）,并去除掉那些不是post而是comments的（s1.s1.parent_id is null），此时含有重复项,然后group by 注意去掉重复项
 select * from submissions s1
 left join submissions s2
 on s1.sub_id = s2.parent_id
 where s1.parent_id is null

# 用group by计算comments个数，
select distinct t.sub_id as post_id,
ifnull(count(distinct s2.subid),0)as number_of_comments
from submissions s1
left join submissions s2
on s1.sub_id = s2.parent_id
where s1.parent_id is null
group by t.sub_id
order by post_id asc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1251. Average Selling Price
SQL架构
Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units and product_id of each product sold. 
 

Write an SQL query to find the average selling price for each product.

average_price should be rounded to 2 decimal places.

The query result format is in the following example:

Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
 
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+

Result table:
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+
Average selling price = Total Price of Product / Number of products sold.
Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96



select p.product_id, round(sum(price * units)/sum(units),2) as average_price 
from Prices p
left join UnitsSold u
on p.product_id = u.product_id
and u.purchase_date <= p.end_date 
and u.purchase_date >= p.start_date
group by product_id;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1280. Students and Examinations
SQL架构
Table: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key for this table.
Each row of this table contains the ID and the name of one student in the school.
 

Table: Subjects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key for this table.
Each row of this table contains the name of one subject in the school.
 

Table: Examinations

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key for this table. It may contain duplicates.
Each student from the Students table takes every course from Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

Write an SQL query to find the number of times each student attended each exam.

Order the result table by student_id and subject_name.

The query result format is in the following example:

Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
Result table:
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
The result table should contain all students and all subjects.
Alice attended Math exam 3 times, Physics exam 2 times and Programming exam 1 time.
Bob attended Math exam 1 time, Programming exam 1 time and didn't attend the Physics exam.
Alex didn't attend any exam.
John attended Math exam 1 time, Physics exam 1 time and Programming exam 1 time.




# 要注意，有的学生没有参加任何考试，或者是没有参加全部的考试
#　但是The result table should contain all students and all subjects.
# 所以：使用笛卡尔积生成一张临时表(cross join)，再把每个人全科的临时表和和成绩表左连，分组聚合得到

# select * from students,subjects
#得到：{"headers": ["student_id", "student_name", "subject_name"], "values": [[1, "Alice", "Programming"], [1, "Alice", "Physics"], [1, "Alice", "Math"], [2, "Bob", "Programming"], [2, "Bob", "Physics"], [2, "Bob", "Math"], [13, "John", "Programming"], [13, "John", "Physics"], [13, "John", "Math"], [6, "Alex", "Programming"], [6, "Alex", "Physics"], [6, "Alex", "Math"]]}

#然后左连，group by
#注意attended_exams 应该用e.subject_name 的次数来计算
select s.student_id,s.student_name, s.subject_name,
ifnull(count(e.subject_name),0) as attended_exams 
from (select * from students,subjects) s
left join examinations e
on s.student_id = e.student_id and s.subject_name = e.subject_name
group by s.student_id, s.subject_name
order by s.student_id, s.subject_name
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1294. Weather Type in Each Country
SQL架构
Table: Countries

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| country_id    | int     |
| country_name  | varchar |
+---------------+---------+
country_id is the primary key for this table.
Each row of this table contains the ID and the name of one country.
 

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| country_id    | int     |
| weather_state | varchar |
| day           | date    |
+---------------+---------+
(country_id, day) is the primary key for this table.
Each row of this table indicates the weather state in a country for one day.
 

Write an SQL query to find the type of weather in each country for November 2019.

The type of weather is Cold if the average weather_state is less than or equal 15, Hot if the average weather_state is greater than or equal 25 and Warm otherwise.

Return result table in any order.

The query result format is in the following example:

Countries table:
+------------+--------------+
| country_id | country_name |
+------------+--------------+
| 2          | USA          |
| 3          | Australia    |
| 7          | Peru         |
| 5          | China        |
| 8          | Morocco      |
| 9          | Spain        |
+------------+--------------+
Weather table:
+------------+---------------+------------+
| country_id | weather_state | day        |
+------------+---------------+------------+
| 2          | 15            | 2019-11-01 |
| 2          | 12            | 2019-10-28 |
| 2          | 12            | 2019-10-27 |
| 3          | -2            | 2019-11-10 |
| 3          | 0             | 2019-11-11 |
| 3          | 3             | 2019-11-12 |
| 5          | 16            | 2019-11-07 |
| 5          | 18            | 2019-11-09 |
| 5          | 21            | 2019-11-23 |
| 7          | 25            | 2019-11-28 |
| 7          | 22            | 2019-12-01 |
| 7          | 20            | 2019-12-02 |
| 8          | 25            | 2019-11-05 |
| 8          | 27            | 2019-11-15 |
| 8          | 31            | 2019-11-25 |
| 9          | 7             | 2019-10-23 |
| 9          | 3             | 2019-12-23 |
+------------+---------------+------------+
Result table:
+--------------+--------------+
| country_name | weather_type |
+--------------+--------------+
| USA          | Cold         |
| Austraila    | Cold         |
| Peru         | Hot          |
| China        | Warm         |
| Morocco      | Hot          |
+--------------+--------------+
Average weather_state in USA in November is (15) / 1 = 15 so weather type is Cold.
Average weather_state in Austraila in November is (-2 + 0 + 3) / 3 = 0.333 so weather type is Cold.
Average weather_state in Peru in November is (25) / 1 = 25 so weather type is Hot.
Average weather_state in China in November is (16 + 18 + 21) / 3 = 18.333 so weather type is Warm.
Average weather_state in Morocco in November is (25 + 27 + 31) / 3 = 27.667 so weather type is Hot.
We know nothing about average weather_state in Spain in November so we dont include it in the result table. 


select c.country_name,
case when avg(w.weather_state) <= 15 then 'Cold' when avg(w.weather_state) >= 25 then 'Hot' else 'Warm' end as weather_type
from countries c
left join weather w
on c.country_id = w.country_id
where w.day between '2019-11-1' and '2019-11-30'
group by w.country_id

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1303. Find the Team Size
SQL架构
Table: Employee

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| team_id       | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table contains the ID of each employee and their respective team.
Write an SQL query to find the team size of each of the employees.

Return result table in any order.

The query result format is in the following example:

Employee Table:
+-------------+------------+
| employee_id | team_id    |
+-------------+------------+
|     1       |     8      |
|     2       |     8      |
|     3       |     8      |
|     4       |     7      |
|     5       |     9      |
|     6       |     9      |
+-------------+------------+
Result table:
+-------------+------------+
| employee_id | team_size  |
+-------------+------------+
|     1       |     3      |
|     2       |     3      |
|     3       |     3      |
|     4       |     1      |
|     5       |     2      |
|     6       |     2      |
+-------------+------------+
Employees with Id 1,2,3 are part of a team with team_id = 8.
Employees with Id 4 is part of a team with team_id = 7.
Employees with Id 5,6 are part of a team with team_id = 9.


select e1.employee_id, ifnull(count(e1.team_id),0) as team_size
from employee e1, employee e2
where e1.team_id = e2.team_id
group by e1.employee_id
order by e1.employee_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1322. Ads Performance
SQL架构
Table: Ads

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ad_id         | int     |
| user_id       | int     |
| action        | enum    |
+---------------+---------+
(ad_id, user_id) is the primary key for this table.
Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').
 

A company is running Ads and wants to calculate the performance of each Ad.

Performance of the Ad is measured using Click-Through Rate (CTR) where:

CTR = O 
OR CTR = Ad total clicks / (Ad total clicks + Ad total views) *100


Write an SQL query to find the ctr of each Ad.

Round ctr to 2 decimal points. Order the result table by ctr in descending order and by ad_id in ascending order in case of a tie.

The query result format is in the following example:

Ads table:
+-------+---------+---------+
| ad_id | user_id | action  |
+-------+---------+---------+
| 1     | 1       | Clicked |
| 2     | 2       | Clicked |
| 3     | 3       | Viewed  |
| 5     | 5       | Ignored |
| 1     | 7       | Ignored |
| 2     | 7       | Viewed  |
| 3     | 5       | Clicked |
| 1     | 4       | Viewed  |
| 2     | 11      | Viewed  |
| 1     | 2       | Clicked |
+-------+---------+---------+
Result table:
+-------+-------+
| ad_id | ctr   |
+-------+-------+
| 1     | 66.67 |
| 3     | 50.00 |
| 2     | 33.33 |
| 5     | 0.00  |
+-------+-------+
for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
Note that we dont care about Ignored Ads.
Result table is ordered by the ctr. in case of a tie we order them by ad_id




select ad_id, round(ifnull(100* sum(action = 'Clicked')/sum(if(action != 'Ignored',1,0)),0),2) as ctr
from ads
group by ad_id
order by ctr desc, ad_id asc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1327. List the Products Ordered in a Period
SQL架构
Table: Products

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| product_id       | int     |
| product_name     | varchar |
| product_category | varchar |
+------------------+---------+
product_id is the primary key for this table.
This table contains data about the companys products.
Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| order_date    | date    |
| unit          | int     |
+---------------+---------+
There is no primary key for this table. It may have duplicate rows.
product_id is a foreign key to Products table.
unit is the number of products ordered in order_date.
 

Write an SQL query to get the names of products with greater than or equal to 100 units ordered in February 2020 and their amount.

Return result table in any order.

The query result format is in the following example:

 

Products table:
+-------------+-----------------------+------------------+
| product_id  | product_name          | product_category |
+-------------+-----------------------+------------------+
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |
+-------------+-----------------------+------------------+

Orders table:
+--------------+--------------+----------+
| product_id   | order_date   | unit     |
+--------------+--------------+----------+
| 1            | 2020-02-05   | 60       |
| 1            | 2020-02-10   | 70       |
| 2            | 2020-01-18   | 30       |
| 2            | 2020-02-11   | 80       |
| 3            | 2020-02-17   | 2        |
| 3            | 2020-02-24   | 3        |
| 4            | 2020-03-01   | 20       |
| 4            | 2020-03-04   | 30       |
| 4            | 2020-03-04   | 60       |
| 5            | 2020-02-25   | 50       |
| 5            | 2020-02-27   | 50       |
| 5            | 2020-03-01   | 50       |
+--------------+--------------+----------+

Result table:
+--------------------+---------+
| product_name       | unit    |
+--------------------+---------+
| Leetcode Solutions | 130     |
| Leetcode Kit       | 100     |
+--------------------+---------+

Products with product_id = 1 is ordered in February a total of (60 + 70) = 130.
Products with product_id = 2 is ordered in February a total of 80.
Products with product_id = 3 is ordered in February a total of (2 + 3) = 5.
Products with product_id = 4 was not ordered in February 2020.
Products with product_id = 5 is ordered in February a total of (50 + 50) = 100.



# 看了一下评论，总结一下时间怎么指定2020年2月的方法：
(1) order_date between '2020-02-01' and '2020-02-29'  
(2) order_date like '2020-02%'  
(3) DATE_FORMAT(order_date, "%Y-%m") = "2020-02"   
(4) LEFT(order_date, 7) 或 substr(1, 7)


select product_name, sum(unit) as unit
from products p
left join orders o 
on p.product_id = o.product_id
where order_date between '2020-02-01' and '2020-02-29'
group by p.product_id
having sum(unit) >= 100

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1350. Students With Invalid Departments
SQL架构
Table: Departments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key of this table.
The table has information about the id of each department of a university.
 

Table: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| department_id | int     |
+---------------+---------+
id is the primary key of this table.
The table has information about the id of each student at a university and the id of the department he/she studies at.
 

Write an SQL query to find the id and the name of all students who are enrolled in departments that no longer exists.

Return the result table in any order.

The query result format is in the following example:

Departments table:
+------+--------------------------+
| id   | name                     |
+------+--------------------------+
| 1    | Electrical Engineering   |
| 7    | Computer Engineering     |
| 13   | Bussiness Administration |
+------+--------------------------+

Students table:
+------+----------+---------------+
| id   | name     | department_id |
+------+----------+---------------+
| 23   | Alice    | 1             |
| 1    | Bob      | 7             |
| 5    | Jennifer | 13            |
| 2    | John     | 14            |
| 4    | Jasmine  | 77            |
| 3    | Steve    | 74            |
| 6    | Luis     | 1             |
| 8    | Jonathan | 7             |
| 7    | Daiana   | 33            |
| 11   | Madelynn | 1             |
+------+----------+---------------+

Result table:
+------+----------+
| id   | name     |
+------+----------+
| 2    | John     |
| 7    | Daiana   |
| 4    | Jasmine  |
| 3    | Steve    |
+------+----------+

John, Daiana, Steve and Jasmine are enrolled in departments 14, 33, 74 and 77 respectively. department 14, 33, 74 and 77 doesnt exist in the Departments table.


select s.id, s.name
from students s
left join departments d 
on s.department_id = d.id
where d.id is null

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1378. Replace Employee ID With The Unique Identifier
SQL架构
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the id and the name of an employee in a company.
 

Table: EmployeeUNI

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.
 

Write an SQL query to show the unique ID of each user, If a user doesnt have a unique ID replace just show null.

Return the result table in any order.

The query result format is in the following example:

Employees table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Alice    |
| 7  | Bob      |
| 11 | Meir     |
| 90 | Winston  |
| 3  | Jonathan |
+----+----------+

EmployeeUNI table:
+----+-----------+
| id | unique_id |
+----+-----------+
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |
+----+-----------+

EmployeeUNI table:
+-----------+----------+
| unique_id | name     |
+-----------+----------+
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |
+-----------+----------+

Alice and Bob dont have a unique ID, We will show null instead.
The unique ID of Meir is 2.
The unique ID of Winston is 3.
The unique ID of Jonathan is 1.


select uni.unique_id, e.name
from Employees e
left join EmployeeUNI uni
on e.id = uni.id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1407. Top Travellers
SQL架构
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the user.
 

Table: Rides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| user_id       | int     |
| distance      | int     |
+---------------+---------+
id is the primary key for this table.
user_id is the id of the user who travelled the distance "distance".
 

Write an SQL query to report the distance travelled by each user.

Return the result table ordered by travelled_distance in descending order, if two or more users travelled the same distance, order them by their name in ascending order.

The query result format is in the following example.

 

Users table:
+------+-----------+
| id   | name      |
+------+-----------+
| 1    | Alice     |
| 2    | Bob       |
| 3    | Alex      |
| 4    | Donald    |
| 7    | Lee       |
| 13   | Jonathan  |
| 19   | Elvis     |
+------+-----------+

Rides table:
+------+----------+----------+
| id   | user_id  | distance |
+------+----------+----------+
| 1    | 1        | 120      |
| 2    | 2        | 317      |
| 3    | 3        | 222      |
| 4    | 7        | 100      |
| 5    | 13       | 312      |
| 6    | 19       | 50       |
| 7    | 7        | 120      |
| 8    | 19       | 400      |
| 9    | 7        | 230      |
+------+----------+----------+

Result table:
+----------+--------------------+
| name     | travelled_distance |
+----------+--------------------+
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |
+----------+--------------------+
Elvis and Lee travelled 450 miles, Elvis is the top traveller as his name is alphabetically smaller than Lee.
Bob, Jonathan, Alex and Alice have only one ride and we just order them by the total distances of the ride.
Donald didnt have any rides, the distance travelled by him is 0.


select u.name, ifnull(sum(r.distance),0) as travelled_distance 
from users u 
left join rides r
on u.id = r.user_id
group by u.id
order by travelled_distance desc, name asc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1435. Create a Session Bar Chart
SQL架构
Table: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the primary key for this table.
duration is the time in seconds that a user has visited the application.
 

You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

Write an SQL query to report the (bin, total) in any order.

The query result format is in the following example.

Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 199           |
| 3           | 299           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+

Result table:
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+

For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater or equal than 15 minutes.


错误：去掉了空值
select 
(case when duration >=0 and duration <300 then  "[0-5>" when duration >= 300 and duration < 600 then "[5-10>" when duration >= 600 and duration < 900 then "[10-15>" else "15 or more " end) as bin,
count(duration) as total
from sessions
group by bin


正确： 用union 可以保留空值

select '[0-5>' BIN,count(duration/60)TOTAL from Sessions where duration/60>=0 and duration/60<5
union
select '[5-10>' BIN,count(duration/60)TOTAL from Sessions where duration/60>=5 and duration/60<10
union
select '[10-15>' BIN,count(duration/60)TOTAL from Sessions where duration/60>=10 and duration/60<15
union 
select '15 or more' BIN,count(duration/60)TOTAL from Sessions where duration/60>=15
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
534. Game Play Analysis III
SQL架构
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 1         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |
+-----------+------------+---------------------+
For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games played by 2017-06-25.
For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
Note that for each player we only care about the days when the player logged in.


#累积型计算套路
#方法2：自连接
select a1.player_id,a1.event_date,sum(a2.games_played) games_played_so_far
from Activity a1,Activity a2
where
a1.player_id=a2.player_id
and a2.event_date<=a1.event_date
group by a1.player_id,a1.event_date
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
550. Game Play Analysis IV
SQL架构
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33



-- 思路
-- 分析本题，让求出首次登陆游戏后第二天又登陆游戏的玩家所占的比例，保留两位小数；

-- 首先我们可以把问题拆分，先求出所有玩家第一次登陆的数据，然后把这个作为临时表，然后我们把所有数据和他们第一次登陆的数据进行比较，如果日期相差1天，即为符合条件的玩家，用这部分的玩家数量除以所有玩家的数量，然后保留两位小数就可以得出结果了；

-- 解法有多种，但是思路都是一样的，选择最直观效率的方法完成即可


-- 求出所有玩家首次登陆数据
-- select player_id,min(event_date) first_date from activity group by player_id


-- 将所有玩家首次登陆数据作为临时表，并和所有数据表activity进行关联
-- select *
-- from activity a,
-- (select player_id,min(event_date) first_date from activity group by player_id) b
-- where a.player_id=b.player_id


-- 使用datediff函数计算玩家每次登陆和首次登陆的日期差，使用count+distinct函数获取所有玩家数
-- select datediff(a.event_date,b.first_date),(select count(distinct(player_id)) from activity)
-- from activity a,
-- (select player_id,min(event_date) first_date from activity group by player_id) b
-- where a.player_id=b.player_id


-- 使用case when then else过滤出所有符合条件的玩家，然后使用sum求和，计算出符合条件的玩家数目
-- select sum(case when datediff(a.event_date,b.first_date)=1 then 1 else 0 end),(select count(distinct(player_id)) from activity)
-- from activity a,
-- (select player_id,min(event_date) first_date from activity group by player_id) b
-- where a.player_id=b.player_id


-- 最后将符合条件的玩家数除以所有玩家数，并使用round函数，保留两位小数,并且按照例子上面的输出结果给列名取个别名即可
-- select round(sum(case when datediff(a.event_date,b.first_date)=1 then 1 else 0 end)/(select count(distinct(player_id)) from activity),2) as fraction
-- from activity a,
-- (select player_id,min(event_date) first_date from activity group by player_id) b
-- where a.player_id=b.player_id

# 结果

select round(sum(datediff(a.event_date,b.first_date) = 1)/(select count(distinct player_id) from activity),2) as fraction
from activity a,
(select player_id,min(event_date) first_date from activity group by player_id ) b
where a.player_id = b.player_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

578. Get Highest Answer Rate Question
SQL架构
Get the highest answer rate question from a table survey_log with these columns: id, action, question_id, answer_id, q_num, timestamp.

id means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

Write a sql query to identify the question which has the highest answer rate.

Example:

Input:
+------+-----------+--------------+------------+-----------+------------+
| id   | action    | question_id  | answer_id  | q_num     | timestamp  |
+------+-----------+--------------+------------+-----------+------------+
| 5    | show      | 285          | null       | 1         | 123        |
| 5    | answer    | 285          | 124124     | 1         | 124        |
| 5    | show      | 369          | null       | 2         | 125        |
| 5    | skip      | 369          | null       | 2         | 126        |
+------+-----------+--------------+------------+-----------+------------+
Output:
+-------------+
| survey_log  |
+-------------+
|    285      |
+-------------+
Explanation:
question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
 

Note: The highest answer rate meaning is: answer numbers ratio in show number in the same question.




# Write your MySQL query statement below
select question_id as survey_log
from survey_log s
group by question_id
order by sum(action = 'answer')/sum(action='show') desc
limit 1


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

580. Count Student Number in Departments
SQL架构
A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.

Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.

The student is described as follow:

| Column Name  | Type      |
|--------------|-----------|
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |
where student_id is the student's ID number, student_name is the student's name, gender is their gender, and dept_id is the department ID associated with their declared major.

And the department table is described as below:

| Column Name | Type    |
|-------------|---------|
| dept_id     | Integer |
| dept_name   | String  |
where dept_id is the departments ID number and dept_name is the department name.

Here is an example input:
student table:

| student_id | student_name | gender | dept_id |
|------------|--------------|--------|---------|
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
department table:

| dept_id | dept_name   |
|---------|-------------|
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
The Output should be:

| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |




# Write your MySQL query statement below
select d.dept_name, 
count(s.student_id) as student_number 
from department d
left join student s
on d.dept_id = s.dept_id
group by d.dept_id
order by student_number desc, dept_name asc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

585. Investments in 2016
SQL架构
Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

Have the same TIV_2015 value as one or more other policyholders.
Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).
Input Format:
The insurance table is described as follows:

| Column Name | Type          |
|-------------|---------------|
| PID         | INTEGER(11)   |
| TIV_2015    | NUMERIC(15,2) |
| TIV_2016    | NUMERIC(15,2) |
| LAT         | NUMERIC(5,2)  |
| LON         | NUMERIC(5,2)  |
where PID is the policyholders policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, LAT is the latitude of the policy holder's city, and LON is the longitude of the policy holder's city.

Sample Input

| PID | TIV_2015 | TIV_2016 | LAT | LON |
|-----|----------|----------|-----|-----|
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
Sample Output

| TIV_2016 |
|----------|
| 45.00    |
Explanation

The first record in the table, like the last record, meets both of the two criteria.
The TIV_2015 value '10' is as the same as the third and forth record, and its location unique.

The second record does not meet any of the two criteria. Its TIV_2015 is not like any other policyholders.

And its location is the same with the third record, which makes the third record fail, too.

So, the result is the sum of TIV_2016 of the first and last record, which is 45.




# Write your MySQL query statement below
# 注意，TIV_2015有重复 和 location unique需要不分顺序同时满足， 如果先筛出一个再筛出一个，就会有错误
# 注意，如果用
-- select pid
-- from insurance 
-- group by TIV_2015
-- having count(*) > 1
# 只会得到一个pid,1，而不是1，3，4
# 所以要用 select tiv_2015 from....

# 注意and 后i.lat,i.lon要加括号

select sum(i.tiv_2016) as tiv_2016
from insurance i
where 
i.tiv_2015 in (select tiv_2015 from insurance group by tiv_2015 having count(*)>1)
and 
(i.lat,i.lon) in (select lat,lon from insurance group by lat,lon having count(*)=1 )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
602. Friend Requests II: Who Has the Most Friends
SQL架构
In social network like Facebook or Twitter, people send friend requests and accept others requests as well.

 

Table request_accepted

+--------------+-------------+------------+
| requester_id | accepter_id | accept_date|
|--------------|-------------|------------|
| 1            | 2           | 2016_06-03 |
| 1            | 3           | 2016-06-08 |
| 2            | 3           | 2016-06-08 |
| 3            | 4           | 2016-06-09 |
+--------------+-------------+------------+
This table holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.
 

Write a query to find the the people who has most friends and the most friends number under the following rules:

It is guaranteed there is only 1 people having the most friends.
The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.
For the sample data above, the result is:

Result table:
+------+------+
| id   | num  |
|------|------|
| 3    | 3    |
+------+------+
The person with id '3' is a friend of people '1', '2' and '4', so he has 3 friends in total, which is the most number than any others.
Follow-up:
In the real world, multiple people could have the same most number of friends, can you find all these people in this case?




# Write your MySQL query statement below
# 好友关系是相互的。A加过B好友后，A和B相互是好友了。所以如果一个人接受了另一个人的请求，他们两个都会多拥有一个朋友。
# 所以我们可以将 requester_id 和 accepter_id 联合起来，然后统计每个人出现的次数。

-- 应用UNION运算符。

-- SELECT column_list
-- UNION [DISTINCT | ALL]
-- SELECT column_list
-- 即使不用DISTINCT关键字，UNION也会删除重复行。ALL不会删除重复行。


-- select requester_id as ids from request_accepted
-- union all 
-- select accepter_id as ids from request_accepted
-- 结果命名为表A。

select ids as id, count(*) as num
from
(
    select requester_id as ids from request_accepted
    union all
    select accepter_id as ids from request_accepted
) as A
group by A.ids
order by count(*) desc
limit 1


-- 或者更清楚一些：
-- (
--     select R1.requester_id as rid,R1.accepter_id as aid
--     from request_accepted as R1
--     UNION all
--     select R2.accepter_id as rid,R2.requester_id as aid
--     from request_accepted as R2
-- ) as A
-- 按rid分组，计算每组的好友个数，并按好友个数降序，取第一个人。

-- select rid as `id`,count(aid) as `num`
-- from
-- (
--     select R1.requester_id as rid,R1.accepter_id as aid
--     from request_accepted as R1
--     UNION all
--     select R2.accepter_id as rid,R2.requester_id as aid
--     from request_accepted as R2
-- ) as A
-- group by rid
-- order by num desc
-- limit 0,1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

608. Tree Node
SQL架构
Given a table tree, id is identifier of the tree node and p_id is its parent nodes id.

+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+
Each node in the tree can be one of three types:
Leaf: if the node is a leaf node.
Root: if the node is the root of the tree.
Inner: If the node is neither a leaf node nor a root node.
 

Write a query to print the node id and the type of the node. Sort your output by the node id. The result for the above sample is:
 

+----+------+
| id | Type |
+----+------+
| 1  | Root |
| 2  | Inner|
| 3  | Leaf |
| 4  | Leaf |
| 5  | Leaf |
+----+------+
 

Explanation

 

Node '1' is root node, because its parent node is NULL and it has child node '2' and '3'.
Node '2' is inner node, because it has parent node '1' and child node '4' and '5'.
Node '3', '4' and '5' is Leaf node, because they have parent node and they don
t have child node.

And here is the image of the sample tree as below:
 

			  1
			/   \
                      2       3
                    /   \
                  4       5
Note

If there is only one node on the tree, you only need to output its root attributes.



# p_id null与否，表明对应的id是否有parent node
# 那怎么表示对应的id是否有child node? 当id出现在p_id中时，id就有child node
# 怎么就绕不过弯呢！！id = p_id, 不就是意味着这个id当了parent node，它作为parent node，当然就有child node啦！！！！

select id,
case when t.p_id is null then 'Root' 
     when t.id in (select p_id from tree ) then 'Inner'
     else 'Leaf' 
     end as Type
from tree t

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

612. Shortest Distance in a Plane
SQL架构
Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 

Write a query to find the shortest distance between these points rounded to 2 decimals.
 

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
 

The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

| shortest |
|----------|
| 1.00     |
 

Note: The longest distance among all the points are less than 10000.
 

select round(sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y)),2) as shortest 
from point_2d p1, point_2d p2 
where (p1.x,p1.y) <> (p2.x, p2.y)
order by shortest asc
limit 1

# power(),表示几次方，power(p1.x-p2.x,2)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
614. Second Degree Follower
SQL架构
In facebook, there is a follow table with two columns: followee, follower.

Please write a sql query to get the amount of each follower’s follower if he/she has one.

For example:

+-------------+------------+
| followee    | follower   |
+-------------+------------+
|     A       |     B      |
|     B       |     C      |
|     B       |     D      |
|     D       |     E      |
+-------------+------------+
should output:
+-------------+------------+
| follower    | num        |
+-------------+------------+
|     B       |  2         |
|     D       |  1         |
+-------------+------------+
Explaination:
Both B and D exist in the follower list, when as a followee, B's follower is C and D, and D's follower is E. A does not exist in follower list.
 

 

Note:
Followee would not follow himself/herself in all cases.
Please display the result in followers alphabet order.


#对每一个关注者，查询关注他的关注者的数目
# 注意distinct


select f2.followee as follower, count(distinct (f2.follower)) as num
from follow f1
join follow f2
on f1.follower = f2.followee
-- where f2.followee is not null
group by f2.followee
order by f2.followee


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


626. Exchange Seats
SQL架构
Mary is a teacher in a middle school and she has a table seat storing students names and their corresponding seat ids.

The column id is continuous increment.
 

Mary wants to change seats for the adjacent students.
 

Can you write a SQL query to output the result for Mary?
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:
If the number of students is odd, there is no need to change the last ones seat.



# 当 id 为偶时， id-1
# 当 id为奇数且不是最后一个时，id+1
# 当 id为奇数且是最后一个时，保持不变

select 
    (case 
        when mod(id,2) <> 0 and id = (select count(*) from seat) then id
        when mod(id,2) <> 0 and id <> (select count(*) from seat) then id +1
        else id -1 
    end) as id,
student
from seat
order by id asc


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1045. Customers Who Bought All Products
SQL架构
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
product_key is a foreign key to Product table.
Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.
 

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

For example:

Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+

Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

Result table:
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
The customers who bought all the products (5 and 6) are customers with id 1 and 3.


# 思想：比较Customer表中去重之后的商品key是否等于商品表中的记录数
# 只判断数目

select customer_id
from customer c
group by c.customer_id
having count(distinct c.product_key) = (select count(distinct product_key) from Product )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1070. Product Sales Analysis III
SQL架构
Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
sale_id is the primary key of this table.
product_id is a foreign key to Product table.
Note that the price is per unit.
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key of this table.
 

Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

The query result format is in the following example:

Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+

Result table:
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+

# Write your MySQL query statement below
# 注意where 后两个变量加括号， 子查询的select 里两个变量不用加括号
select s.product_id, s.year as first_year, s.quantity, s.price 
from sales s
where (s.product_id, s.year) in (select product_id, min(year) from sales group by product_id)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1077. Project Employees III
SQL架构
Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
 

Write an SQL query that reports the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

The query result format is in the following example:

Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

Result table:
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Both employees with id 1 and 3 have the most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.


# Write your MySQL query statement below
select p.project_id, p.employee_id
from project p
left join employee e
on p.employee_id = e.employee_id
where (p.project_id,e.experience_years) in (
    select project_id, max(experience_years)
    from project
    left join employee
    on project.employee_id = employee.employee_id
    group by project.project_id
)

# 或者形成一个新表，加一列rank
-- SELECT project_id, employee_id
-- FROM (
--     SELECT 
--         p.project_id, p.employee_id,
--         RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC)
--         as 'rank'
--     FROM Project p LEFT JOIN Employee e ON p.employee_id = e.employee_id
-- ) t
-- WHERE rank = 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1098. Unpopular Books
SQL架构
Table: Books

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.
Table: Orders

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.
 

Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

The query result format is in the following example:

Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+

Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+

Result table:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+


# Write your MySQL query statement below
# 1. excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.
# 2. books that have sold less than 10 copies in the last year  Assume today is 2019-06-23.
# 两个时间都要满足

select b.book_id, b.name
from books b 
left join orders o
on b.book_id = o.book_id
where b.available_from < '2019-05-23'
group by b.book_id
having ifnull(sum(if(o.dispatch_date > '2018-06-23', quantity,0)),0) < 10
order by b.book_id

# sum（if(条件),column_name,0）
# 如果省略if，则默认为1,即 sum(条件) = sum(if(条件)，1，0)
# 注意如果是count条件， count(if(表达式，true, null)) 注意是null不是0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1107. New Users Daily Count
SQL架构
Table: Traffic

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| activity      | enum    |
| activity_date | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

The query result format is in the following example:

Traffic table:
+---------+----------+---------------+
| user_id | activity | activity_date |
+---------+----------+---------------+
| 1       | login    | 2019-05-01    |
| 1       | homepage | 2019-05-01    |
| 1       | logout   | 2019-05-01    |
| 2       | login    | 2019-06-21    |
| 2       | logout   | 2019-06-21    |
| 3       | login    | 2019-01-01    |
| 3       | jobs     | 2019-01-01    |
| 3       | logout   | 2019-01-01    |
| 4       | login    | 2019-06-21    |
| 4       | groups   | 2019-06-21    |
| 4       | logout   | 2019-06-21    |
| 5       | login    | 2019-03-01    |
| 5       | logout   | 2019-03-01    |
| 5       | login    | 2019-06-21    |
| 5       | logout   | 2019-06-21    |
+---------+----------+---------------+

Result table:
+------------+-------------+
| login_date | user_count  |
+------------+-------------+
| 2019-05-01 | 1           |
| 2019-06-21 | 2           |
+------------+-------------+
Note that we only care about dates with non zero user count.
The user with id 5 first logged in on 2019-03-01 so he is not counted on 2019-06-21.




-- # Write your MySQL query statement below
-- # datediff()用来计算时间差
-- # 先计算user 和对应的 first login date 表， 命名为t
-- （
-- select user_id, min(activity_date) as first_login
-- from traffic 
-- where activity = 'login'
-- group by user_id
-- ）t

-- # 然后看t表中，符合90天之内条件的
-- （
-- select user_id, min(activity_date) as first_login
-- from traffic 
-- where activity = 'login'
-- group by user_id
-- ）t
-- where datediff('2019-06-30',first_login ) <= 90

# 然后从得到结果中，分组聚合
select t.first_login as login_date, count(t.user_id) as user_count
from (select user_id, min(activity_date) as first_login
from traffic 
where activity = 'login'
group by user_id) t
where datediff('2019-06-30',first_login ) <= 90
group by login_date
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1112. Highest Grade For Each Student
SQL架构
Table: Enrollments

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

The query result format is in the following example:

Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+

Result table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+

# Write your MySQL query statement below

# 先找出每位学生获得的最高成绩和它所对应的科目，科目成绩并列，取所有并列科目
-- select e.student_id, e.course_id, e.grade
-- from enrollments e
-- where (e.student_id,e.grade) in (
--     select student_id, max(grade) as grade
--     from enrollments
--     group by student_id
-- )

# 然后筛选其中course_id最小的一门

select e.student_id, MIN(e.course_id) AS course_id, e.grade
from enrollments e
where (e.student_id,e.grade) in (select student_id, max(grade) as grade
                                 from enrollments
                                 group by student_id)
group by e.student_id
order by e.student_id asc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1126. Active Businesses
SQL架构
Table: Events

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurences    | int     | 
+---------------+---------+
(business_id, event_type) is the primary key of this table.
Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

Write an SQL query to find all active businesses.

An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

The query result format is in the following example:

Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          |
| 3           | reviews    | 3          |
| 1           | ads        | 11         |
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         |
+-------------+------------+------------+

Result table:
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+ 
Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.


# Write your MySQL
# 求 average occurences of that event type among all businesses,按event_type分组
-- select event_type, avg(occurences) as avg_occ from events group by event_type

# 上表和 events table join
-- select * from events e
-- join (select event_type, avg(occurences) as avg_occ from events group by event_type) t
-- on e.event_type = t.event_type

# 然后可以先筛出那些 occurences > avg occ的记录，然后再按business id 分组，distinct 记录>1
select e.business_id from events e
join (select event_type, avg(occurences) as avg_occ from events group by event_type) t
on e.event_type = t.event_type
where e.occurences > t.avg_occ
group by business_id
having count(distinct e.event_type) > 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1132. Reported Posts II
SQL架构
Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action such as a reason for report or a type of reaction. 
Table: Removals

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| post_id       | int     |
| remove_date   | date    | 
+---------------+---------+
post_id is the primary key of this table.
Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

The query result format is in the following example:

Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 2       | 2019-07-04  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-03  | view   | null   |
| 5       | 2       | 2019-07-03  | report | racism |
| 5       | 5       | 2019-07-03  | view   | null   |
| 5       | 5       | 2019-07-03  | report | racism |
+---------+---------+-------------+--------+--------+

Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 3       | 2019-07-18  |
+---------+-------------+

Result table:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
The other days had no spam reports so the average is (50 + 100) / 2 = 75%
Note that the output is only one number and that we do not care about the remove dates.


# Write your MySQL query statement below


-- 方法一：LEFT JOIN 、 GROUP BY 和 FROM 子查询
-- 思路
-- 主要思想：先计算出每一天被移除的帖子的占比，最后求平均值。

-- 既然要求占比，肯定要求出分子和分母。根据题意可以知道 removals 表中的数据是分子，actions 表中的数据是分母。两个表根据 post_id 可以对应起来。所以可以使用 LEFT JOIN 将两个表结合起来。因为题目要的是每天的数据，所以还需要使用 GROUP BY 将相同日期的数据聚合。最后统计分子和分母的值相除得出结果。

-- 这里还有两个需要注意的点：

-- 因为表中可能存在重复的行，所以有可能同一天有相同的 post_id，但是只需要统计一次，所以要用 DISTINCT 去重。

-- 因为 actions 表是真正需要查询的数据，所以需要使用左连接。

-- SELECT actions.action_date, COUNT(DISTINCT removals.post_id)/COUNT(DISTINCT actions.post_id) AS proportion
-- FROM actions
-- LEFT JOIN removals
-- ON actions.post_id = removals.post_id
-- WHERE extra = 'spam' 
-- GROUP BY actions.action_date

# 拿到每一天的占比后，只需要用 FROM 子查询，将所有的结果求平均值并且四舍五入保留两位有效数字即可。


SELECT ROUND(AVG(a.proportion) * 100, 2) AS average_daily_percent  
FROM (
    SELECT actions.action_date, COUNT(DISTINCT removals.post_id)/COUNT(DISTINCT actions.post_id) AS proportion
    FROM actions
    LEFT JOIN removals
    ON actions.post_id = removals.post_id
    WHERE extra = 'spam' 
    GROUP BY actions.action_date
) a




-- 方法二：LEFT JOIN 和 GROUP BY
-- 思路
-- 主要思想：方法一是直接求出占比的集合，此方法是先求出分子和分母各自的集合，再进行计算并求平均值。
-- 先求出分子的集合：

-- SELECT action_date, COUNT(DISTINCT post_id) AS cnt
-- FROM actions
-- WHERE extra = 'spam' AND post_id IN (SELECT post_id FROM Removals)
-- GROUP BY action_date

-- 再求出分母的集合：

-- SELECT action_date, COUNT(DISTINCT post_id) AS cnt
-- FROM actions
-- WHERE extra = 'spam'
-- GROUP BY action_date


-- 第三步，可能存在有n个spam，但是对应的id和remove表对不上的情况，即0/n，但是上一步会将其排除在外：
-- 这里用完整的日期表left join解决，0/n的情况自动join出null值，在筛选命令中加入ifnull即可。

-- SELECT ROUND(AVG(IFNULL(remove.cnt, 0)/total.cnt) * 100, 2) AS average_daily_percent
-- FROM (
--     SELECT action_date, COUNT(DISTINCT post_id) AS cnt
--     FROM actions
--     WHERE extra = 'spam'
--     GROUP BY action_date
-- ) total
-- LEFT JOIN (
--     SELECT action_date, COUNT(DISTINCT post_id) AS cnt
--     FROM actions
--     WHERE extra = 'spam' AND post_id IN (SELECT post_id FROM Removals)
--     GROUP BY action_date
-- ) remove 
-- ON total.action_date = remove.action_date
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1149. Article Views II
SQL架构
Table: Views

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write an SQL query to find all the people who viewed more than one article on the same date, sorted in ascending order by their id.

The query result format is in the following example:

Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 3          | 4         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+

Result table:
+------+
| id   |
+------+
| 5    |
| 6    |
+------+



# Write your MySQL query statement below
# 需要注意一种情况：同一人在多个不同的日子阅读文章，其中每一日阅读的唯一文章数都大于等于2。
select distinct viewer_id as id
from views 
group by viewer_id, view_date
having count(distinct article_id) >1
order by viewer_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1158. Market Analysis I
SQL架构
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.
Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.
Table: Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key of this table.
 

Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.

The query result format is in the following example:

Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2018-01-01 | Lenovo         |
| 2       | 2018-02-09 | Samsung        |
| 3       | 2018-01-19 | LG             |
| 4       | 2018-05-21 | HP             |
+---------+------------+----------------+

Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2018-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2018-08-04 | 1       | 4        | 2         |
| 5        | 2018-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+

Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+

Result table:
+-----------+------------+----------------+
| buyer_id  | join_date  | orders_in_2019 |
+-----------+------------+----------------+
| 1         | 2018-01-01 | 1              |
| 2         | 2018-02-09 | 2              |
| 3         | 2018-01-19 | 0              |
| 4         | 2018-05-21 | 0              |
+-----------+------------+----------------+

# Write your MySQL query statement below
# 1. 筛选出order table中 每个user 2019年的order数，有的user可能2019年没有order

-- select buyer_id, count(order_id)
-- from orders 
-- where order_date between '2019-01-01' and '2019-12-31'
-- group by buyer_id

# 2. users left join 上表，用ifnull来表示在user却不在上表的user
select u.user_id as buyer_id, u.join_date, ifnull(t.cnt,0) as orders_in_2019
from users u 
left join (select buyer_id, count(order_id) as cnt
from orders 
where order_date between '2019-01-01' and '2019-12-31'
group by buyer_id) t
on u.user_id = t.buyer_id



# 另一种用on的方法！而放在on还会保留ID为3和4的情况且值为null，count(null)结果恒为0
-- select user_id buyer_id, join_date, count(order_id) orders_in_2019
-- from users left join orders
-- on user_id = buyer_id and year(order_date)='2019'
-- group by user_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1164. Product Price at a Given Date
SQL架构
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

The query result format is in the following example:

Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+

Result table:
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+

# Write your MySQL query statement below
# 当change_date <=2019-08-16时, 找到每个product_id对应的change_Date最大时（即按product_id分组时，距离2019-08-16最近时），对应的new price
-- select product_id, new_price
-- from products
-- where (product_id,change_date) in (select product_id, max(change_date) as newdate from products where change_date <= '2019-08-16' group by product_id )

# 找到distinct product_id，和上表左连，如果distinct product id里有id，但上表里没有，则price为10
select distinct p.product_id, ifnull(tmp.new_price,10) as price
from products p
left join (
    select product_id, new_price
    from products
    where (product_id,change_date) in (select product_id, max(change_date) as newdate from products where change_date <= '2019-08-16' group by product_id )
) tmp
on p.product_id = tmp.product_id

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1174. Immediate Food Delivery II
SQL架构
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise its called scheduled.

The first order of a customer is the order with the earliest order date that customer made. It is guaranteed that a customer has exactly one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

The query result format is in the following example:

Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+

Result table:
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.

# Write your MySQL query statement below

# 1.找到各用户的首次订单：首先用GROUP BY customer_id，并选择customer_id和order_date确定每个用户最早的订单时间，在在表中选择所有最早订单数据。 
-- SELECT * FROM Delivery WHERE (customer_id, order_date) in (SELECT customer_id, MIN(order_date) FROM Delivery GROUP BY customer_id);

# 2.从第一步的结果中，寻找两个数据：及时订单数量和总订单数量，并相除得到结果。及时订单数量可以用SUM(order_date = customer_pref_delivery_date ) 来计算。对用总的订单数量，可以用SUM(1)计算，表示每次下一行都加1，无论是否是及时订单。

select round(100 * sum(order_date = customer_pref_delivery_date) / count(*),2) as immediate_percentage
from delivery
where (customer_id, order_date) in (select customer_id, min(order_date) from delivery group by customer_id)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1193. Monthly Transactions I
SQL架构
Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

The query result format is in the following example:

Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+

Result table:
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+

# Write your MySQL query statement below
# 知识点：date_format函数：date_format(trans_date,"%Y-%m") as month
select date_format(trans_date,"%Y-%m") as month, country,
count(id) as trans_count,
count(if(state = 'approved',1,null)) as approved_count,
sum(amount) as trans_total_amount,
sum(if(state = 'approved',amount,0)) as approved_total_amount
from Transactions
group by month, country
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1204. Last Person to Fit in the Elevator
SQL架构
Table: Queue

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for an elevator.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
 

The maximum weight the elevator can hold is 1000.

Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

The query result format is in the following example:

Queue table
+-----------+-------------------+--------+------+
| person_id | person_name       | weight | turn |
+-----------+-------------------+--------+------+
| 5         | George Washington | 250    | 1    |
| 3         | John Adams        | 350    | 2    |
| 6         | Thomas Jefferson  | 400    | 3    |
| 2         | Will Johnliams    | 200    | 4    |
| 4         | Thomas Jefferson  | 175    | 5    |
| 1         | James Elephant    | 500    | 6    |
+-----------+-------------------+--------+------+

Result table
+-------------------+
| person_name       |
+-------------------+
| Thomas Jefferson  |
+-------------------+

Queue table is ordered by turn in the example for simplicity.
In the example George Washington(id 5), John Adams(id 3) and Thomas Jefferson(id 6) will enter the elevator as their weight sum is 250 + 350 + 400 = 1000.
Thomas Jefferson(id 6) is the last person to fit in the elevator because he has the last turn in these three people.

# Write your MySQL query statement below
# 自链接， 用q1.turn >= q2.turn作为条件筛选出累积的人，在用sum判断重量 最后排序选出最后一个进电梯的人
select q1.person_name
from queue q1, queue q2
where q1.turn >= q2.turn
group by q1.person_id
having sum(q2.weight) <= 1000
order by q1.turn desc
limit 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1205. Monthly Transactions II
SQL架构
Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| charge_date    | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 101  | US      | approved | 1000   | 2019-05-18 |
| 102  | US      | declined | 2000   | 2019-05-19 |
| 103  | US      | approved | 3000   | 2019-06-10 |
| 104  | US      | approved | 4000   | 2019-06-13 |
| 105  | US      | approved | 5000   | 2019-06-15 |
+------+---------+----------+--------+------------+

Chargebacks table:
+------------+------------+
| trans_id   | trans_date |
+------------+------------+
| 102        | 2019-05-29 |
| 101        | 2019-06-30 |
| 105        | 2019-09-18 |
+------------+------------+

Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+---------+----------------+-----------------+-------------------+--------------------+
| 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
| 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
| 2019-09  | US      | 0              | 0               | 1                 | 5000               |
+----------+---------+----------------+-----------------+-------------------+--------------------+


# Write your MySQL query statement below

# 月份可用date_format(t.trans_date,'%Y-%m')

-- Union：对两个结果集进行并集操作，不包括重复行，同时进行默认规则的排序；
-- Union All：对两个结果集进行并集操作，包括重复行，不进行排序；

-- 这道题的的思路就是
-- 先查出 每个月和每个国家/地区的已批准交易的数量及其总金额,tag 为0

-- select country,state,amount,date_format(t.trans_date,'%Y-%m') as month,0  as tag
-- from Transactions t  
-- where state!='declined'

-- 再查出 每个月和每个国家/地区的退单(chargebacks)的数量及其总金额，tag为1
-- 进行合并，只靠左右关联是完成不了的， 因为它要求Chargebacks里面的trans_date也要计入进去，

-- select country,state,amount,date_format(c.trans_date,'%Y-%m') as month,1 as tag
-- from Transactions t   
-- right join Chargebacks c 
-- on t.id=c.trans_id

-- 进行合并，只靠左右关联是完成不了的， 因为它要求Chargebacks里面的trans_date也要计入进去，
-- 注意合并的时候 不要用Union 这个会将重复行覆盖掉，判断是否重复行就是 国家 年月 金额 均一致 这是很容易发生的
-- select country,state,amount,date_format(c.trans_date,'%Y-%m') as month,1 as tag
-- from Transactions t   
-- right join Chargebacks c on t.id=c.trans_id
-- union all
-- select country,state,amount,date_format(t.trans_date,'%Y-%m') as month,0  as tag
-- from Transactions t  where state!='declined'

-- 最后count统计，sum求和，分组排序

-- 这里用了tag去区分 是交易还是退单 ，方便合并之后统计



select month,
country,
count(case when tag=0 then 1 else null end ) as approved_count,
sum(case when tag=0 then amount else 0 end ) as approved_amount,
count(case when tag=1 then 1 else null end  ) as chargeback_count,
sum(case when  tag=1 then amount else 0 end ) as chargeback_amount
from(
select country,state,amount,date_format(c.trans_date,'%Y-%m') as month,1 as tag
from Transactions t   
right join Chargebacks c on t.id=c.trans_id
union all
select country,state,amount,date_format(t.trans_date,'%Y-%m') as month,0  as tag
from Transactions t  where state!='declined'
) a 
group by month, country 
order by month, country
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1212. Team Scores in Football Tournament
SQL架构
Table: Teams

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the primary key of this table.
Each row of this table represents a single football team.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     | 
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the teams table (team_id) and they scored host_goals and guest_goals goals respectively.
 

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).
Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

The query result format is in the following example:

Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+


# Write your MySQL query statement below
# 作为host_team的 和 作为guest_team 进行union
-- 具体：分成两部分，先算主场作战的得分，再算客场作战得分
-- 使用case语句按照题目要求进行计分
-- 注意：要使用外连接，因为有些队可能没有主场比赛或者客场比赛，
-- 此时计分为0
-- 两部分算好后，使用union进行合并，
-- 注意：要是用union all ，如果一个对的主客场得分相同，
-- 只用union会过滤掉其中一条记录，发生错误
-- 最后再从union all的结果中分组，对两部分分数求和
-- 再按照排序要求得出答案


-- select team_id,team_name, m1.*, 
-- (case when m1.host_goals > m1.guest_goals then 3 when m1.host_goals = m1.guest_goals then 1 else 0 end )
-- as point
-- from teams
-- left join matches m1
-- on teams.team_id = m1.host_team
-- union all
-- select team_id,team_name,m2.*,
-- (case when m2.host_goals < m2.guest_goals then 3 when m2.host_goals = m2.guest_goals then 1 else 0 end )
-- as point
-- from teams
-- left join matches m2
-- on teams.team_id = m2.guest_team

# 分组加总
select tmp.team_id, tmp.team_name, sum(tmp.point) as num_points
from (select team_id,team_name, m1.*, 
(case when m1.host_goals > m1.guest_goals then 3 when m1.host_goals = m1.guest_goals then 1 else 0 end )
as point
from teams
left join matches m1
on teams.team_id = m1.host_team
union all
select team_id,team_name,m2.*,
(case when m2.host_goals < m2.guest_goals then 3 when m2.host_goals = m2.guest_goals then 1 else 0 end )
as point
from teams
left join matches m2
on teams.team_id = m2.guest_team) tmp
group by tmp.team_id
order by num_points desc, team_id asc


# 或者


-- select t.team_id,t.team_name,
-- sum(case when m.host_goals > m.guest_goals then 3 
--       when m.host_goals = m.guest_goals then 1
--       else 0 end) num_points
-- from teams t 
-- left join
-- (select host_team, guest_team, host_goals, guest_goals
-- from matches
-- union all
-- select guest_team host_team, host_team guest_team, guest_goals host_goals, host_goals guest_goals
-- from matches) m
-- on m.host_team = t.team_id
-- group by t.team_id
-- order by num_points desc, t.team_id asc
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1264. Page Recommendations
SQL架构
Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
 

Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key for this table.
Each row of this table indicates that user_id likes page_id.
 

Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

Return result table in any order without duplicates.

The query result format is in the following example:

Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
 
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+

Result table:
+------------------+
| recommended_page |
+------------------+
| 23               |
| 24               |
| 56               |
| 33               |
| 77               |
+------------------+
User one is friend with users 2, 3, 4 and 6.
Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
Page 77 is suggested from both user 2 and user 3.
Page 88 is not suggested because user 1 already likes it.

# Write your MySQL query statement below
# 注意互为朋友关系，所以用union选取1号的所有朋友id
-- select user2_id from Friendship  where user1_id = 1
-- union
-- select user1_id from Friendship  where user2_id = 1

# 找朋友们喜欢的page,排除1号自己喜欢的
select distinct page_id as recommended_page
from likes
where user_id in (
    select user2_id from Friendship  where user1_id = 1
    union
    select user1_id from Friendship  where user2_id = 1)
and page_id not in (select page_id from likes where user_id = 1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1270. All People Report to the Given Manager
SQL架构
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.
 

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 dont report their work to head of company directly or indirectly. 


# Write your MySQL query statement below
# 自连啊！！
# 注意是不超过3个manager，一个左连接是2个manager= =



select distinct e1.employee_id
from Employees e1 
left join Employees e2 on e1.manager_id = e2.employee_id
left join Employees e3 on e2.manager_id = e3.employee_id
where e3.manager_id = 1 and e1.employee_id <>1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1285. Find the Start and End Number of Continuous Ranges
SQL架构
Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Since some IDs have been removed from Logs. Write an SQL query to find the start and end number of continuous ranges in table Logs.

Order the result table by start_id.

The query result format is in the following example:

Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+

Result table:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing in the table.
Number 10 is contained in the table.

# Write your MySQL query statement below
# 完全不会啊。。。。

-- 思路：
-- 从结果样例来看，分别需要输出连续数列的头和尾。
-- 那么，我们需要加工并获取一个连续数列的头，以及其对应的数列（如1的123，后续用max来取尾巴）或者直接是数列的尾巴。另外还要面对10这种单个数字存在。
-- 这里分别获取头和尾比较简单：
-- 数列的头的获取：
-- select log_id from logs where log_id-1 not in (select * from logs)
-- 可以得到1,7,10. 因为连续数列中 前一个不存在的话，就是头了（也包括了单个数字的情况）
-- 数列的尾的获取：
-- select log_id from logs where log_id+1 not in (select * from logs)
-- 可以得到3,8,10. 因为连续数列中 后一个不存在的话，就是尾了（也包括了单个数字的情况）
-- 自连接+where获取结果：
-- 如果让前两行数据进行笛卡尔积，并且限制尾的数字必须不小于头的数字的话，就可以轻松得出结果。

select a.log_id as START_ID ,min(b.log_id) as END_ID from 
(select log_id from logs where log_id-1 not in (select * from logs)) a,
(select log_id from logs where log_id+1 not in (select * from logs)) b
where b.log_id>=a.log_id
group by a.log_id


# 另一种大神解法：
SELECT
    MIN(log_id)start_id, MAX(log_id) end_id
FROM  
    (SELECT log_id, ROW_NUMBER() OVER(ORDER BY log_id)  -log_id AS Grp FROM Logs)
GROUP BY Grp
ORDER BY MIN(log_id)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1308. Running Total for Different Genders
SQL架构
Table: Scores

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| player_name   | varchar |
| gender        | varchar |
| day           | date    |
| score_points  | int     |
+---------------+---------+
(gender, day) is the primary key for this table.
A competition is held between females team and males team.
Each row of this table indicates that a player_name and with gender has scored score_point in someday.
Gender is 'F' if the player is in females team and 'M' if the player is in males team.
 

Write an SQL query to find the total score for each gender at each day.

Order the result table by gender and day

The query result format is in the following example:

Scores table:
+-------------+--------+------------+--------------+
| player_name | gender | day        | score_points |
+-------------+--------+------------+--------------+
| Aron        | F      | 2020-01-01 | 17           |
| Alice       | F      | 2020-01-07 | 23           |
| Bajrang     | M      | 2020-01-07 | 7            |
| Khali       | M      | 2019-12-25 | 11           |
| Slaman      | M      | 2019-12-30 | 13           |
| Joe         | M      | 2019-12-31 | 3            |
| Jose        | M      | 2019-12-18 | 2            |
| Priya       | F      | 2019-12-31 | 23           |
| Priyanka    | F      | 2019-12-30 | 17           |
+-------------+--------+------------+--------------+
Result table:
+--------+------------+-------+
| gender | day        | total |
+--------+------------+-------+
| F      | 2019-12-30 | 17    |
| F      | 2019-12-31 | 40    |
| F      | 2020-01-01 | 57    |
| F      | 2020-01-07 | 80    |
| M      | 2019-12-18 | 2     |
| M      | 2019-12-25 | 13    |
| M      | 2019-12-30 | 26    |
| M      | 2019-12-31 | 29    |
| M      | 2020-01-07 | 36    |
+--------+------------+-------+
For females team:
First day is 2019-12-30, Priyanka scored 17 points and the total score for the team is 17.
Second day is 2019-12-31, Priya scored 23 points and the total score for the team is 40.
Third day is 2020-01-01, Aron scored 17 points and the total score for the team is 57.
Fourth day is 2020-01-07, Alice scored 23 points and the total score for the team is 80.
For males team:
First day is 2019-12-18, Jose scored 2 points and the total score for the team is 2.
Second day is 2019-12-25, Khali scored 11 points and the total score for the team is 13.
Third day is 2019-12-30, Slaman scored 13 points and the total score for the team is 26.
Fourth day is 2019-12-31, Joe scored 3 points and the total score for the team is 29.
Fifth day is 2020-01-07, Bajrang scored 7 points and the total score for the team is 36.


# Write your MySQL query statement below
select s1.gender,s1.day, sum(s2.score_points)as total
from scores s1, scores s2
where s1.gender = s2.gender and s1.day >= s2.day
group by s1.gender,s1.day
order by s1.gender,s1.day
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1321. Restaurant Growth
SQL架构
Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) have visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Write an SQL query to compute moving average of how much customer paid in a 7 days window (current day + 6 days before) .

The query result format is in the following example:

Return result table ordered by visited_on.

average_amount should be rounded to 2 decimal places, all dates are in the format ('YYYY-MM-DD').

 

Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+

Result table:
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+

1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86




# Write your MySQL query statement below
# 每天至少一个用户，有可能多于一个，所以每个窗口的记录可能多于7条，但是分母仍然是为7
# 自连接 datediff(date 1 , date 2) <=6, and datediff(ate 1 , date 2) >= 0
# 如何选择窗口期的结束点？保证窗口的结束点-6days 也在customer里

-- select c1.visited_on, sum(c2.amount)as amount, round(sum(c2.amount)/7,2) as average_amount
-- from customer c1, customer c2
-- where datediff(c1.visited_on,c2.visited_on) <= 6 and datediff(c1.visited_on,c2.visited_on) >= 0
-- group by c1.visited_on
-- having DATE_ADD(c1.visited_on,INTERVAL -6 DAY)in (select visited_on from Customer) 

# 以上解法错误，因为我们可以发现有两个1.10，所以group by之后，相当于加总了两次！！！！



# Write your MySQL query statement below
SELECT
	a.visited_on,
	sum( b.amount ) AS amount,
	round(sum( b.amount ) / 7, 2 ) AS average_amount 
FROM
	( SELECT DISTINCT visited_on FROM customer ) a JOIN customer b 
 	ON datediff( a.visited_on, b.visited_on ) BETWEEN 0 AND 6 
GROUP BY
	a.visited_on
having 
    DATE_ADD(a.visited_on,INTERVAL -6 DAY)in (select visited_on from Customer)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1341. Movie Rating
SQL架构
Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key for this table.
title is the name of the movie.
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key for this table.
Table: Movie_Rating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key for this table.
This table contains the rating of a movie by a user in their review.
created_at is the users review date. 
 

Write the following SQL query:

Find the name of the user who has rated the greatest number of the movies.
In case of a tie, return lexicographically smaller user name.

Find the movie name with the highest average rating in February 2020.
In case of a tie, return lexicographically smaller movie name.

Query is returned in 2 rows, the query result format is in the folowing example:

Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+

Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+

Movie_Rating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+

Result table:
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+

Daniel and Maria have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.


# Write your MySQL query statement below
# 注意Query is returned in 2 rows, 那么分别写查询，两张表的查询结果需要分别用括号括起来,查询结果用union all连接
(select u.name as results
from users u 
right join Movie_Rating mr 
on u.user_id = mr.user_id
group by mr.user_id
order by count(movie_id) desc, u.name asc
limit 1)
union all
(select m.title as results
from Movie_Rating mr
left join movies m
on mr.movie_id = m.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by mr.movie_id
order by avg(rating) desc, m.title asc 
limit 1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1355. Activity Participants
SQL架构
Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.
Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.
 

Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

The query result format is in the following example:

Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)



# Write your MySQL query statement 
select activity
from friends  
group by activity
having count(*) not in ((select count(*) from friends group by activity order by count(*) asc limit 1), (select count(*) from friends group by activity order by count(*) desc limit 1))


# 另一种写法：some用法学会了 (>some可以和>any替换）（=any可以替换in)
# SQL Server中有三个关键字可以修改比较运算符：ALL、ANY和SOME，其中ANY和SOME等价。
# ALL：是所有，表示全部都满足才返回true
# ANY/SOME：是任意一个 ，表示有任何一个满足就返回true

-- SELECT activity 
-- FROM Friends 
-- GROUP BY activity
-- HAVING 
-- COUNT(*)>SOME(SELECT COUNT(*) FROM Friends GROUP BY activity) 
-- AND 
-- COUNT(*)<SOME(SELECT COUNT(*) FROM Friends GROUP BY activity)

# 举例: test 1表 num 2,3,4 , test 2表 num 1,2,3,4,5
-- ALL使用示例
-- 示例1

-- SELECT Num FROM Test2
-- WHERE Num > ALL (SELECT Num FROM Test1)

-- 结果为 5

-- 示例2

-- SELECT Num  FROM Test2
-- WHERE Num < ALL (SELECT Num FROM Test1)
-- 结果为：1

-- 从上面的结果我们可以看出，只有Test2中的1才是小于Test1中的所有数。

-- ANY/SOME使用示例
-- 示例

-- SELECT Num FROM Test2
-- WHERE Num > ANY (SELECT Num FROM Test1)

-- SELECT Num FROM Test2
-- WHERE Num > SOME (SELECT Num FROM Test1)


-- 他们的结果均为：3，4，5


-- 从上面的结果我们可以看出，ANY和SOME是等价的，而且Test2中的任何一个数都满足大于Test1中的数。比如Test2中的3就大于2



-- "=ANY"与"IN"相同
-- 示例

-- SELECT Num FROM Test2
-- WHERE Num = ANY (SELECT Num FROM Test1)

-- SELECT Num FROM Test2
-- WHERE Num IN (SELECT Num FROM Test1)
-- 他们的结果均为：2，3，4


-- 表示Test1中的任何一个数都存在于Test2中



-- "<>ALL"与"NOT IN"相同
-- 示例

-- SELECT Num FROM Test2
-- WHERE Num <> ALL (SELECT Num FROM Test1)

-- SELECT Num FROM Test2
-- WHERE Num NOT IN (SELECT Num FROM Test1)


-- 他们的结果均为：1，5


-- 表示Test2中的结果都不存在与Test1中
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1364. Number of Trusted Contacts of a Customer
SQL架构
Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
| email         | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the email of a customer of an online shop.
 

Table: Contacts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | id      |
| contact_name  | varchar |
| contact_email | varchar |
+---------------+---------+
(user_id, contact_email) is the primary key for this table.
Each row of this table contains the name and email of one contact of customer with user_id.
This table contains information about people each customer trust. The contact may or may not exist in the Customers table.

 

Table: Invoices

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| invoice_id   | int     |
| price        | int     |
| user_id      | int     |
+--------------+---------+
invoice_id is the primary key for this table.
Each row of this table indicates that user_id has an invoice with invoice_id and a price.
 

Write an SQL query to find the following for each invoice_id:

customer_name: The name of the customer the invoice is related to.
price: The price of the invoice.
contacts_cnt: The number of contacts related to the customer.
trusted_contacts_cnt: The number of contacts related to the customer and at the same time they are customers to the shop. (i.e His/Her email exists in the Customers table.)
Order the result table by invoice_id.

The query result format is in the following example:

Customers table:
+-------------+---------------+--------------------+
| customer_id | customer_name | email              |
+-------------+---------------+--------------------+
| 1           | Alice         | alice@leetcode.com |
| 2           | Bob           | bob@leetcode.com   |
| 13          | John          | john@leetcode.com  |
| 6           | Alex          | alex@leetcode.com  |
+-------------+---------------+--------------------+
Contacts table:
+-------------+--------------+--------------------+
| user_id     | contact_name | contact_email      |
+-------------+--------------+--------------------+
| 1           | Bob          | bob@leetcode.com   |
| 1           | John         | john@leetcode.com  |
| 1           | Jal          | jal@leetcode.com   |
| 2           | Omar         | omar@leetcode.com  |
| 2           | Meir         | meir@leetcode.com  |
| 6           | Alice        | alice@leetcode.com |
+-------------+--------------+--------------------+
Invoices table:
+------------+-------+---------+
| invoice_id | price | user_id |
+------------+-------+---------+
| 77         | 100   | 1       |
| 88         | 200   | 1       |
| 99         | 300   | 2       |
| 66         | 400   | 2       |
| 55         | 500   | 13      |
| 44         | 60    | 6       |
+------------+-------+---------+
Result table:
+------------+---------------+-------+--------------+----------------------+
| invoice_id | customer_name | price | contacts_cnt | trusted_contacts_cnt |
+------------+---------------+-------+--------------+----------------------+
| 44         | Alex          | 60    | 1            | 1                    |
| 55         | John          | 500   | 0            | 0                    |
| 66         | Bob           | 400   | 2            | 0                    |
| 77         | Alice         | 100   | 3            | 2                    |
| 88         | Alice         | 200   | 3            | 2                    |
| 99         | Bob           | 300   | 2            | 0                    |
+------------+---------------+-------+--------------+----------------------+
Alice has three contacts, two of them are trusted contacts (Bob and John).
Bob has two contacts, none of them is a trusted contact.
Alex has one contact and it is a trusted contact (Alice).
John doesnt have any contacts.


# Write your MySQL query statement below
select i.invoice_id, tmp.customer_name, i.price, tmp.contacts_cnt,tmp.trusted_contacts_cnt
from invoices i 
left join ( 
    select cus.customer_id, cus.customer_name, count(con.user_id) as contacts_cnt, sum(case when con.contact_name in (select customer_name from customers) then 1 else 0 end) as trusted_contacts_cnt
    from customers cus
    left join contacts con
    on cus.customer_id = con.user_id
    group by cus.customer_id) tmp
on i.user_id = tmp.customer_id
order by i.invoice_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1393. Capital Gain/Loss
SQL架构
Table: Stocks

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| stock_name    | varchar |
| operation     | enum    |
| operation_day | int     |
| price         | int     |
+---------------+---------+
(stock_name, day) is the primary key for this table.
The operation column is an ENUM of type ('Sell', 'Buy')
Each row of this table indicates that the stock which has stock_name had an operation on the day operation_day with the price.
It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation in a previous day.
 

Write an SQL query to report the Capital gain/loss for each stock.

The capital gain/loss of a stock is total gain or loss after buying and selling the stock one or many times.

Return the result table in any order.

The query result format is in the following example:

Stocks table:
+---------------+-----------+---------------+--------+
| stock_name    | operation | operation_day | price  |
+---------------+-----------+---------------+--------+
| Leetcode      | Buy       | 1             | 1000   |
| Corona Masks  | Buy       | 2             | 10     |
| Leetcode      | Sell      | 5             | 9000   |
| Handbags      | Buy       | 17            | 30000  |
| Corona Masks  | Sell      | 3             | 1010   |
| Corona Masks  | Buy       | 4             | 1000   |
| Corona Masks  | Sell      | 5             | 500    |
| Corona Masks  | Buy       | 6             | 1000   |
| Handbags      | Sell      | 29            | 7000   |
| Corona Masks  | Sell      | 10            | 10000  |
+---------------+-----------+---------------+--------+

Result table:
+---------------+-------------------+
| stock_name    | capital_gain_loss |
+---------------+-------------------+
| Corona Masks  | 9500              |
| Leetcode      | 8000              |
| Handbags      | -23000            |
+---------------+-------------------+
Leetcode stock was bought at day 1 for 1000$ and was sold at day 5 for 9000$. Capital gain = 9000 - 1000 = 8000$.
Handbags stock was bought at day 17 for 30000$ and was sold at day 29 for 7000$. Capital loss = 7000 - 30000 = -23000$.
Corona Masks stock was bought at day 1 for 10$ and was sold at day 3 for 1010$. It was bought again at day 4 for 1000$ and was sold at day 5 for 500$. At last, it was bought at day 6 for 1000$ and was sold at day 10 for 10000$. Capital gain/loss is the sum of capital gains/losses for each ('Buy' --> 'Sell') operation = (1010 - 10) + (500 - 1000) + (10000 - 1000) = 1000 - 500 + 9000 = 9500$.


# Write your MySQL query statement below
select tmp.stock_name, sum(tmp.net) as capital_gain_loss
from (
    select *, 
    (case when operation = 'Buy' then -1* price else price end ) as net
    from stocks
) tmp
group by tmp.stock_name

# 可以不用tmp表，
-- select stock_name,
-- sum(case when operation='buy' then -price
-- else  price  end ) as 'capital_gain_loss'
-- from Stocks
-- group by stock_name
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1398. Customers Who Bought Products A and B but Not C
SQL架构
Table: Customers

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
customer_id is the primary key for this table.
customer_name is the name of the customer.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
order_id is the primary key for this table.
customer_id is the id of the customer who bought the product "product_name".
 

Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

Return the result table ordered by customer_id.

The query result format is in the following example.

 

Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+

Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+

Result table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
Only the customer_id with id 3 bought the product A and B but not the product C.


# Write your MySQL query statement below
select c.customer_id,c.customer_name
from customers c 
where c.customer_id not in (select distinct customer_id from orders where product_name = 'C')
and c.customer_id in (select distinct customer_id from orders where product_name = 'A' )
and c.customer_id in (select distinct customer_id from orders where product_name = 'B')

# 或者用having 筛选总数符合要求的消费者 不知道为啥我老想着用product_name='A'做条件直接判断..... 感觉写题写晕了要 having中要用聚合函数做判断

-- select o.customer_id, customer_name
-- from orders o, customers c
-- where o.customer_id = c.customer_id
-- group by o.customer_id
-- having  sum(product_name='A') > 0 and sum(product_name='B') > 0 and sum(product_name='C') = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1421. NPV Queries
SQL架构
Table: NPV

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| year          | int     |
| npv           | int     |
+---------------+---------+
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory and the corresponding net present value.
 

Table: Queries

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| year          | int     |
+---------------+---------+
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory query.
 

Write an SQL query to find the npv of all each query of queries table.

Return the result table in any order.

The query result format is in the following example:

NPV table:
+------+--------+--------+
| id   | year   | npv    |
+------+--------+--------+
| 1    | 2018   | 100    |
| 7    | 2020   | 30     |
| 13   | 2019   | 40     |
| 1    | 2019   | 113    |
| 2    | 2008   | 121    |
| 3    | 2009   | 12     |
| 11   | 2020   | 99     |
| 7    | 2019   | 0      |
+------+--------+--------+

Queries table:
+------+--------+
| id   | year   |
+------+--------+
| 1    | 2019   |
| 2    | 2008   |
| 3    | 2009   |
| 7    | 2018   |
| 7    | 2019   |
| 7    | 2020   |
| 13   | 2019   |
+------+--------+

Result table:
+------+--------+--------+
| id   | year   | npv    |
+------+--------+--------+
| 1    | 2019   | 113    |
| 2    | 2008   | 121    |
| 3    | 2009   | 12     |
| 7    | 2018   | 0      |
| 7    | 2019   | 0      |
| 7    | 2020   | 30     |
| 13   | 2019   | 40     |
+------+--------+--------+

The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
The npv values of all other queries can be found in the NPV table.

# Write your MySQL query statement 
select q.id,q.year, ifnull(n.NPV,0) as npv
from Queries q
left join NPV n
on (q.id,q.year)  = (n.id,n.year) 

# 或者
-- select q.id,q.year,ifnull(n.npv,0) npv from queries q
-- left join npv n on n.id=q.id and n.year = q.year

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1440. Evaluate Boolean Expression
SQL架构
Table Variables:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| name          | varchar |
| value         | int     |
+---------------+---------+
name is the primary key for this table.
This table contains the stored variables and their values.
 

Table Expressions:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| left_operand  | varchar |
| operator      | enum    |
| right_operand | varchar |
+---------------+---------+
(left_operand, operator, right_operand) is the primary key for this table.
This table contains a boolean expression that should be evaluated.
operator is an enum that takes one of the values ('<', '>', '=')
The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

Write an SQL query to evaluate the boolean expressions in Expressions table.

Return the result table in any order.

The query result format is in the following example.

Variables table:
+------+-------+
| name | value |
+------+-------+
| x    | 66    |
| y    | 77    |
+------+-------+

Expressions table:
+--------------+----------+---------------+
| left_operand | operator | right_operand |
+--------------+----------+---------------+
| x            | >        | y             |
| x            | <        | y             |
| x            | =        | y             |
| y            | >        | x             |
| y            | <        | x             |
| x            | =        | x             |
+--------------+----------+---------------+

Result table:
+--------------+----------+---------------+-------+
| left_operand | operator | right_operand | value |
+--------------+----------+---------------+-------+
| x            | >        | y             | false |
| x            | <        | y             | true  |
| x            | =        | y             | false |
| y            | >        | x             | true  |
| y            | <        | x             | false |
| x            | =        | x             | true  |
+--------------+----------+---------------+-------+
As shown, you need find the value of each boolean exprssion in the table using the variables table.

# Write your MySQL query statement below
# 两次左连！！
-- select *
-- from expressions e
-- left join Variables v1 on v1.name = e.left_operand 
-- left join Variables v2 on v2.name = e.right_operand

select e.left_operand,e.operator,e.right_operand,
case e.operator
    when '>' then if(v1.value>v2.value,'true','false')
    when '<' then if(v1.value<v2.value,'true','false')
    else  if(v1.value=v2.value,'true','false')
end value
from Expressions e
left join Variables v1 on v1.name = e.left_operand 
left join Variables v2 on v2.name = e.right_operand

# 思路清晰，自愧不如


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1445. Apples & Oranges
SQL架构
Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date,fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.
 

Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format ('YYYY-MM-DD').

The query result format is in the following example:

 

Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+

Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).


# Write your MySQL query statement below
# 要考虑某天只有apple，或只有orange的情况
-- (select s1.sale_date, (s1.sold_num - s2.sold_num)as diff
-- from sales s1
-- left join sales s2
-- on s1.sale_date = s2.sale_date and s1.fruit <> s2.fruit
-- where s1.fruit = 'apples'
-- group by s1.sale_date)

# 上述忽略了某天只有orange的情况 union
(select s1.sale_date, (s1.sold_num - s2.sold_num)as diff
from sales s1
left join sales s2
on s1.sale_date = s2.sale_date and s1.fruit <> s2.fruit
where s1.fruit = 'apples'
group by s1.sale_date)
union all
(select s1.sale_date, -s1.sold_num as diff
from sales s1
left join sales s2
on s1.sale_date = s2.sale_date and s1.fruit <> s2.fruit
where s1.fruit = 'oranges' and s2.fruit is null
group by s1.sale_date)


# 另一种方法，更简便，还是对group by理解不深啊！！！！！！
select sale_date, 
sum(case fruit when 'apples' then sold_num when 'oranges' then -sold_num end) as diff
from Sales
group by sale_date
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1454. Active Users
SQL架构
Table Accounts:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
the id is the primary key for this table.
This table contains the account id and the user name of each account.
 

Table Logins:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Write an SQL query to find the id and the name of active users.

Active users are those who logged in to their accounts for 5 or more consecutive days.

Return the result table ordered by the id.

The query result format is in the following example:

Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+

Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+

Result table:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.
Follow up question:
Can you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days?


select id,name
from accounts
where id in (
    select distinct a.id
    from Logins a, Logins b, Logins c, Logins d, Logins e
    where a.id = b.id
    and b.id=c.id
    and c.id=d.id
    and d.id=e.id
    and datediff(b.login_date, a.login_date) =1
    and datediff(c.login_date, b.login_date) =1
    and datediff(d.login_date, c.login_date) =1
    and datediff(e.login_date, d.login_date) =1
)
order by id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

571. Find Median Given Frequency of Numbers
SQL架构
The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median.


# Write your MySQL query statement below
# 还是那个思路，该中位数出现的频率 >= 大于他的数出现的频率 与 小于他的数出现的频率 之差 的绝对值
# 先自联，
select *
from numbers a
left join numbers b
on a.number > b.number
order by a.number

# 然后计算小于他的数的frequency，大于他的数出现的频率=总频率 - 小于他的数出现的频率 - 他自己本身出现的频率
# 注意left join时，最小的数匹配的为null,在计算时要处理
select a.number, abs((select sum(Frequency) from numbers) - 2*ifnull(sum(b.Frequency),0) - a.frequency) as r
from numbers a
left join numbers b
on a.number > b.number
group by a.number


# 根据思路进行比较
# 注意，还要取平均值。。。绝了
select avg(tmp.number) as median
from (
    select a.number, a.Frequency,abs((select sum(Frequency) from numbers) - 2*ifnull(sum(b.Frequency),0) - a.frequency )as r
    from numbers a
    left join numbers b
    on a.number > b.number
    group by a.number
) tmp
where tmp.Frequency >= tmp.r




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

579. Find Cumulative Salary of an Employee
SQL架构
The Employee table holds the salary information in a year.

Write a SQL to get the cumulative sum of an employees salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

Example
Input

| Id | Month | Salary |
|----|-------|--------|
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |
Output
| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
 

Explanation
Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'
So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.

| Id | Month | Salary |
|----|-------|--------|
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
Employee '2' only has one salary record (month '1') except its most recent month '2'.
| Id | Month | Salary |
|----|-------|--------|
| 2  | 1     | 20     |
 

Employ '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as following.
| Id | Month | Salary |
|----|-------|--------|
| 3  | 3     | 100    |
| 3  | 2     | 40     |



# Write your MySQL query statement below
# 还是自恋表用的不熟啊！
# "三个月内的累计薪水" ,这句话开始我是理解为，如果有个用户存在1,2,3,4,5,6月的薪水记录，那么最终结果只会包含这个用户的3,4,5月的递增和数据，其实这样理解是错误的，正确的理解：如果有个用户存在1,2,3,4,5,6个月的薪水记录，那么应该计算的方式是，5月的递增和应该来自于3,4,5这几个月的薪水记录，4月份的递增和应该来自于2,3,4月的薪水记录，3月份的递增和应该来自于1,2,3月的薪水记录，2月份的递增和应该来自于1,2月的薪水记录，1月的递增和应该来自于1月份的薪水记录，就是这样，题所给的案例并没有描述出这样的用意，容易开头踩坑。 */

select e1.id, e1.month, sum(e2.salary) as salary
from employee e1, employee e2
where e1.id =e2.id
and e1.month >= e2.month
and e1.month - e2.month <=2
and (e1.id, e1.month) not in (select id,max(month) from employee group by id )
group by e1.id,e1.month
order by e1.id,month desc



/* Write your PL/SQL query statement below */
/* 窗口 注意题目要求是三个月的总额= =所以要加 ROWS 2 PRECEDING)
"三个月内的累计薪水" ,这句话开始我是理解为，如果有个用户存在1,2,3,4,5,6月的薪水记录，那么最终结果只会包含这个用户的3,4,5月的递增和数据，其实这样理解是错误的，正确的理解：如果有个用户存在1,2,3,4,5,6个月的薪水记录，那么应该计算的方式是，5月的递增和应该来自于3,4,5这几个月的薪水记录，4月份的递增和应该来自于2,3,4月的薪水记录，3月份的递增和应该来自于1,2,3月的薪水记录，2月份的递增和应该来自于1,2月的薪水记录，1月的递增和应该来自于1月份的薪水记录，就是这样，题所给的案例并没有描述出这样的用意，容易开头踩坑。 */

SELECT Id, Month, Salary
FROM (SELECT Id, Month, SUM(Salary) OVER (PARTITION BY Id ORDER BY Month ROWS 2 PRECEDING) AS Salary, rank() OVER (PARTITION BY Id ORDER BY Month DESC) AS r
      FROM Employee) t
WHERE r > 1
ORDER BY Id, Month DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
615. Average Salary: Departments VS Company
SQL架构
Given two tables as below, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the companys average salary.
 

Table: salary
| id | employee_id | amount | pay_date   |
|----|-------------|--------|------------|
| 1  | 1           | 9000   | 2017-03-31 |
| 2  | 2           | 6000   | 2017-03-31 |
| 3  | 3           | 10000  | 2017-03-31 |
| 4  | 1           | 7000   | 2017-02-28 |
| 5  | 2           | 6000   | 2017-02-28 |
| 6  | 3           | 8000   | 2017-02-28 |
 

The employee_id column refers to the employee_id in the following table employee.
 

| employee_id | department_id |
|-------------|---------------|
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
 

So for the sample data above, the result is:
 

| pay_month | department_id | comparison  |
|-----------|---------------|-------------|
| 2017-03   | 1             | higher      |
| 2017-03   | 2             | lower       |
| 2017-02   | 1             | same        |
| 2017-02   | 2             | same        |
 

Explanation
 

In March, the companys average salary is (9000+6000+10000)/3 = 8333.33...
 

The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
 

The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
 

With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.





# Write your MySQL query statement below
select t1.pay_month, t1.department_id, 
(case 
    when t1.department_avg>t2.company_avg then 'higher'
    when t1.department_avg<t2.company_avg then 'lower'
    else 'same'
    end ) as comparison
from
(
    select e.department_id, date_format(s.pay_date,'%Y-%m') as pay_month, avg(amount) as department_avg
    from salary s
    left join employee e 
    on s.employee_id = e.employee_id
    group by pay_month, e.department_id
) t1 
join 
(
    select date_format(s.pay_date,'%Y-%m') as pay_month, avg(amount) as company_avg
    from salary s
    group by pay_month
) t2
on t1.pay_month = t2.pay_month


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
618. Students Report By Geography
SQL架构
A U.S graduate school has students from Asia, Europe and America. The students location information are stored in table student as below.
 

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
 

Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

For the sample input, the output is:
 

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
 

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?


/* Write your PL/SQL query statement below */
/* Write your T-SQL query statement below 
按continent字段分组，聚合，组内排序。可得。

+--------+-----------+
| name   | continent |
+--------+-----------+
| Jack   | America   |
| Jane   | America   |
| Xi     | Asia      |
| Pascal | Europe    |
+--------+-----------+
现在要行转列。

用America,Asia,Europe作为属性，Jack,Jane,Xi,Pascal作为值。

确定 Jack,Jane,Xi,Pascal 所在的数据行。

从 America 属性看，Jack在第1行，Jane在第2行；

从 Asia属性看，Xi在第1行。

从Europe属性看，Pascal在第1行。

最后一步，确定每个数据行中的数据。

按照 America,Asia,Europe 的顺序，

第1行：Jack Xi Pascal

第2行：Jane NULL NULL

合起来得出结果为：

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
从上面的思路看，重点是两步：
第一，确定每个属性中各个数据所在的数据行。 其实是求每个数据的排名。

第二，确定每个数据行都有哪些数据。按照排名放置数据。



*/


select
    max(case when continent = 'America' then name else null end) as America,
    max(case when continent = 'Asia' then name else null end) as Asia,
    max(case when continent = 'Europe' then name else null end) as Europe
from
    (select 
        name, 
        continent, 
        row_number()over(partition by continent order by name) cur_rank
    from
        student)t 
group by cur_rank




-- # Write your MySQL query statement below
-- 解法一
-- 按continent字段分组，聚合，组内排序。可得。

-- +--------+-----------+
-- | name   | continent |
-- +--------+-----------+
-- | Jack   | America   |
-- | Jane   | America   |
-- | Xi     | Asia      |
-- | Pascal | Europe    |
-- +--------+-----------+
-- 现在要行转列。

-- 用America,Asia,Europe作为属性，Jack,Jane,Xi,Pascal作为值。

-- 确定 Jack,Jane,Xi,Pascal 所在的数据行。

-- 从 America 属性看，Jack在第1行，Jane在第2行；

-- 从 Asia属性看，Xi在第1行。

-- 从Europe属性看，Pascal在第1行。

-- 最后一步，确定每个数据行中的数据。

-- 按照 America,Asia,Europe 的顺序，

-- 第1行：Jack Xi Pascal

-- 第2行：Jane NULL NULL

-- 合起来得出结果为：

-- | America | Asia | Europe |
-- |---------|------|--------|
-- | Jack    | Xi   | Pascal |
-- | Jane    |      |        |
-- 从上面的思路看，重点是两步：
-- 第一，确定每个属性中各个数据所在的数据行。 其实是求每个数据的排名。

-- 第二，确定每个数据行都有哪些数据。按照排名放置数据。

-- 求每个数据的排名

-- 求排名通常有两种方法，表自连接和用户变量法。

-- 先讲表自连接法求排名

-- 本题的输入表中，可能会存在多行相同的(name,continent)。

-- 比如：

-- ...
-- (A,B)
-- (A,B)
-- (A,B)
-- ...
-- 那么，仅用两个字段，用表自连接，无法确定每个(A,B)的排名。

-- 将数据的行号作为第三个字段，用于区分相同的数据。

-- 定义用户变量：@row_id——数据的行号，从1开始。

-- (SELECT @row_id:=0) AS T
-- 给数字增加行号，结果表命名为S1：

-- (
-- 	SELECT 
--         S.*,
--         @row_id:=(@row_id + 1) AS `row_id`
-- 	FROM student AS S,(SELECT @row_id:=0) AS T
-- ) AS S1
-- S1表自连接算排名。

-- 在同一个洲中，对每个人A，找出所有人B，满足条件：A.name > B.name 或 A.name = B.name 且 A.row_id > B.row_id。

-- 意思是name字典序小的人排名在前，name字典序相同的人，行号小的排名在前。

-- S1表自连接也分join和left join。

-- 用join，并且 “A.row_id > B.row_id ”改为“ A.row_id >= B.row_id ”。每个人都有排名，且排名从1开始。

-- 用left join，每个人的排名从0开始。

-- 此处用join，算排名的逻辑为：

-- SELECT S1.continent,S1.NAME,S1.row_id,COUNT(*) AS `trank`
-- FROM 
-- (
-- 	SELECT S.*,@row_id:=(@row_id + 1) AS `row_id`
-- 	FROM student AS S,(SELECT @row_id:=0) AS T
-- ) AS S1 
-- JOIN 
-- (
-- 	SELECT S.*,@n_row_id:=(@n_row_id + 1) AS `n_row_id`
-- 	FROM student AS S,(SELECT @n_row_id:=0) AS T
-- ) AS S2 
-- 	ON (S1.continent = S2.continent AND (S1.NAME > S2.NAME OR (S1.NAME = S2.NAME AND S1.row_id >= S2.n_row_id)))
-- group BY S1.continent,S1.NAME,S1.row_id
-- order BY S1.continent,S1.NAME
-- 尽管是S1表自连接，却引入了S2表。因为表名要唯一。

-- 另外S2中的row_id也改为n_row_id。两者值相等。由于mysql中，S1表中的用户变量@row_id，会在表S2中被共享。如果在表S2中继续用@row_id表示行号，其值显然不对。才新增了变量@n_row_id作为行号。

-- 此外，group by子句中，分组条件是：S1.continent,S1.NAME,S1.row_id。

-- 因为要确定每个人的排名，分组依据应该是每个唯一的人。仅用 S1.continent,S1.NAME 不能唯一确定每个人，必须带上row_id。这才是前面引入row_id的意义。

-- 再讲用户变量法求排名

-- 用户变量法则相对简单。按continent升序，再按name升序。同一continent内，按name从小到大，排名从1开始。

-- 用户变量：@trank——排名。@pre_con——前一行的continent。

-- 排名逻辑如下，结果命名为表A

-- (
-- 	SELECT S.*,
-- 	@trank:=if(@pre_con = S.continent,
-- 		@trank + 1,
-- 		1
-- 	) AS `trank`,
-- 	@pre_con:=S.continent AS `pre`
-- 	FROM student AS S,(SELECT @pre_con:=NULL,@trank:=0) AS T
-- 	ORDER BY S.continent,S.NAME
-- ) AS A
-- 按照排名放置数据

-- 用上面的排名算法，得到的排名数据，格式为：name,continent,trank。

-- 现要明确，

-- 第1行数据，必须来自排名为1的所有行；

-- ……

-- 第i行数据， 必须来自排名为i的所有行；
-- 这需要一个聚合操作,因此对排名数据,用group by分组.

-- 每组内部,要根据continent确定name属于一个属性A.那么,此行属性A的值为name,其它属性值为NULL.

-- 逻辑为:

-- MAX(if(A.continent = 'America',A.NAME,NULL)) AS `America`,
-- MAX(if(A.continent = 'Asia',A.NAME,NULL)) AS `Asia`,
-- MAX(if(A.continent = 'Europe',A.NAME,NULL)) AS `Europe`
-- 结合两种排名算法,最终结果为:

-- SELECT 
-- MAX(if(A.continent = 'America',A.NAME,NULL)) AS `America`,
-- MAX(if(A.continent = 'Asia',A.NAME,NULL)) AS `Asia`,
-- MAX(if(A.continent = 'Europe',A.NAME,NULL)) AS `Europe`
-- FROM
-- (
-- 	SELECT S1.continent,S1.NAME,S1.row_id,COUNT(*) AS `trank`
-- 	FROM 
-- 	(
-- 		SELECT S.*,@row_id:=(@row_id + 1) AS `row_id`
-- 		FROM student AS S,(SELECT @row_id:=0) AS T
-- 	) AS S1 
-- 	JOIN 
-- 	(
-- 		SELECT S.*,@n_row_id:=(@n_row_id + 1) AS `n_row_id`
-- 		FROM student AS S,(SELECT @n_row_id:=0) AS T
-- 	) AS S2 
-- 		ON (S1.continent = S2.continent AND (S1.NAME > S2.NAME OR (S1.NAME = S2.NAME AND S1.row_id >= S2.n_row_id)))
-- 	group BY S1.continent,S1.NAME,S1.row_id
-- 	order BY S1.continent,S1.NAME
-- ) AS A
-- GROUP BY A.trank
-- 或者是:

SELECT 
MAX(if(A.continent = 'America',A.NAME,NULL)) AS `America`,
MAX(if(A.continent = 'Asia',A.NAME,NULL)) AS `Asia`,
MAX(if(A.continent = 'Europe',A.NAME,NULL)) AS `Europe`
FROM
(
	SELECT S.*,
	@trank:=if(@pre_con = S.continent,
		@trank + 1,
		1
	) AS `trank`,
	@pre_con:=S.continent AS `pre`
	FROM student AS S,(SELECT @pre_con:=NULL,@trank:=0) AS T
	ORDER BY S.continent,S.NAME
) AS A
GROUP BY A.trank
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1097. Game Play Analysis V
SQL架构
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

We define the install date of a player to be the first login day of that player.

We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didnt log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00


# Write your MySQL query statement below
# install date
-- select player_id, min(event_date) as install_dt
-- from activity
-- group by player_id

# install date and installs count
-- select install_dt, count(*) as installs
-- from 
-- (select player_id, min(event_date) as install_dt
-- from activity
-- group by player_id) tmp
-- group by install_dt

-- # day 1 retention 自联吧
-- (
--     select player_id,min(event_date) as install_dt
--     from Activity
--     group by player_id
-- )
-- as a left join Activity as b 
-- on a.player_id=b.player_id and a.event_date = b.event_date - 1
-- group by a.install_dt

# 最后
select a.install_dt,
        count(a.player_id) as installs,
        round(count(b.player_id)/ count(a.player_id),2) as Day1_retention
from
(
    select player_id,min(event_date) as install_dt
    from Activity
    group by player_id
)
as a left join Activity as b 
on a.player_id=b.player_id and a.install_dt = b.event_date - 1
group by a.install_dt

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1127. User Purchase Platform
SQL架构
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').
Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

The query result format is in the following example:

Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+

Result table:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.



# Write your MySQL query statement below
-- 这道题难点在怎么在原来的platform中多出both的分类 死活想不出
-- 结合评论➕上网查询得知
-- 添加表中不存在的列并设定列的固定值的公式为
-- select id, 'value' as colname from table （value为添加的固定值 colname为列名）
-- ps: 注意存在当天没有人上网的情况，要用left join 保存左表的值且右表人数和amount都为null 再用ifnull()将是null的地方改为零

select t2.spend_date, t2.platform, ifnull(sum(amount), 0) as total_amount,
ifnull(count( user_id), 0) as total_users
from
(
    select distinct spend_date, "desktop" as platform
    from Spending
    union
    select distinct spend_date, "mobile" as platform
    from Spending
    union
    select distinct spend_date, "both" as platform
    from Spending    
) as t2
left join 
(
    select spend_date, sum(amount) as amount, user_id, case
    when count(*) = 1
    then platform # 对group by的理解还不够深啊, group by 之后，每一组里还是一条条数据啊，所以case when 可以用
    else "both" 
    end as platform
    from Spending 
    group by spend_date, user_id
) as t1
on t2.spend_date = t1.spend_date and t2.platform = t1.platform
group by t2.spend_date, t2.platform;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1159. Market Analysis II
SQL架构
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.
Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.
Table: Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key of this table.
 

Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

It is guaranteed that no seller sold more than one item on a day.

The query result format is in the following example:

Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2019-01-01 | Lenovo         |
| 2       | 2019-02-09 | Samsung        |
| 3       | 2019-01-19 | LG             |
| 4       | 2019-05-21 | HP             |
+---------+------------+----------------+

Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2019-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2019-08-04 | 1       | 4        | 2         |
| 5        | 2019-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+

Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+

Result table:
+-----------+--------------------+
| seller_id | 2nd_item_fav_brand |
+-----------+--------------------+
| 1         | no                 |
| 2         | yes                |
| 3         | yes                |
| 4         | no                 |
+-----------+--------------------+

The answer for the user with id 1 is no because they sold nothing.
The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.


# Write your MySQL query statement below

# orders自联，得到用户卖出的第二单
-- select o1.*, count(distinct o2.order_date ) as rk
-- from orders o1
-- left join orders o2
-- on o1.seller_id = o2.seller_id and o1.order_date >=o2.order_date
-- group by o1.order_id
-- having count(distinct o2.order_id ) = 2
-- order by o1.seller_id, o1.order_date

# 和items join 得到 items brand
-- select o1.*, i.item_brand,count(distinct o2.order_date ) as rk
-- from orders o1
-- left join orders o2
-- on o1.seller_id = o2.seller_id and o1.order_date >=o2.order_date
-- left join items i
-- on i.item_id = o1.item_id
-- group by o1.order_id
-- having count(distinct o2.order_id ) = 2
-- order by o1.seller_id, o1.order_date



# 和users左连接上述的子查询，判断是否为用户最喜爱的品牌
select u.user_id as seller_id,
(case when u.favorite_brand = tmp.item_brand then 'yes' else 'no' end) as 2nd_item_fav_brand
from users u 
left join 
(
select o1.*, i.item_brand,count(distinct o2.order_date ) as rk
from orders o1
left join orders o2
on o1.seller_id = o2.seller_id and o1.order_date >=o2.order_date
left join items i
on i.item_id = o1.item_id
group by o1.order_id
having count(distinct o2.order_id ) = 2
order by o1.seller_id, o1.order_date
) tmp 
on u.user_id = tmp.seller_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1194. Tournament Winners
SQL架构
Table: Players

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key of this table.
Each row of this table indicates the group of each player.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     | 
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belongs to the same group.
 

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group.

The query result format is in the following example:

Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |
+-----------+------------+

# Write your MySQL query statement below
# 和1212很像
# join player, 然后按first——player进行分组，second player 分组， 计算score
-- SELECT group_id, player_id, SUM(score) AS score
-- FROM (
--     SELECT Players.group_id, Players.player_id, SUM(Matches.first_score) AS score
--     FROM Players JOIN Matches ON Players.player_id = Matches.first_player
--     GROUP BY Players.player_id

--     UNION ALL

--     SELECT Players.group_id, Players.player_id, SUM(Matches.second_score) AS score
--     FROM Players JOIN Matches ON Players.player_id = Matches.second_player
--     GROUP BY Players.player_id
-- ) s
-- GROUP BY player_id



# mysql 在没有聚合函数的时候返回分组的第一行...只用在group by 前把顺序排好就可以得到想要的数了....查了半天==



SELECT group_id, player_id
FROM (
    SELECT group_id, player_id, SUM(score) AS score
    FROM (
        -- 每个用户总的 first_score
        SELECT Players.group_id, Players.player_id, SUM(Matches.first_score) AS score
        FROM Players JOIN Matches ON Players.player_id = Matches.first_player
        GROUP BY Players.player_id

        UNION ALL

        -- 每个用户总的 second_score
        SELECT Players.group_id, Players.player_id, SUM(Matches.second_score) AS score
        FROM Players JOIN Matches ON Players.player_id = Matches.second_player
        GROUP BY Players.player_id
    ) s
    GROUP BY player_id
    ORDER BY score DESC, player_id
) result
GROUP BY group_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1225. Report Contiguous Dates
SQL架构
Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.
Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

The query result format is in the following example:

Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+


Result table:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+

The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".


# Write your MySQL query statement below
# 学习一下变量吧!

-- 解题思路
-- 1.两部分数据并起来
-- 2.按日期排序后遍历 order by date，分配group_id,连续成功或失败group_id一致
-- 3.按group_id分组，取最大和最小日期即为end_date、start_date

-- 代码
# Write your MySQL query statement below

SELECT if(task_result = 0, 'failed', 'succeeded') AS period_state
	, MIN(date) AS start_date, MAX(date) AS end_date
FROM (
	SELECT date, task_result
		, @group_id := if(@last_result = task_result, @group_id, @group_id + 1) AS group_id
		, @last_result := task_result
	FROM (
		SELECT fail_date AS date, 0 AS task_result
		FROM Failed
		UNION
		SELECT success_date AS date, 1 AS task_result
		FROM Succeeded
	) a, (
			SELECT @group_id := 0, @last_result := 0
		) temp
	WHERE date BETWEEN '2019-01-01' AND '2019-12-31'
	ORDER BY date ASC # 关键啊！！
) b
GROUP BY group_id
ORDER BY start_date ASC
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1336. Number of Transactions per Visit
SQL架构
Table: Visits

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| visit_date    | date    |
+---------------+---------+
(user_id, visit_date) is the primary key for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.
 

Table: Transactions

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| transaction_date | date    |
| amount           | int     |
+------------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)
 

A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

Write an SQL query to find how many users visited the bank and didnt do any transactions, how many visited the bank and did one transaction and so on.

The result table will contain two columns:

transactions_count which is the number of transactions done in one visit.
visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.
transactions_count should take all values from 0 to max(transactions_count) done by one or more users.

Order the result table by transactions_count.

The query result format is in the following example:

Visits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+
Transactions table:
+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+
Result table:
+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+
* For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), (12, "2020-01-01") and (19, "2020-01-03") did no transactions so visits_count = 4.
* For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), (8, "2020-01-28"), (1, "2020-01-02") and (1, "2020-01-04") did one transaction so visits_count = 5.
* For transactions_count = 2, No customers visited the bank and did two transactions so visits_count = 0.
* For transactions_count = 3, The visit (9, "2020-01-25") did three transactions so visits_count = 1.
* For transactions_count >= 4, No customers visited the bank and did more than three transactions so we will stop at transactions_count = 3


# Write your MySQL query statement below
-- 首先，对于每个用户的每次访问，一共有几个transaction可以用以下SQL获得：cnt是transactions_count，num是visits_count

-- SELECT IFNULL(cnt, 0) cnt, COUNT(*) num FROM Visits t1 LEFT JOIN
-- (SELECT user_id, transaction_date, COUNT(*) cnt FROM Transactions GROUP BY user_id, transaction_date)t2
-- ON t1.user_id=t2.user_id AND visit_date=transaction_date 
-- GROUP BY IFNULL(cnt, 0)

-- 然后，需要生成一张从0到上面这张表的最大值(设为N)的表和它进行JOIN，来获得最终结果。考虑到最大出现的数字，肯定不会超过Transaction表的行数，使用Transaction开表：

-- SELECT (@t := @t+1) AS transactions_count FROM Transactions t0, (SELECT @t := -1) b


-- 然后让数字小于等于最大值，生成数字表的SQL变为：

-- SELECT (@t := @t+1) AS transactions_count 
-- FROM Transactions t0, (SELECT @t := -1) t3
-- WHERE @t < (
--         select ifnull(max(num),0) from (
--             select count(*) as num from
--             Transactions
--             group by user_id, transaction_date
--         ) as t4)


-- 但是这样存在一个问题，如果Transaction为空，则开不出0这个数据，所以处理一下，让@t从1开始，然后手动UNION一个为0的行，结果：

-- SELECT (@t := @t+1) AS transactions_count 
-- FROM Transactions t0, (SELECT @t := 0) t3
-- WHERE @t < (
--         select ifnull(max(num),0) from (
--             select count(*) as num from
--             Transactions
--             group by user_id, transaction_date
--         ) as t4)
-- union
-- select 0 as transactions_count


-- 然后将数字表和最开始的表1左连接即可：

SELECT t5.transactions_count, IFNULL(num, 0) visits_count FROM
(SELECT (@t := @t+1) AS transactions_count 
FROM Transactions t0, (SELECT @t := 0) t3
WHERE @t < (
        select ifnull(max(num),0) from (
            select count(*) as num from
            Transactions
            group by user_id, transaction_date
        ) as t4)
union
select 0 as transactions_count) t5
LEFT JOIN
(SELECT IFNULL(cnt, 0) cnt, COUNT(*) num FROM Visits t1 LEFT JOIN
(SELECT user_id, transaction_date, COUNT(*) cnt FROM Transactions GROUP BY user_id, transaction_date)t2
ON t1.user_id=t2.user_id AND visit_date=transaction_date GROUP BY IFNULL(cnt, 0)) t6
ON t5.transactions_count=t6.cnt 
ORDER BY transactions_count
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1369. Get the Second Most Recent Activity
SQL架构
Table: UserActivity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
This table does not contain primary key.
This table contain information about the activity performed of each user in a period of time.
A person with username performed a activity from startDate to endDate.

Write an SQL query to show the second most recent activity of each user.

If the user only has one activity, return that one. 

A user cant perform more than one activity at the same time. Return the result table in any order.

The query result format is in the following example:

UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+

Result table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+

The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
Bob only has one record, we just take that one.


# Write your MySQL query statement below
# 无primary key 小心duplicate
-- 简单直观的解法，没有什么特殊技巧：

-- useractivity根据username自连接
-- 按照username和startdate分组
-- having筛选分组
-- 用sum()统计分组中startdate比当前更靠后的记录数，若为1，则是最近的第二次活动
-- 如果分组中记录只有一条，根据题意也要选出来

select u1.*
from useractivity u1 join useractivity u2
on u1.username = u2.username 
group by u1.username,u1.startDate
having sum(u2.startDate>u1.startDate) = 1 or count(distinct u2.startDate) =1 

-- # 第二种办法：先找只有one activity的，直接返回，然后找more than one，返回second most recent act， union


(select u1.*
from useractivity u1 join useractivity u2
on u1.username = u2.username and u1.startDate < u2.startDate
group by u1.username,u1.startdate
having count(distinct u2.startDate) = 1)
union
(select *
from UserActivity
group by username
having count(distinct startDate ) =1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1384. Total Sales Amount by Year
SQL架构
Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key for this table.
product_name is the name of the product.
 

Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | varchar |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.

Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.

The query result format is in the following example:

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+

Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+

Result table:
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.


# Write your MySQL query statement below

-- 本题的坑：

-- 列名区分大小写
-- product_id要返回字符串，sales表的product_id好像是字符串类型的，和题目描述不一样
-- report_year要返回字符串，所以不能用year()，只能用date_format()
-- 最后product_id排序要根据字典序，而不是数字顺序，这个真的违反一般习惯

select 
    s.PRODUCT_ID, PRODUCT_NAME, date_format(bound, '%Y') REPORT_YEAR,
    (datediff(
        if(bound < period_end, bound, period_end), 
        if(makedate(year(bound), 1) > period_start, makedate(year(bound), 1), period_start)
    ) + 1) * average_daily_sales TOTAL_AMOUNT
from product p join (
    select '2018-12-31' bound
    union all
    select '2019-12-31' bound
    union all
    select '2020-12-31' bound
) bounds join sales s
on 
    p.product_id = s.product_id 
    and year(bound) between year(period_start) and year(period_end)
order by s.product_id, report_year

# from product p join (   ...     and year(bound) between year(period_start) and year(period_end) 返回下列：
--     {"headers": ["product_id", "product_name", "bound", "product_id", "period_start", "period_end", "average_daily_sales"], 
--     "values": 
--     [2, "LC T-Shirt", "2018-12-31", "2", "2018-12-01", "2020-01-01", 10], 
--     [3, "LC Keychain", "2019-12-31", "3", "2019-12-01", "2020-01-31", 1], 
--     [2, "LC T-Shirt", "2019-12-31", "2", "2018-12-01", "2020-01-01", 10], 
--     [1, "LC Phone ", "2019-12-31", "1", "2019-01-25", "2019-02-28", 100], 
--     [3, "LC Keychain", "2020-12-31", "3", "2019-12-01", "2020-01-31", 1], 
--     [2, "LC T-Shirt", "2020-12-31", "2", "2018-12-01", "2020-01-01", 10]}

# 第二种方法。我服了。

select t.product_id,product_name,report_year,total_amount from (
select product_id,"2020" report_year,(datediff(if(period_end<"2021-01-01",period_end,date("2020-12-31")),if(period_start>"2020-01-01",period_start,date("2020-01-01")))+1)*average_daily_sales as total_amount from Sales having total_amount>0 # 原来不用group by 也可以having 只要后面是聚合函数. having total amount >0 就过滤了不是2020的数据
union all
select product_id,"2019" report_year,(datediff(if(period_end<"2020-01-01",period_end,date("2019-12-31")),if(period_start>"2019-01-01",period_start,date("2019-01-01")))+1)*average_daily_sales as total_amount from Sales having total_amount>0  
union all
select product_id,"2018" report_year,(datediff(if(period_end<"2019-01-01",period_end,date("2018-12-31")),if(period_start>"2018-01-01",period_start,date("2018-01-01")))+1)*average_daily_sales as total_amount from Sales having total_amount>0  
)t left join product p on p.product_id=t.product_id                               
order by product_id,report_year
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1412. Find the Quiet Students in All Exams
SQL架构
Table: Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key for this table.
student_name is the name of the student.
 

Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key for this table.
Student with student_id got score points in exam with id exam_id.
 

A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

Don't return the student who has never taken any exam. Return the result table ordered by student_id.

The query result format is in the following example.

 

Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+

Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+

Result table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+

For exam 1: Student 1 and 3 hold the lowest and high score respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
Student 2 and 5 have never got the highest or lowest in any of the exam.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.



# Write your MySQL query statement below

-- # 找到每门课分数最高和最低的分数 的学生学号 a
-- (select student_id
-- from exam
-- where (exam_id,score) in 
-- (SELECT exam_id, MAX(SCORE) AS max_score
-- FROM Exam
-- GROUP BY exam_id))
-- union
-- (select student_id
-- from exam
-- where (exam_id,score) in 
-- (SELECT exam_id, min(SCORE) AS min_score
-- FROM Exam
-- GROUP BY exam_id))

-- # student join exam 得到参与考试的学生学号 b
-- select s.*
-- from student s ,exam e
-- where s.student_id = e.student_id

# b左连a
select distinct a.*
from (select s.*
from student s ,exam e
where s.student_id = e.student_id) a 
left join 
((select student_id
from exam
where (exam_id,score) in 
(SELECT exam_id, MAX(SCORE) AS max_score
FROM Exam
GROUP BY exam_id))
union
(select student_id
from exam
where (exam_id,score) in 
(SELECT exam_id, min(SCORE) AS min_score
FROM Exam
GROUP BY exam_id))) b
on a.student_id = b.student_id
where b.student_id is null
order by a.student_id


# 或者
SELECT STUDENT_ID,STUDENT_NAME FROM 
student 
WHERE student_id NOT IN
(SELECT DISTINCT E1.student_id 
FROM EXAM AS E1
INNER JOIN 
(SELECT exam_id, MAX(SCORE) AS max_score, MIN(score) AS min_score
FROM Exam
GROUP BY exam_id) AS E2
ON E1.exam_id =E2.exam_id AND (E1.score=E2.max_score OR E1.score= E2.min_score))
AND student_id IN (SELECT DISTINCT student_id FROM Exam);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





601. Human Traffic of Stadium
SQL架构
X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
For the sample data above, the output is:

+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
Note:
Each day only have one row record, and the dates are increasing with id increasing.



# 建议时常思考复习

方法：使用 JOIN 和 WHERE 子句【通过】
思路

在表 stadium 中查询人流量超过 100 的记录，将查询结果与其自身的临时表连接，再使用 WHERE 子句获得满足条件的记录。

算法

第一步：查询人流量超过 100 的记录，然后将结果与其自身的临时表连接。

MySQL
select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
方法：使用 JOIN 和 WHERE 子句【通过】
思路

在表 stadium 中查询人流量超过 100 的记录，将查询结果与其自身的临时表连接，再使用 WHERE 子句获得满足条件的记录。

算法

第一步：查询人流量超过 100 的记录，然后将结果与其自身的临时表连接。

MySQL
select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
;
| id | date       | people | id | date       | people | id | date       | people |
|----|------------|--------|----|------------|--------|----|------------|--------|
| 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 6  | 2017-01-06 | 1455   | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 7  | 2017-01-07 | 199    | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 8  | 2017-01-08 | 188    | 2  | 2017-01-02 | 109    | 2  | 2017-01-02 | 109    |
| 2  | 2017-01-02 | 109    | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 3  | 2017-01-03 | 150    | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 5  | 2017-01-05 | 145    | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 6  | 2017-01-06 | 1455   | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 7  | 2017-01-07 | 199    | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 8  | 2017-01-08 | 188    | 3  | 2017-01-03 | 150    | 2  | 2017-01-02 | 109    |
| 2  | 2017-01-02 | 109    | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
| 3  | 2017-01-03 | 150    | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
| 5  | 2017-01-05 | 145    | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
| 6  | 2017-01-06 | 1455   | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
| 7  | 2017-01-07 | 199    | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
| 8  | 2017-01-08 | 188    | 5  | 2017-01-05 | 145    | 2  | 2017-01-02 | 109    |
....


共有 6 天人流量超过 100 人，笛卡尔积 后有 216（666） 条记录。
前 3 列来自表 t1，中间 3 列来自表 t2，最后 3 列来自表 t3。
表 t1，t2 和 t3 相同，需要考虑添加哪些条件能够得到想要的结果。以 t1 为例，它有可能是高峰期的第 1 天，第 2 天，或第 3 天。

t1 是高峰期第 1 天：(t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1) -- t1, t2, t3
t1 是高峰期第 2 天：(t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
t1 是高峰期第 3 天：(t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
MySQL
select t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
	  (t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
;
| id | date       | people |
|----|------------|--------|
| 7  | 2017-01-07 | 199    |
| 6  | 2017-01-06 | 1455   |
| 8  | 2017-01-08 | 188    |
| 7  | 2017-01-07 | 199    |
| 5  | 2017-01-05 | 145    |
| 6  | 2017-01-06 | 1455   |
可以看到查询结果中存在重复的记录，再使用 DISTINCT 去重。



select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
      (t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
order by t1.id
;

