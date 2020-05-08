CREATE DATABASE "Group6_The_Premier_League_Club_Management"

CREATE TABLE dbo.Club
	(
	ClubID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubName VARCHAR(60) NOT NULL,
	Ground VARCHAR(60) NOT NULL,
	Capacity INT NOT NULL,
	Location VARCHAR(60) NOT NULL
	);
	
CREATE TABLE dbo.OperationExpenses
	(
	OperationExpensesRecordID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	[Type] VARCHAR(60) NOT NULL,
	expense MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL
	);
	
CREATE TABLE dbo.Sponsorship
	(
	SponserRecordID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	[Type] VARCHAR(60) NOT NULL,
	SponsorName VARCHAR(60) NOT NULL,
	SponsorshipFee MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL
	);
	
	
CREATE TABLE dbo.BroadcastingRevenue
	(
	BroadcastingRecordID INT  NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	Revenue MONEY NOT NULL,
	BroadcastingCompanyName VARCHAR(60) NOT NULL,
	Season VARCHAR(60) NOT NULL
	);
	
CREATE TABLE dbo.PremierLeagueBonus 
	(
	PremierLeagueBonusID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	Ranking INT NOT NULL,
	Bonus MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL
	);
	
CREATE TABLE dbo.EuropeCompetationBonus
	(
	EuropeCompetationBonusID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	CompetationName VARCHAR(60) NOT NULL,
	Title VARCHAR(60) NOT NULL,
	Bonus MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL
	);

CREATE TABLE dbo.Ticket_Sale
	(
	Ticket_SaleID INT IDENTITY NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	Amount INT NOT NULL,
	Revenue MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL
	);

CREATE TABLE dbo.Salary
	(
	SalaryRecordID INT IDENTITY NOT NULL PRIMARY KEY,
	SalaryAmount MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL,
	ClubID INT NOT NULL,
	);

CREATE TABLE dbo.TransferEvent
	(
	TransferID INT IDENTITY NOT NULL PRIMARY KEY,
	FootballerID INT NOT NULL,
	InClubID INT NOT NULL REFERENCES Club(ClubID),
	OutClubID INT NOT NULL REFERENCES Club(ClubID),
	TransferFee MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL,
	);


CREATE TABLE dbo.Coach
	(
	CoachID INT IDENTITY NOT NULL,
	Season VARCHAR(60) NOT NULL,
	CONSTRAINT PKCoach PRIMARY KEY CLUSTERED(CoachID,Season),
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	SalaryRecordID INT NOT NULL REFERENCES Salary(SalaryRecordID),
	FirstName VARCHAR(60) NOT NULL,
	LastName VARCHAR(60) NOT NULL,
	Nationality VARCHAR(60) NOT NULL,
	BirthDate DATE NOT NULL
	);


CREATE TABLE dbo.Footballer
	(
	FootballerID INT NOT NULL,
	Season VARCHAR(60) NOT NULL,
	CONSTRAINT PKFootballer PRIMARY KEY CLUSTERED(FootballerID,Season),
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	SalaryRecordID INT REFERENCES Salary(SalaryRecordID),
	FirstName VARCHAR(60) NOT NULL,
	LastName VARCHAR(60) NOT NULL,
	Nationality VARCHAR(60) NOT NULL,
	[Position] VARCHAR(60) NOT NULL,
	BirthDate DATE NOT NULL,
	Appearances INT,
	ShirtNumber INT
	);

CREATE TABLE dbo.Shirt_Sale
	(
	ShirtSaleID INT  NOT NULL PRIMARY KEY,
	ClubID INT NOT NULL REFERENCES Club(ClubID),
	FootballerID INT NOT NULL,
	SalesAmount INT NOT NULL,
	Revenue MONEY NOT NULL,
	Season VARCHAR(60) NOT NULL,
	);

ALTER TABLE dbo.TransferEvent ADD CONSTRAINT fk_transferEvent FOREIGN KEY(FootballerID,Season ) REFERENCES Footballer(FootballerID,Season);
ALTER TABLE dbo.Shirt_Sale ADD CONSTRAINT fk_Shirt_Sale FOREIGN KEY(FootballerID,Season ) REFERENCES Footballer(FootballerID,Season);


--DROP DATABASE "Group6_The_Premier_League_Club_Management";



-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------


-- Create View For Group6 Project
SELECT * FROM Footballer
SELECT * FROM Club
SELECT * FROM Salary
SELECT * FROM Sponsorship
SELECT * FROM Ticket_Sale
SELECT * FROM PremierLeagueBonus
SELECT * FROM EuropeCompetationBonus
SELECT * FROM Shirt_Sale
SELECT * FROM BroadcastingRevenue
SELECT * FROM TransferEvent
SELECT * FROM Coach
SELECT * FROM OperationExpenses

-- Create View of the information of Footballers who are from England

CREATE VIEW dbo.FootballerFromEngland_vw
AS
   SELECT f.ClubID, ClubName,f.Season,f.FootballerID,f.FirstName,f.LastName,f.Nationality,f.Position,f.BirthDate,f.Appearances,f.ShirtNumber
   FROM Footballer f
   INNER JOIN Club c
   ON f.ClubID = c.ClubID
WHERE f.Nationality = 'England'
GROUP BY f.ClubID, ClubName,f.Season,f.FootballerID,f.FirstName,f.LastName,f.Nationality,f.Position,f.BirthDate,f.Appearances,f.ShirtNumber

SELECT * FROM  dbo.FootballerFromEngland_vw



-- Create the View of Club which have  the most ticket sales in 2017/18 season

CREATE VIEW dbo.MostTicketSaleIn17to18_vw
AS
    SELECT TOP 1 WITH TIES  t.ClubID, ClubName, t.Season, t.Revenue AS HighestTicketSales
    FROM Ticket_Sale t
    JOIN Club c
    ON t.ClubID = c.ClubID
    WHERE t.Season = '2017/18'
    ORDER BY t.Revenue DESC;
   
   SELECT * FROM  dbo.MostTicketSaleIn17to18_vw
   
   -- Create the View of Club which have saled the most amount of tickets in 2016/17 season
   CREATE VIEW dbo.MostTicketAmountsIn16to17_vw
AS
    SELECT TOP 1 WITH TIES  t.ClubID, ClubName, t.Season, t.Amount AS MostTicketsAmounts
    FROM Ticket_Sale t
    JOIN Club c
    ON t.ClubID = c.ClubID
    WHERE t.Season = '2016/17'
    ORDER BY t.Amount DESC;
   
   SELECT * FROM  dbo.MostTicketAmountsIn16to17_vw
   
   -- Create View of the Club who had the highest ticket price in 2015/16 season
   CREATE VIEW dbo.HighstTicketPriceIn15to16_vw
AS
    SELECT TOP 1 WITH TIES  t.ClubID, ClubName, t.Season, (t.Revenue/t.Amount)AS HighstTicketPrice
    FROM Ticket_Sale t
    JOIN Club c
    ON t.ClubID = c.ClubID
    WHERE t.Season = '2015/16'
    ORDER BY t.Amount DESC;
   
   SELECT * FROM  dbo.HighstTicketPriceIn15to16_vw
   
--Create View of the club with total sponsorship fee in 2017/18 season

CREATE VIEW dbo.ClubTotalSponsorShipIn17to18_vw
AS
   SELECT temp.ClubID, c.ClubName, ROUND(TotalSponsorship, 2) [Total Sponsorship Fee] FROM
   (
      SELECT sp.ClubID, SUM(sp.SponsorshipFee) as TotalSponsorship,
              RANK() OVER (PARTITION BY sp.ClubID ORDER BY SUM(sp.SponsorshipFee) DESC) as rank
       FROM Sponsorship sp
       WHERE Season = '2017/18'
       GROUP BY sp.ClubID ) temp
  JOIN Club c
  ON temp.ClubID = c.ClubID

  SELECT * FROM dbo.ClubTotalSponsorShipIn17to18_vw
  
 
  -- Create View of the Club with  all types of income in 2017/18 season
  CREATE VIEW dbo.ClubIncomeIn17to18_vw
  AS
     SELECT  ss.Season,c.ClubID, c.ClubName, ss.Revenue as ShirtIncome,SUM(te.TransferFee) as TransferIncome, ts.Revenue as TicketIncome,
             ecb.Bonus as EuropeCompetationBonus, plb.Bonus as PremierLeagueBonus, bb.Revenue as BroadcastingIncome, SUM(sp.SponsorshipFee) as SponsorshipIncome
     FROM Club c
     INNER JOIN Shirt_Sale ss
     ON c.ClubID = ss.ClubID
     INNER JOIN TransferEvent te
     ON c.ClubID = te.OutClubID
     INNER JOIN Ticket_Sale ts
     ON c.ClubID = ts.ClubID
     INNER JOIN EuropeCompetationBonus ecb
     ON c.ClubID = ecb.ClubID
     INNER JOIN PremierLeagueBonus plb
     ON c.ClubID = plb.ClubID
     INNER JOIN BroadcastingRevenue bb
     ON c.ClubID = bb.ClubID
     INNER JOIN Sponsorship sp
     ON c.ClubID = sp.ClubID
     WHERE ss.Season = '2017/18' and te.Season = '2017/18' and ts.Season = '2017/18' and ecb.Season = '2017/18' 
           and plb.Season = '2017/18'  and bb.Season = '2017/18' and sp.Season = '2017/18' 
     GROUP BY ss.Season,c.ClubID, c.ClubName, ss.Revenue, ts.Revenue,
             ecb.Bonus, plb.Bonus, bb.Revenue
    SELECT * FROM dbo.ClubIncomeIn17to18_vw


    CREATE VIEW vWFootballerSalary 
	AS
		SELECT FootballerID, FirstName, LastName, [Position], MAX(SalaryAmount) SalaryAmount
		FROM Footballer f
		JOIN Salary s
		ON f.SalaryRecordID = s.SalaryRecordID 
		GROUP BY FootballerID, FirstName, LastName, [Position]

	SELECT * FROM vWFootballerSalary
     
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
  
   
-- Table-level CHECK Constraint
--(According to the rules of the Premier League, the total number of applicants for each team cannot exceed 26 )
-- Create a function, which will return the number of footballer one club has
CREATE FUNCTION CheckAmountofFootballerInOneClub(@ClubID INT,@Season VARCHAR(60))
RETURNS INT
AS
	BEGIN
		DECLARE @Count INT = 0;
		SELECT @Count = COUNT(FootballerID)
				FROM dbo.Footballer
				WHERE ClubID = @ClubID and Season = @Season;
		RETURN @Count;
	END;


SELECT count(FootballerID) from dbo.Footballer WHERE ClubID=2 AND Season='2015/16'
SELECT dbo.CheckAmountofFootballerInOneClub(1,'2017/18')
-- Add table-level CHECK constraint based on the new function for the Footballer table
ALTER TABLE dbo.Footballer
	ADD CONSTRAINT LimitTheNumberOfFootballer
	CHECK (dbo.CheckAmountofFootballerInOneClub(ClubID,Season) <=26 ); 
-- To check if one club has more than twenty five footballer, then we cannot add more
INSERT INTO dbo.Footballer
VALUES('2015/16',2,153,'Edersn','Morads','Brazil','Goalkeeper','1993-08-17',67,45);


-- Housekeeping
ALTER TABLE dbo.Footballer DROP CONSTRAINT LimitTheNumberOfFootballer;
DROP FUNCTION CheckAmountofFootballerInOneClub;



-- Table-level CHECK Constraint
--(According to the rules of the Premier League, each type of sponsorship of each club only have one sponsor )
-- Create a function, which will return the number of one type of sponsorship one club has
CREATE FUNCTION CheckTheNumberOfOneTypeOfSponsorship(@ClubID INT,@Type VARCHAR(60),@Season VARCHAR(60))
RETURNS INT
AS
	BEGIN
		DECLARE @Count INT = 0;
		SELECT @Count = COUNT(SponserRecordID)
				FROM dbo.Sponsorship
				WHERE ClubID = @ClubID and Type = @Type and Season = @Season;
		RETURN @Count;
	END;

-- Add table-level CHECK constraint based on the new function for the Sponsorship table
ALTER TABLE dbo.Sponsorship
	ADD CONSTRAINT LimitTheNumberOfSponsor
	CHECK (dbo.CheckTheNumberOfOneTypeOfSponsorship(ClubID,[Type],Season) <= 1); 
-- To check if one club has one sponsor in one type of sponsorship, then we cannot add more
INSERT INTO dbo.Sponsorship
VALUES(4,'front of shirt sponsorship','Bank of America',302325543.4800,'2016/17');

-- Housekeeping
ALTER TABLE dbo.Sponsorship DROP CONSTRAINT LimitTheNumberOfSponsor;
DROP FUNCTION CheckTheNumberOfOneTypeOfSponsorship;


-- Table-level CHECK Constraint
--(According to the rules of the Premier League, each culb only have one main coach)
--Create a function, which will return the number of mian coach one club has
CREATE FUNCTION CheckTheNumberOfCoachOfOneClub(@ClubID INT,@Season VARCHAR(60))
RETURNS INT
AS
	BEGIN
		DECLARE @Count INT = 0;
		SELECT @Count = COUNT(CoachID)
				FROM dbo.Coach
				WHERE ClubID = @ClubID and Season = @Season;
		RETURN @Count;
	END;

-- Add table-level CHECK constraint based on the new function for the Coach table
ALTER TABLE dbo.Coach
	ADD CONSTRAINT TheNumberOfCoachOfOneClub
	CHECK (dbo.CheckTheNumberOfCoachOfOneClub(ClubID,Season) <= 1); 
-- To check if one club has one coach, then we cannot add more
INSERT INTO dbo.Coach
VALUES('2017/18',1,422,'Josep','Guardiola','Spain','1971-01-18');

-- Housekeeping
ALTER TABLE dbo.Coach DROP CONSTRAINT TheNumberOfCoachOfOneClub;
DROP FUNCTION CheckTheNumberOfCoachOfOneClub;

-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------


-- Computed Column based on a function
-- Insert wage gap in dbo.Footballer 
CREATE FUNCTION calculateWageGap (@footballerID INT,@Season VARCHAR(60))
RETURNS money
AS
BEGIN
	DECLARE @wageGap money;
	
	SELECT @wageGap = (SELECT s.SalaryAmount -
	(
		SELECT AVG(s.SalaryAmount)
		FROM dbo.Salary s JOIN dbo.Footballer f
		ON f.SalaryRecordID = s.SalaryRecordID
		WHERE s.Season = @Season
	)
	FROM dbo.Salary s  JOIN dbo.Footballer f
	ON f.SalaryRecordID = s.SalaryRecordID
	WHERE f.FootballerID = @footballerID
	AND s.Season = @Season)
	;
	
	RETURN @wageGap;
END

-- Add a computed column WageGap to the dbo.Footballer
ALTER TABLE dbo.Footballer
	ADD WageGap AS (dbo.calculateWageGap(FootballerID,season));

SELECT FootballerID, WageGap
From dbo.Footballer;

-- Housekeeping
ALTER TABLE dbo.Footballer DROP COLUMN WageGap;
DROP FUNCTION calculateWageGap;


--Computed Columns based on a function
CREATE FUNCTION ShirtsRevenueTotal
(
	@Season VARCHAR(60),
	@ClubID INT
)
RETURNS MONEY
AS 
	BEGIN
		DECLARE @total Money = 
			(SELECT SUM(Revenue) ShirtTotalRevenue
			 FROM dbo.Shirt_Sale
			 WHERE Season = @Season AND ClubID = @ClubID)
		SET @total = ISNULL(@total, 0) 
		RETURN @total
	END

-- CHECK FUNCTION
SELECT dbo.ShirtsRevenueTotal('2017/18',1)

--ShirtsSaleTotal Function to Check Shirts Revenue By Club By Season
CREATE FUNCTION ShirtsSaleTotal
(
	@Season VARCHAR(60),
	@ClubID INT
)
RETURNS TABLE
AS 
RETURN
	SELECT 
		ClubID,
		Season,
		SUM(SalesAmount) ShirtTotalSaleAmount,
		SUM(Revenue) ShirtTotalRevenue
	FROM dbo.Shirt_Sale
	GROUP BY ClubID, Season
	HAVING
		Season = @Season AND ClubID = @ClubID 
		
-- Check
SELECT * FROM dbo.ShirtsSaleTotal('2017/18', 1)


--Function to return all total revenue from different sources by club by season
CREATE FUNCTION RevenueOverall_t
(
	@Season VARCHAR(60),
	@ClubID INT
)
RETURNS @t TABLE
(
	RevenueSource VARCHAR(60),
	Revenue MONEY	
)
AS 
BEGIN
	
	INSERT INTO @t
	VALUES 
	(
		'Shirt', 
		(SELECT 
			SUM(Revenue) ShirtTotalRevenue
		FROM dbo.Shirt_Sale
		WHERE
			Season = @Season AND ClubID = @ClubID)
	)
			
	INSERT INTO @t
	VALUES 
	(
		'Ticket', 
		(SELECT 
			SUM(Revenue) TicketTotalRevenue
		FROM dbo.Ticket_Sale
		WHERE
			Season = @Season AND ClubID = @ClubID)
	)
	RETURN

END
	
--CHECK
SELECT * FROM dbo.RevenueOverall_t('2017/18', 1)

--Encrypt Login Passwords of group
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Group6_P@sswOrd';

CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'AdventureWorks Test Certificate',
EXPIRY_DATE = '7019-03-31';

CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;

UPDATE Staff_Login
SET EncryptedPassword = ENCRYPTBYKEY(Key_GUID('TestSymmetricKey'),CONVERT(VARBINARY,EncryptedPassword));

SELECT*FROM Staff_Login
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- Create View of the Club with  all types of expenses and total expense in 2017/18 season
    CREATE VIEW dbo.ClubExpensesSeason17to18_vw
  AS
    WITH coachExpense AS
    (
        SELECT c.ClubID,
     s.SalaryAmount
         FROM Coach c JOIN Salary s
         ON c.SalaryRecordID = s.SalaryRecordID
         WHERE c.Season = '2017/18' and c.ClubID BETWEEN 1 and 6  
    ),
    FootballerExpense AS
    ( 
      SELECT f.ClubID, SUM(s.SalaryAmount) AS FootballerSalaries
      FROM Footballer f JOIN Salary s 
      ON f.SalaryRecordID = s.SalaryRecordID
      WHERE f.Season = '2017/18'
      GROUP BY f.ClubID
    ),
    OperationExpense AS
    (
       SELECT ClubID, SUM(expense) as OperationExpense
       FROM OperationExpenses
       WHERE OperationExpenses.Season = '2017/18'
       GROUP BY ClubID
    ),
    transferExpense AS
    (
       SELECT InClubID, SUM(TransferFee) as TransferExpense
       FROM TransferEvent
       WHERE TransferEvent.Season = '2017/18' AND InClubID BETWEEN 1 and 6
       GROUP BY InClubID
    )
    SELECT c.ClubID, cc.ClubName,c.SalaryAmount as CoachSalaryExpense,f.FootballerSalaries as FootballerTotalSalaryExpense,o.OperationExpense,isnull(t.TransferExpense,0) AS TransferExpense,
           (c.SalaryAmount + f.FootballerSalaries+o.OperationExpense+isnull(t.TransferExpense,0)) AS totalExpenses
           FROM coachExpense c JOIN Club cc
           ON c.ClubID = cc.ClubID
           JOIN FootballerExpense f
           ON c.ClubID = f.ClubID
           JOIN OperationExpense o
           ON c.ClubID = o.ClubID
           LEFT JOIN transferExpense t 
           ON c.ClubID = t.InClubID
     SELECT * FROM ClubExpensesSeason17to18_vw


-- Create View of the Club with  all types of income and total income in 2017/18 season
     CREATE VIEW dbo.ClubIncomesInSeason17to18_vw
  AS
     WITH shirtIncome AS
    (
         SELECT ClubID, SUM(Revenue) as ShirtIncome
         FROM Shirt_Sale
         WHERE Shirt_Sale.Season = '2017/18'
         GROUP BY ClubID    
    ),
    transferIncome AS
    (
       SELECT OutClubID, SUM(TransferFee) as TransferIncome
       FROM TransferEvent
       WHERE TransferEvent.Season = '2017/18' AND OutClubID BETWEEN 1 and 6
       GROUP BY OutClubID
    ),
    sponsorshipIncome AS
    (
       SELECT ClubID,  SUM(SponsorshipFee) as SponsorshipIncome
       FROM Sponsorship
       WHERE Sponsorship.Season = '2017/18'
       GROUP BY ClubID
    ),
    broadcastingIncome AS
    (
       SELECT ClubID, Revenue as BoradcastingIncome
       FROM BroadcastingRevenue
       WHERE BroadcastingRevenue.Season = '2017/18'
       GROUP BY ClubID,Revenue
    ),
    premierLeagueBonusIncome AS
    (
       SELECT ClubID, Bonus as PremierLeagueBonusIncome
       FROM PremierLeagueBonus
       WHERE PremierLeagueBonus.Season = '2017/18'
       GROUP BY ClubID,Bonus
    ),
    europeCompetationBonusIncome AS
    (
       SELECT ClubID, Bonus as EuropeCompetationBonusIncome
       FROM EuropeCompetationBonus
       WHERE EuropeCompetationBonus.Season = '2017/18'
       GROUP BY ClubID,Bonus
    ),
    ticketIncome AS
    (
       SELECT ClubID, Revenue as TicketIncome
       FROM Ticket_Sale
       WHERE Ticket_Sale.Season = '2017/18'
       GROUP BY ClubID,Revenue
    )
    SELECT s.ClubID, c.ClubName, s.ShirtIncome, isnull(t.TransferIncome,0) AS TransferTotalIncome, sp.SponsorshipIncome, b.BoradcastingIncome, p.PremierLeagueBonusIncome, 
           e.EuropeCompetationBonusIncome,tt.TicketIncome, (s.ShirtIncome+isnull(t.TransferIncome,0)+sp.SponsorshipIncome+b.BoradcastingIncome+p.PremierLeagueBonusIncome
                              +e.EuropeCompetationBonusIncome+tt.TicketIncome) AS TotalIncome
            FROM shirtIncome s JOIN Club

-- Create View of Club Total Income, Total Expense, and Pure Profit in Season 2017/18

CREATE VIEW dbo.ClubFinanceOverall17to18_vw
  AS
     SELECT c.ClubID,c.ClubName,ce.totalExpenses,ci.TotalIncome, ci.TotalIncome-ce.totalExpenses as PureProfit
     FROM Club c
     JOIN ClubExpensesSeason17to18_vw ce
     ON c.ClubID = ce.ClubID
     JOIN ClubIncomesInSeason17to18_vw ci
     ON c.ClubID = ci.ClubID
   
     SELECT * FROM dbo.ClubFinanceOverall17to18_vw
