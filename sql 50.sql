# sql不区分大小写

# Group By 和 Having, Where ,Order by的顺序
-- Group By 和 Having, Where ,Order by这些关键字是按照如下顺序进行执行的：Where, Group By, Having, Order by。
-- 首先where将最原始记录中不满足条件的记录删除(所以应该在where语句中尽量的将不符合条件的记录筛选掉，这样可以减少分组的次数)
-- 然后通过Group By关键字后面指定的分组条件将筛选得到的视图进行分组
-- 接着系统根据Having关键字后面指定的筛选条件，将分组视图后不满足条件的记录筛选掉
-- 最后按照Order By语句对视图进行排序，这样最终的结果就产生了。
-- 在这四个关键字中，只有在Order By语句中才可以使用最终视图的列名，如：
-- SELECT FruitName, ProductPlace, Price, ID AS IDE, Discount
-- FROM T_TEST_FRUITINFO
-- WHERE (ProductPlace = N'china')
-- ORDER BY IDE
-- 这里只有在ORDER BY语句中才可以使用IDE，其他条件语句中如果需要引用列名则只能使用ID，而不能使用IDE。



# 创建数据table
create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-12-20' , '男');
insert into Student values('04' , '李云' , '1990-12-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-01-01' , '女');
insert into Student values('07' , '郑竹' , '1989-01-01' , '女');
insert into Student values('09' , '张三' , '2017-12-20' , '女');
insert into Student values('10' , '李四' , '2017-12-25' , '女');
insert into Student values('11' , '李四' , '2012-06-06' , '女');
insert into Student values('12' , '赵六' , '2013-06-13' , '女');
insert into Student values('13' , '孙七' , '2014-06-01' , '女');

create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');

create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

create table SC(SId varchar(10),CId varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);

# 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
select * from Student s Right JOIN (
    select t1.SId, class1, class2 from
          (select SId, score as class1 from sc where sc.CId = '01')as t1, 
          (select SId, score as class2 from sc where sc.CId = '02')as t2
    where t1.SId = t2.SId AND t1.class1 > t2.class2
)r
on s.SId = r.SId;

# 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
select * from 
    (select * from sc where sc.CId = '01') as t1, 
    (select * from sc where sc.CId = '02') as t2
where t1.SId = t2.SId;

# 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
select * from
 (select * from sc where sc.CId = '01') as t1
 left JOIN
 (select * from sc where sc.CId = '02') as t2
 on t1.SId = t2.SId

# 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
select *
from sc
where sc.SId not in (select SId from sc where sc.CId='01')
and  sc.CId='02';


# 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩

# 这里只用根据学生ID把成绩分组，对分组中的score求平均值，最后在选取结果中AVG大于60的即可. 注意，这里必须要给计算得到的AVG结果一个alias.（AS avgscore）
# 得到学生信息的时候既可以用join也可以用一般的联合搜索
# 注意要想最终结果显示avgscore，在第一句select就要写 select r.avgscore from ...

select Student.SID, Student.Sname, r.avgscore from Student 
    inner Join (
    select sc.SID, AVG(sc.score) as avgscore
    from sc
    Group by sc.SID
    Having AVG(sc.score) >= 60 ) as r
    on Student.SID = r.SID;

# 3.查询在 SC 表存在成绩的学生信息
select * from Student 
where Student.SID in (select DISTINCT SID from sc)

# 4.查询所有同学的学生编号、学生姓名、选课总数、所有课程的成绩总和(没成绩的显示为null)

select s.sid, s.sname,r.coursenumber,r.scoresum
from (
    (select student.sid,student.sname 
    from student
    ) as s 
    left join 
    (select 
        sc.sid, sum(sc.score) as scoresum, count(sc.cid) as coursenumber
        from sc 
        group by sc.sid
    ) as r 
   on s.sid = r.sid
);


# 4.1 查有成绩的学生信息
# 这一题涉及到in和exists的用法，在这种小表中，两种方法的效率都差不多，
-- 当表2的记录数量非常大的时候，选用exists比in要高效很多.
-- EXISTS用于检查子查询是否至少会返回一行数据，该子查询实际上并不返回任何数据，而是返回值True或False.
-- 结论：IN()适合B表比A表数据小的情况
-- 结论：EXISTS()适合B表比A表数据大的情况
select * from student 
where exists (select sc.sid from sc where student.sid = sc.sid);

select * from student
where student.sid in (select sc.sid from sc);

# 5. 查询「李」姓老师的数量
select count(Tname)
from Teacher
where Tname like '李%'

# 6. 查询学过「张三」老师授课的同学的信息
# 多表联合查询!!
select student.* from student,teacher,course,sc
where course.tid = teacher.tid
and tname = '张三'
and course.cid = sc.cid
and sc.sid = student.sid;

# 7. 查询没有学全所有课程的同学的信息
# 先查询选了所有课的学生，再选择这些人之外的学生.
select * from student
where student.sid not in (
  select sc.sid from sc
  group by sc.sid
  having count(sc.cid)= (select count(cid) from course)
);


# 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
-- 从sc表查询01同学的所有选课cid--从sc表查询所有同学的sid如果其cid在前面的结果中--从student表查询所有学生信息如果sid在前面的结果中
select * from student
where student.sid in (select sc.sid from sc where sc.cid in (select sc.cid from sc where sc.sid = '01'));


# 9. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息
# 不会

select * from student 
where student.sid in (
select sc.sid from sc 
where sc.sid<>'01' 
group by sc.sid
# group_concat(cid order by cid) 可以避免插入数据时课程顺序混乱，而导致查询结果不准确的情况
having group_concat(cid order by cid) = (select group_concat(cid order by cid) from SC where sid = '01'));


# 10.查询没学过"张三"老师讲授的任一门课程的学生姓名
# 错误解：
select Distinct student.*
from student,teacher,sc,course
where teacher.tname <> '张三'
and course.tid = teacher.tid
and sc.cid = course.cid
and student.sid = sc.cid;

# 正确解：
select * from student
where student.sid not in(
    select sc.sid from sc,course,teacher 
    where
        sc.cid = course.cid
        and course.tid = teacher.tid
        and teacher.tname= "张三"
);

# 11.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select student.sid, student.sname, avg
from student right join
(select sc.sid, avg(score) as avg from sc
where sc.sid in (select sc.sid from sc where sc.score < 60 group by sc.sid having count(sc.sid) >=2)
group by sid) as b
on student.sid = b.sid;


# 12.检索" 01 "课程分数小于 60，按分数降序排列的学生信息
select student.* from student,sc
where student.sid = sc.sid
and sc.cid = '01'
and sc.score < 60
order by sc.score desc

# 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select * from sc
left join (select sc.sid, avg(sc.score) as avgscore from sc group by sc.sid) as r
on sc.sid = r.sid
order by r.avgscore desc

# 14.各科成绩最高分、最低分和平均分： 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
# !!!用到case when 
select course.cname, r.*
from course 
right join(
select sc.cid,
max(sc.score) as 最高分,
min(sc.score) as 最低分,
avg(sc.score) as 平均分,
count(sc.cid) as 选修人数,
sum(case when SC.score>=60 then 1 else 0 end )/count(sc.cid) as 及格率,
sum(case when SC.score>=70 and SC.score<=80 then 1 else 0 END )/count(sc.cid)as 中等率,
sum(case when SC.score>=80 and SC.score<=90 then 1 else 0 END )/count(sc.cid)as 优良率,
sum(case when SC.score>=90 then 1 else 0 end )/count(sc.cid)as 优秀率
from sc
group by sc.cid) as r
on course.cid = r.cid
order by 选修人数 desc, r.cid asc

# 15.按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
不会
https://blog.csdn.net/liyang_nash/article/details/99641571

select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a
left join sc as b
on a.cid = b.cid and a.score<b.score
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;

或者 

SELECT *,RANK() OVER(PARTITION BY c ORDER BY score DESC)排名
FROM sc;


# 15.1按各科成绩进行排序，并显示排名，Score重复时合并名次
不会

SELECT *, DENSE_RANK() OVER(PARTITION BY c ORDER BY score DESC)排名
FROM sc;



# 16. 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺

#这里主要学习一下使用变量。在SQL里面变量用@来标识。
set @crank=0;
select q.sid, total, @crank := @crank +1 as rank from(
select sc.sid, sum(sc.score) as total from sc
group by sc.sid
order by total desc)q;


# 17.统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
# 注意一下，用case when 返回1 以后的统计不是用count而是sum
select course.cid, course.cname, r.*
from course 
left join (
select sc.cid,sum(case when sc.score<=100 and sc.score>85 then 1 else 0 end) as "[100-85]", sum(case when sc.score<=100 and sc.score>85 then 1 else 0 end) /count(*)*100 as p1,
sum(case when sc.score<=85 and sc.score>70 then 1 else 0 end) as "[85-70]", sum(case when sc.score<=85 and sc.score>70 then 1 else 0 end)  /count(*)*100 as p2,
sum(case when sc.score<=70 and sc.score>60 then 1 else 0 end) as "[70-60]", sum(case when sc.score<=70 and sc.score>60 then 1 else 0 end) /count(*)*100 as p3,
sum(case when sc.score<=60 and sc.score>0 then 1 else 0 end) as "[60-0]", sum(case when sc.score<=60 and sc.score>0 then 1 else 0 end) /count(*)*100 as p4
from sc
group by sc.cid) as r
on course.cid = r.cid

#　18.查询各科成绩前三名的记录
# mysql不能group by 了以后取limit
# 前三名转化为: 若大于此成绩的数量少于3即为前三名。
select * from sc
where (select count(*) from sc as b where sc.cid = b.cid and sc.score < b.score) < 3
order by sc.cid asc, sc.score desc

或者自联表
select a.sid,a.cid,a.score from sc a 
left join sc b on a.cid = b.cid and a.score<b.score
group by a.cid, a.sid,a.score
having count(*)<3
order by a.cid, a.score desc;

# 19.查询每门课程被选修的学生数
select cid, count(*) from sc
group by sc.cid;

# 20. 查询出只选修两门课程的学生学号和姓名
select student.sid, student.sname from student
where student.sid in(
select sc.sid from sc
group by sc.sid
having count(*) = 2);

# 21.查询男生、女生人数
select ssex, count(*) from student
group by ssex;

# 22.查询名字中含有「风」字的学生信息
select * from student 
where student.Sname like '%风%'

# 23.查询同名学生名单，并统计同名人数
select sname, count(*) from student
group by sname
having count(*) > 1;

# 24.查询 1990 年出生的学生名单
# year 函数
select * from student
where year(sage) = 1990;

# 25.查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select sc.cid, avg(sc.score) as avgscore
from sc
group by sc.cid
order by avgscore desc, sc.cid asc

# 26.查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
select student.sid, student.sname from student 
inner join (select sc.sid, avg(sc.score) as avgscore from sc group by sc.sid having avg(sc.score)> 85 ) as t
on student.sid = t.sid


# 27.查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
select student.sname, sc.score from student, sc, course
where course.cname = '数学'
and course.cid = sc.cid
and student.sid = sc.sid
and sc.score < 60

# 28.查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
select student.sname, student.sid, sc.cid, sc.score
from student
left join sc
on student.sid = sc.sid


# 29.查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
select student.Sname,course.Cname,sc.score
from student , sc  ,course
where sc.score>=70
and  student.SId=sc.SId
and sc.CId=course.CId


# 30.查询存在不及格的课程
select distinct cid from sc
where score < 60;

#31.查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
select student.sid, student.sname from student, sc
where cid = '01'
and score >= 80
and student.sId=sc.sId;

# 32.求每门课程的学生人数
select cid, count(*) from sc
group by cid

# 33.成绩不重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
# 按分数排序然后取limit 1
select student.*, sc.score from student,course,teacher,sc
where teacher.tname = '张三'
and teacher.tid = course.tid
and course.cid = sc.cid
and sc.sid = student.sId
order by sc.score desc
limit 1

# 34.成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
不会
这道题的思路继续上一题，我们已经查询到了符合限定条件的最高分了，这个时候只用比较这张表，找到全部score等于这个最高分的记录就可，看起来有点繁复
select student.*, sc.score from student, teacher, course,sc 
where teacher.tid = course.tid
and sc.sid = student.sid
and sc.cid = course.cid
and teacher.tname = "张三"
and sc.score = (
    select Max(sc.score) 
    from sc,student, teacher, course
    where teacher.tid = course.tid
    and sc.sid = student.sid
    and sc.cid = course.cid
    and teacher.tname = "张三"
);

#35.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
不会 
用exists
select * from sc as t1
where exists (select * from sc as t2 where t1.sid = t2.sid and t1.cid <>t2.cid and t1.score = t2.score);


# 36.查询每门功成绩最好的前两名
和18题一样思路
select a.* from sc as a 
left join sc as b on a.cid = b.cid and a.score<b.score
group by a.cid, a.sid,a.score
having count(*)<2
order by a.cid, a.score desc;


# 37.统计每门课程的学生选修人数（超过 5 人的课程才统计）
select sc.cid, count(*) from sc
group by sc.cid
having count(*) >5


# 38.检索至少选修两门课程的学生学号
select sid from sc 
group by sId
having count(*) >= 2;

# 39.查询选修了全部课程的学生信息
select student.* from student
inner join (select sc.sid from sc group by sc.sid having count(*) = (select count(*) from course)) as t1
on student.sid = t1.sid


# 40.查询各学生的年龄，只按年份来算
用TIMESTAMPDIFF
select student.sid, student.sname, TIMESTAMPDIFF(year,student.sage,CURDATE()) as 年龄 from student;


# 41.按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
select student.sid, student.sname, TIMESTAMPDIFF(year,student.sage,CURDATE()) as 年龄 from student;


# 42.查询本周过生日的学生
不会
yearweek 是得到 199348这种
weekofyear 得到 48
注意：如果只是对比当年生日周与今年的周是否相同的话，当年的周数会与今年的有偏差，月日相同的但是周数可能会不同。（楼主43题也有同样的问题）
我的思路是：先将今年年份拼接当年的月日，再对比周数
select *
from Student
where WEEKOFYEAR(CONCAT(YEAR(CURRENT_DATE),'-',MONTH(Sage),'-',DAY(Sage))) = WEEKOFYEAR(CURRENT_DATE);


# 43.查询下周过生日的学生
select *
from Student
where WEEKOFYEAR(CONCAT(YEAR(CURRENT_DATE),'-',MONTH(Sage),'-',DAY(Sage))) = WEEKOFYEAR(CURRENT_DATE) + 1;


# 44.查询本月过生日的学生
select *
from student
where month(student.sage) = month(CURDATE());

# 45.查询下月过生日的学生
select *
from student 
where MONTH(student.Sage)=MONTH(CURDATE())+1;















