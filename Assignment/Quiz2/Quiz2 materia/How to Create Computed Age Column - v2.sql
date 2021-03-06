
-- Create a table with a computed column for age

USE Demo;

-- Create the table
-- Pay attention to how the Age column is defined

CREATE TABLE Personnel
(PersonnelID int IDENTITY Primary Key,
 LastName varchar(50),
 FirstName varchar(50),
 DateOfBirth Date,
 Age AS DATEDIFF(hour,DateOfBirth,GETDATE())/8766);

-- There are 8,766 hours for a year because there is a leap yaer every four years

SELECT (365*4+1)*24/4; 
-- 8766

-- Put some data in the table

INSERT INTO Personnel
Values ('Smith' , 'Mary' , '01-02-1990') ,
       ('Black' , 'Peter' , '02-02-1988') ,
	   ('Glory' , 'Rob' , '05-11-1991');

-- See what we got in the table
-- Pay attention to the computed Age column

SELECT * FROM Personnel;

-- Do housekeeping

DROP TABLE Personnel;


