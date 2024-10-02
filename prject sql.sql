use project;

SELECT * FROM hr_11;
select * from hr_12;

ALTER TABLE hr_12
CHANGE COLUMN `Employee ID` EmployeeID int;


select distinct(standardhours) from hr_11 a join hr_12 b on a.employeenumber = b.employeeid;

-- 1.Average Attrition rate for all Departments

select concat(round((100*sum(1)/(select count(1) from hr_11 where attrition = 'Yes')),2),'%') attrition_rate, 
department from hr_11
where attrition = 'Yes'
group by department
order by attrition_rate desc
;

-- 2.Average Hourly rate of Male Research Scientist

select Gender, JobRole, Avg(HourlyRate)  from hr_11
where gender = 'Male' and jobrole='Research Scientist';


-- 3.Attrition rate Vs Monthly income stats


drop view attrition_incomegrp;
create view attrition_incomegrp as
select  
a.attrition,
b.monthlyincome,
case
when b.monthlyincome> 1000 and b.monthlyincome <=10000 then '01k-10k'
when b.monthlyincome> 10000 and b.monthlyincome <= 20000 then '10k-20k'
when b.monthlyincome> 20000 and b.monthlyincome <= 30000 then '20k-30k'
when b.monthlyincome> 30000 and b.monthlyincome <= 40000 then '30k-40k'
when b.monthlyincome> 40000 and b.monthlyincome <=50000 then '40k-50k'
when b.monthlyincome> 50000 and b.monthlyincome <=60000 then '50k_60k'
end as incomegrp
from hr_12 b join hr_11 a on a.employeenumber = b.employeeid;

-- working !!!!!
select concat(round(100*count(1)/(select count(1) from attrition_incomegrp where attrition ='Yes'),2),'%') attrition_rate, 
incomegrp 
from attrition_incomegrp
where attrition = 'Yes'
group by incomegrp
order by incomegrp asc;


-- 4. Average working years for each Department

select a.department, 
avg(if(a.age < b.totalworkingyears, (select min(totalworkingyears) from hr_12) , b.totalworkingyears)) avg_work_ex
-- ,a.age 
from hr_11 a join hr_12 b on a.employeenumber = b.employeeid
-- where a.age > b.totalworkingyears
group by a.department;


-- 5.Job Role Vs Work life balance

drop view job_role_count;
create view job_role_count as
select count(1) as cnt, a1.jobrole from hr_11 a1 join hr_12 b1 on a1.employeenumber = b1.employeeid
group by a1.jobrole;

select * from job_role_count;
select a.jobrole, 
case
when b.worklifebalance = 1 then 'Poor'
when b.worklifebalance = 2 then 'Average'
when b.worklifebalance = 3 then 'Good'
when b.worklifebalance = 4 then 'Excellent'
end as wl_bal, 
concat(round(100*count(b.worklifebalance)/(select cnt from job_role_count where jobrole = a.jobrole), 2), '%') avg_wl_bal
from hr_11 a join hr_12 b on a.employeenumber = b.employeeid
group by b.worklifebalance, a.jobrole
order by avg_wl_bal desc;

-- 6. Attrition rate Vs Year since last promotion relation

select concat(round((100*sum(1)/(select count(1) from hr_11 where attrition = 'Yes')),2),'%') attrition_rate, 
b.yearssincelastpromotion
from hr_11 a join hr_12 b on a.employeenumber = b.employeeid
where a.attrition = 'Yes'
group by  b.yearssincelastpromotion
order by b.yearssincelastpromotion asc;
