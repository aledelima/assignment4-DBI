-- Name: Alessandro Santos de Lima
-- ID: 300340437

USE WP;
GO




DROP VIEW IF EXISTS ProjectInfoView;
-- GO

CREATE VIEW ProjectInfoView AS
SELECT
P.ProjectName, P.Department, E.FirstName, E.LastName, A.HoursWorked
FROM
PROJECT P
LEFT JOIN ASSIGNMENT A ON P.ProjectID = A.ProjectID
INNER JOIN EMPLOYEE E ON A.EmployeeNumber = E.EmployeeNumber;
-- GO

SELECT 	*
FROM ProjectInfoView
ORDER BY ProjectName, Department, FirstName, LastName;
GO




DROP PROCEDURE IF EXISTS ProjectEmpSearch;
-- GO

CREATE PROCEDURE ProjectEmpSearch @ProjectName CHAR(50)
AS
SELECT FirstName, LastName, HoursWorked
FROM ProjectInfoView
WHERE	ProjectName  = @ProjectName
-- GO

EXEC ProjectEmpSearch @ProjectName = '2019 Q4 Marketing Plan'
GO



DROP FUNCTION IF EXISTS dbo.ProjectCost;
-- GO

CREATE FUNCTION dbo.ProjectCost
(
	@ProjectName CHAR(50),
	@HourlyRate FLOAT
)
RETURNS TABLE
AS
RETURN
	SELECT	ProjectName, SUM(HoursWorked) AS HoursWorked, SUM(HoursWorked) * @HourlyRate AS LaborCost
	FROM	ProjectInfoView V
	WHERE ProjectName = @ProjectName
	GROUP BY ProjectName;
-- GO

SELECT	*
FROM	dbo.ProjectCost('2019 Q4 Marketing Plan', 37.50);
GO