select *
from employee_salary
 where dept_id=1 OR NOT salary < 50000;

select *
from employee_salary
 where dept_id=1 OR NOT salary > 50000;

select *
from employee_demographics 
order by 5,4; 

select first_name, occupation,avg(salary) 
from employee_salary
where occupation like "%director%" 
group by first_name,occupation
having avg(salary) >50000;

select salary
from employee_salary
group by salary 
limit 3;

select *
 from employee_demographics as dem
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id;

select dem.employee_id,birth_date,occupation,age
from employee_demographics as dem
inner join employee_salary as sal 
on dem.employee_id=sal.employee_id;

select *
 from employee_demographics as dem
 left join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
 select *
 from employee_demographics as dem
 right join employee_salary as sal
 on dem.employee_id=sal.employee_id;
 
 select *
 from employee_demographics as dem
 join employee_salary as sal
 on dem.employee_id+1 =sal.employee_id;
 
 select *
 from employee_demographics as dem
 inner join employee_salary as sal
 on dem.employee_id=sal.employee_id
 inner join parks_departments as pd
 on sal.dept_id=pd.department_id;
 
 select *
 from employee_demographics
 union 
 select *
 from employee_salary;
 
 select first_name
 from employee_demographics
 union 
 select first_name
 from employee_salary;
 
 select first_name,last_name,'old man' as label
 from employee_demographics
 where age>40 and gender='male'
 union 
 select first_name,last_name,'old lady' as label
 from employee_demographics
 where age>40 and gender='female'
 union 
 select first_name,last_name,'young man' as label
 from employee_demographics
 where age<30 and gender='male'
 union 
 select first_name,last_name,'young lady' as label
 from employee_demographics
 where age<30 and gender='female'
 union 
 select first_name,last_name,'highly paid employee' as label
 from employee_salary
 where salary>70000 
 union 
  select first_name,last_name,'lowest paid employee' as label
 from employee_salary
 where salary<30000 
order by first_name,last_name; 

select first_name ,
length(first_name) as length,
upper(first_name) as upper, 
lower(first_name) as lower, 
left(first_name,4) as leftsub, 
right(first_name,4) as rightsub,
substring(first_name,3,4) as substr,
replace(first_name,'i','p') as edit,
locate('n',first_name) findpos,
concat(first_name,' ',last_name) full_name
from employee_demographics;

select trim('          sky             ')
union
select ltrim('          sky             ')
union
select rtrim('          sky             ');

select first_name,last_name,salary,
case
    when salary <50000 then salary+(salary*0.05)
    when salary >50000 then salary+(salary*0.07)
end as new_salary,
case
     when dept_id=6 then salary * .10
end as bonus
from employee_salary;

select *
from employee_demographics
where employee_id in (select employee_id
                         from employee_salary
                         where dept_id=1)
 ;                        
 
 select first_name,salary,
 (select avg(salary) 
 from employee_salary) as avg_salary
 from employee_salary;
 
 select gender,avg(`max(age)`)
 from
 (select gender,avg(age),max(age),min(age),count(age)
 from employee_demographics
 group by gender)as agg_table
 group by gender;
 
  select avg(`max(age)`)
 from
 (select avg(age),max(age),min(age),count(age)
 from employee_demographics
 group by gender)as agg_table
 ;
 
 select gender,avg(maxage)
 from
 (select gender,avg(age) as avgage,max(age) as maxage,min(age) as minage,count(age) as tage
 from employee_demographics
 group by gender)as agg_table
 group by gender;
 
 #window functions
 
 select gender,avg(salary) over(partition by gender)
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id;
 
 #difference between group by and window functions
 
 select dem.first_name,dem.last_name, gender,avg(salary) over()
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id;
 
 select dem.first_name,dem.last_name, gender,avg(salary) over(partition by gender)
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id;
 
 select dem.first_name,dem.last_name,gender,avg(salary)
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id
 group by dem.first_name,dem.last_name,gender
 order by gender;
 
 #rolling total starts at specific value and increments the value of the subsquent rows 
 
 select dem.first_name,dem.last_name, gender,salary,
 sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id;
 
 #row number function give the position of each row,it gives a unique number
 #rank gives the rank of the value of the order by column positionally
#dense rank give the rank of the value of the order by column numerically 

  select dem.employee_id,dem.first_name,dem.last_name, gender,salary,
 row_number() over(partition by gender order by salary desc) as row_num,
 rank() over(partition by gender order by salary desc) as rank_num,
 dense_rank() over(partition by gender order by salary desc) as dense_rank_num
 from employee_demographics dem
 join employee_salary sal
 on dem.employee_id=sal.employee_id;
 
 #CTE is to make a complex code more readable
 
 with CTE_example (Gender,Avg_sal,Max_sal,Min_sal) as
 (select gender,avg(salary),max(salary),min(salary) 
        from employee_demographics dem
        join employee_salary sal 
                 on dem.employee_id=sal.employee_id
        group by gender
  )
  select * from CTE_example;
 
 with CTE_example as
 (select gender,avg(salary) avg_sal,max(salary) max_sal,min(salary) min_sal
        from employee_demographics dem
        join employee_salary sal 
                 on dem.employee_id=sal.employee_id
        group by gender
  )
  select avg(avg_sal) from CTE_example;
  
  with CTE_example as
  (
      select employee_id,birth_date,gender
      from employee_demographics
      where birth_date > "1985-01-01"
   ),
   CTE_example2 as
   (
       select employee_id,salary
         from employee_salary
         where salary >50000
	)
    select * from CTE_example 
        join CTE_example2
            on CTE_example.employee_id=CTE_example2.employee_id; 
            

  #Temporary tables
  
  create temporary table temp_table
  (first_name varchar(50),
   last_name varchar(50),
   fav_movie varchar(100)
   );
   
   select * from temp_table;
   
   insert into temp_table 
   values("alex","Freberg","Lord of the rings:The two towers" 
   );
   
   create temporary table Salary_over_50k
   select * from employee_salary
     where salary >= 50000;
   
   select * from Salary_over_50k;
   
   # Stored Procedures 
   create procedure large_salaries()
   select * from employee_salary
     where salary >= 50000;
     
     call large_salaries();
     
  delimiter $$
  create procedure large_salaries2()
  BEGIN
      select *
      from employee_salary
      where salary >=50000;
      select *
      from employee_salary
      where salary >=10000;
  END $$
  DELIMITER ;
  
  call large_salaries2();
  
  delimiter $$
  create procedure large_salaries3(emp_id int)
  begin
       select salary 
       from employee_salary
       where employee_id=emp_id;
  end $$
  delimiter ;
  
  call large_salaries3(1);
  
  # Triggers 
  
  delimiter $$
  create trigger employee_insert
	after insert on employee_salary
	for each row
    begin
		insert into employee_demographics(employee_id,first_name,last_name)
        values(new.employee_id,new.first_name,new.last_name);
	end $$
    delimiter ;
  
  insert into employee_salary(employee_id,first_name,last_name,occupation,salary,dept_id)
  values(13,'Jean-Ralphio','Saperstein','Entertainment 720 CEO',1000000,null);
  
  -- Events
  
  delimiter $$
  create event delete_retirees
  on schedule every 30 second
  do
  begin
	delete 
    from employee_demographics
    where age >=60;
  end $$
  delimiter ;
  
  show variables like 'event%' ;
  
 
  
  
  