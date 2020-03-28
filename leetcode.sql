
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


select max(Salary) as SecondHighestSalary  from Employee where Salary not in (select max(salary) from employee);

or:

select Salary as SecondHighestSalary from Employee GROUP BY Salary ORDER BY Salary desc LIMIT 1,1 

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
SET M = N - 1;
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


不会
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
where e.Salary in (select max(Salary) from Employee group by DepartmentId)
and d.id = e.DepartmentId;


or :

select c.name as Department, b.name as Employee, b.salary as Salary  
from employee b, (select departmentid, max(salary) as max_salary from employee group by departmentid) a, department c 
where a.departmentid = b.departmentid and a.max_salary = b.salary and b.departmentid = c.id;

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
select d.Name as Department, e.Name as Employee, e.Salary
from Department d, Employee e
where d.id = e.DepartmentId
and (select count(distinct e2.salary) from Employee e2 where e.DepartmentId =e2.DepartmentId and e.Salary < e2.Salary) <3
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
the absolute difference of its(median) count of bigger elements and small ones in an array should be <= 1
no matter whether it has odd or even amount of numbers and whether they are distinct. 

select any_value(id) as id, company,salary from Employee e1
where 1 >= abs((select count(*) from Employee e2 where e1.company = e2.company and e1.salary <= e2.salary) - (select count(*) from Employee e3 where e1.company = e3.company and e1.salary >= e3.salary))
group by company,salary


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

select Name from Employee e 
where e.Id in (select ManagerId from Employee e1 group by ManagerId having count(*) >= 5)


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


select Name from Candidate c
right join(
select CandidateId,count(*)
from Vote
group by CandidateId
order by count(*) desc
limit 1) as t1
on c.id = t1.CandidateId

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


或者preunique这个score

SELECT
  Score,
  (SELECT count(*) FROM (SELECT distinct Score s FROM Scores) tmp WHERE s >= Score) Rank
FROM Scores
ORDER BY Score desc

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


select w1.Id from Weather w1
join Weather w2
on w1.Temperature > w2.Temperature
and DATEDIFF(w1.RecordDate,w2.RecordDate) =1 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

627. Swap Salary
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


IF 表达式
IF( expr1 , expr2 , expr3 )
expr1 的值为 TRUE，则返回值为 expr2 
expr1 的值为FALSE，则返回值为 expr3


update salary
	set sex = if (sex = "m", 'f',"m");
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

584
select name 
from customer
where referee_id <> 2 or referee_id is null

585
SELECT SUM(TIV_2016) AS TIV_2016 FROM insurance WHERE
# 可以先找出所有重复出现过的TIV_2015值，再找出对应的记录：
TIV_2015 IN (SELECT TIV_2015 FROM insurance GROUP BY TIV_2015 HAVING COUNT(*) > 1) AND
# 然后找出所有只出现过一次的位置(LAT, LON)，再找出对应记录：
(LAT, LON) IN (SELECT LAT, LON FROM insurance GROUP BY LAT, LON HAVING COUNT(*) = 1);


586
SELECT customer_number 
FROM orders 
GROUP BY customer_number 
ORDER BY COUNT(*) DESC Limit 1


596
select class from courses
group by class
having count(distinct student) >= 5
# disctinct 的用处：当出现两个{"A","Math"}的时候，是不应该判断为两个学生的，因为这两个人重复了。
# 之所以会出现这个问题，是因为在录入数据的时候A、Math被重复录入了，一开始自己没考虑到这个问题，但是上面的表确实没说过它有主键约束或者唯一约束，所以左侧的student字段是可能会重复的。为了去除重复值，要对student前加个distinct。


601
# 建议时常思考复习
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

