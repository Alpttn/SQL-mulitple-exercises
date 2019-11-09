--1
--SELECT e.Id AS EmployeeId, e.FirstName, e.LastName, e.DepartmentId, e.IsSupervisor, d.Name AS DepartmentName
--                                          FROM Employee e LEFT JOIN Department d ON e.departmentId = d.Id
--										  ORDER BY d.Name ASC, e.LastName, e.FirstName
--2
--Select * FROM Department
--ORDER BY Budget DESC
--3
--SELECT d.Name AS DepartmentName, e.Id AS EmployeeId, e.FirstName, e.LastName, e.DepartmentId, e.IsSupervisor 
--                                          FROM Department d LEFT JOIN Employee e ON e.departmentId = d.Id
--										  WHERE e.IsSupervisor = 1
--4
--SELECT e.DepartmentId, Name, COUNT(*) 
--FROM Employee e INNER JOIN Department d ON e.DepartmentId = d.Id
--GROUP BY e.DepartmentId, Name
--5
--SELECT * FROM Department

--UPDATE Department
--SET Budget = Budget * 1.2
--SELECT * FROM Department

--6
--SELECT  e.FirstName + ' ' + e.LastName AS EMPLOYEE_NOT_IN_TRAININGS 
                                            
--                                          FROM Employee e 
--                                          LEFT JOIN EmployeeTraining et ON et.EmployeeId = e.Id 
--										  WHERE
--											NOT EXISTS( SELECT 
--											1
--										FROM
--											Employee
--										 WHERE
--											et.EmployeeId = e.Id);
--7
--SELECT  e.FirstName + ' ' + e.LastName AS EMPLOYEE_IN_TRAININGS, COUNT(*) AS Number_of_Trainings
--                                          FROM Employee e 
--                                          LEFT JOIN EmployeeTraining et ON et.EmployeeId = e.Id 
--										  WHERE
--											EXISTS( SELECT 
--											1
--										FROM
--											Employee
--										 WHERE
--											et.EmployeeId = e.Id)
--											GROUP BY e.FirstName, e.LastName
--8
--SELECT * FROM TrainingProgram
--SELECT t.Name, COUNT(et.Id) AS Number_of_attendees
--FROM 
--TrainingProgram t 
--JOIN EmployeeTraining et ON et.TrainingProgramId = t.Id
--GROUP BY t.Name

--9
--SELECT * FROM TrainingProgram

--SELECT t.Name AS Traingin_Program_At_Capacity, COUNT(et.Id) AS Number_of_attendees
--FROM 
--TrainingProgram t 
--JOIN EmployeeTraining et ON et.TrainingProgramId = t.Id
--GROUP BY t.Name, t.MaxAttendees
--HAVING
--COUNT(*) = t.MaxAttendees

--10
--SELECT Name, StartDate 
--FROM TrainingProgram
--WHERE StartDate > GETDATE()

--11
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (1, 8);
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (2, 8);
--INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (3, 8);

--12 List the top 3 most popular training programs. (For this question, consider each record in the training program table 
--to be a UNIQUE training program).
SELECT TOP 3 t.Id, t.Name, COUNT(et.Id) AS Number_of_attendees
FROM 
TrainingProgram t 
JOIN EmployeeTraining et ON et.TrainingProgramId = t.Id
GROUP BY t.Id, t.Name
ORDER BY COUNT(*) DESC

--13 List the top 3 most popular training programs. (For this question consider training programs with the same name
--to be the SAME training program).
SELECT TOP 3 t.id, t.Name, COUNT(et.Id) AS Number_of_attendees
FROM 
TrainingProgram t 
JOIN EmployeeTraining et ON et.TrainingProgramId = t.Id
GROUP BY t.id, t.Name
ORDER BY COUNT(et.employeeId) DESC

--14 List all employees who do not have computers.
SELECT * FROM Employee
SELECT * FROM Computer
SELECT * FROM ComputerEmployee


SELECT e.Id, e.FirstName, e.LastName
FROM Employee e LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
WHERE
										 NOT EXISTS( SELECT 
											ce.EmployeeId	
										FROM
											ComputerEmployee 
										 WHERE
											e.Id = ce.EmployeeId);

--get employees that have computer
SELECT DISTINCT e.Id, e.FirstName, e.LastName
FROM Employee e 
LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
WHERE ce.ComputerId IS NOT NUll
	AND ce.UnassignDate IS NULL

--employees without computer
SELECT DISTINCT e.Id, e.FirstName, e.LastName
FROM Employee e 
WHERE e.Id NOT IN (
	SELECT DISTINCT e.Id
	FROM Employee e 
	LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
	WHERE ce.ComputerId IS NOT NULL
		AND ce.UnassignDate IS NULL
)
										



