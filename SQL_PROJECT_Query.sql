/***  0. TABLE NAME 
SELECT*FROM treatments
SELECT*FROM appointments
SELECT*FROM insurance
SELECT*FROM patients
SELECT*FROM doctors
SELECT*FROM departments
***/

--Database Selection

USE HEALTHCARE
GO

--1.Retrieve all doctors who specialize in 'Cardiologist'

select * 
from doctors
where specialization = 'Cardiologist'

--2.Find all patients Blood groip 'O+'

select * from patients
where blood_type = 'O+'

--3.List all departments with their budget in descending order

select department_name,annual_budget
from departments
order by  department_name,annual_budget desc

--4.Count the total number of appointments scheduled

select count (status) as total_appointments 
from appointments
where status = 'Scheduled'

--5.Count how many doctors work in each department

select department_name,count (*)as doc from departments e
inner join doctors d on e.department_id=d.department_id
GROUP BY department_name
ORDER BY department_name DESC

-- ========== --

select department_name,first_name,count (*)as doc from departments e
inner join doctors d on e.department_id=d.department_id
GROUP BY department_name,first_name
ORDER BY department_name,first_name DESC

--6.List the top 5 most expensive treatments

select top 5 (treatment_cost)
from treatments
order by treatment_cost DESC

--7.Get the average treatment cost across all treatments

select AVG(treatment_cost) AS AVGCOST 
from treatments

--8.Find departments with a budget greater than 3000000.00

select *
from departments 
where annual_budget > 3000000.00

--9.List all patients whose names start with 'J'

select *
from patients
where first_name LIKE 'j%';

--10.List all insurance providers in the system

select distinct provider_name
from insurance

--11.Find patients who live in a specific city (e.g., 'Cambridge')

select * 
from patients
where city ='Cambridge'

--12 




