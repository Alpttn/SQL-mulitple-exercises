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

--trying it with NOT EXISTS
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
) ORDER BY e.LastName --Added this order by and it worked

--14 ANDY's VERSION List all employees who do not have computers.

SELECT e.*
FROM Employee e
LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId 
WHERE ce.id is null
or e.id in (
	SELECT ce.EmployeeId 
	FROM ComputerEmployee ce
	WHERE ce.UnassignDate IS NOT NULL
		AND ce.EmployeeId NOT in (
					SELECT ce.EmployeeId
					FROM ComputerEmployee ce
					WHERE ce.UnassignDate IS NOT NULL
					)


--15 List all employees along with their current computer information make and manufacturer combined 
--into a field entitled ComputerInfo. If they do not have a computer, this field should say "N/A".

SELECT e.FirstName + ' ' + e.LastName AS Employees, ISNULL(c.Manufacturer + ' ' + c.Make, 'N/A') AS ComputerInfo
FROM Employee e 
LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
LEFT JOIN Computer c ON ce.ComputerId = c.Id

--15 Andy's version CORRECT VERSION
SELECT e.FirstName, e.LastName, 
	   ISNULL(c.Make + ' ' + c.Manufacturer, 'N/A') AS ComputerInfo
FROM Employee e
LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId AND ce.UnassignDate IS NULL
LEFT JOIN Computer c ON ce.ComputerId = c.Id

--16 List all computers that were purchased before July 2019 that are have not been decommissioned.
SELECT 
    Id, Manufacturer + ' ' + Make AS ComputersBoughtBeforeJuly2019StillInUse
FROM
    Computer
WHERE PurchaseDate < '2019-07-01'
AND DecomissionDate IS NULL
ORDER BY PurchaseDate DESC;

--17 List all employees along with the total number of computers they have ever had.
SELECT DISTINCT e.Id, e.FirstName, e.LastName, COUNT(ComputerId) NumOfComputers
FROM Employee e 
LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
GROUP BY e.Id, e.FirstName,e.LastName

--18 List the number of customers using each payment type
SELECT pt.Name, COUNT(c.Id)
FROM PaymentType pt LEFT JOIN Customer c ON pt.Id = c.Id
GROUP BY pt.Name

--19 List the 10 most expensive products and the names of the seller
SELECT TOP 10 p.Title, p.Price, c.FirstName + ' ' + c.LastName AS SELLER
FROM 
Product p
JOIN Customer c ON p.CustomerId = c.Id
ORDER BY p.Price DESC;

--20

--21 Find the name of the customer who has made the most purchases (most orders) THERE ARE TWO PEOPLE
SELECT c.FirstName, c.LastName, COUNT(o.customerId) AS OrdersPlaced
FROM Customer c
LEFT JOIN [Order] o ON c.id = o.CustomerId
GROUP BY c.FirstName, c.LastName
ORDER BY OrdersPlaced DESC
	--customer who has bought the most products
	SELECT top 1 with ties c.FirstName, c.LastName, COUNT(o.customerId) AS ProductsPurchased
	FROM Customer c
	LEFT JOIN [Order] o ON c.id = o.CustomerId
	LEFT JOIN OrderProduct op ON o.id = op.OrderId
	GROUP BY c.FirstName, c.LastName
	ORDER BY ProductsPurchased DESC














										
										


