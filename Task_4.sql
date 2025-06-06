CREATE DATABASE TASK_4;

USE TASK_4;

SELECT * FROM EMP;
SELECT * FROM EMP_SAL;

--1. Find the number of employees in each city who joined after January 1, 2020, and display the result in descending order of employee count--
SELECT CITY, COUNT(EID) AS 'EMP_COUNT'
FROM EMP
WHERE DOJ > '2020-01-01'
GROUP BY CITY
ORDER BY COUNT(EID) DESC;

--2. Find the total salary paid to employees in each city where the total salary is more than 1,00,000. Order the results by total salary descending--
SELECT CITY, SUM(SALARY) AS 'TOTAL_SAL' 
FROM EMP
LEFT JOIN EMP_SAL
ON EMP.EID = EMP_SAL.EID
GROUP BY CITY
HAVING SUM(SALARY) > 100000
ORDER BY SUM(SALARY) DESC;

--3. Find the names of employees who earn more than the average salary of all employees--
SELECT NAME FROM EMP
WHERE EID IN (
	SELECT EID 
	FROM EMP_SAL
	WHERE SALARY > (SELECT AVG(SALARY) FROM EMP_SAL)
	);

--4. Write a query to list all departments with at least 3 employees, showing the number of employees, total salary, average salary, minimum salary, and maximum salary paid in each department--
CREATE VIEW DEPT_SALARY_SUMMARY
AS
SELECT DEPT, COUNT(EID) AS 'No_of_Employees', SUM(SALARY) AS 'Total_Salary', AVG(SALARY) AS 'Avg_Salary', MIN(SALARY) AS 'Min_Salary', MAX(SALARY) AS 'Max_Salary'
FROM EMP_SAL
GROUP BY DEPT
HAVING COUNT(EID)> 3;

SELECT * FROM DEPT_SALARY_SUMMARY;

--5. Suggest an appropriate index to optimize a query that filters employees based on their city and date of joining, and orders the results by employee name--
CREATE INDEX EMP_CITY_DOJ_NAME
ON EMP (CITY, DOJ, NAME);

--6. Write a SQL query to find the top 3 departments with the highest average salary for employees who joined after January 1, 2020, along with the number of employees in each department. Only include employees living in cities where the average salary across all departments is above 70,000. Display department name, average salary and employee count in each department in alphabetical order--
SELECT TOP 3 DEPT, AVG(SALARY) AS 'AVG_SAL', COUNT(EMP.EID) AS 'EMP_COUNT' 
FROM EMP_SAL
JOIN EMP
ON EMP.EID = EMP_SAL.EID
WHERE DOJ > '2020-01-01'
AND CITY IN (
	SELECT CITY FROM EMP
	JOIN EMP_SAL
	ON EMP.EID = EMP_SAL.EID
	GROUP BY CITY
	HAVING AVG(SALARY)> 70000
	)
GROUP BY DEPT
ORDER BY AVG(SALARY) DESC;