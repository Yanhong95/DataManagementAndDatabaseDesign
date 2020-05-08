
-- StringToValues Function Return A Table Variable

CREATE FUNCTION [dbo].StringToValues(@ListofIds nvarchar(max))
RETURNS @rtn TABLE (IntegerValue int)
AS
BEGIN
    WHILE(CHARINDEX(',', @ListofIds) > 0)
        BEGIN
            INSERT INTO @Rtn
                SELECT LTRIM(RTRIM(SUBSTRING(@ListofIds, 1, CHARINDEX(',', @ListofIds) - 1)));
            SET @ListofIds = SUBSTRING(@ListofIds, CHARINDEX(',', @ListofIds) + LEN(','), LEN(@ListofIds));
        END;
    INSERT INTO @Rtn SELECT LTRIM(RTRIM(@ListofIds));
    RETURN;
END;

-- Test the function

SELECT * FROM dbo.StringToValues('12100,14000,20000,38000,44220');

-- Housekeeping

DROP FUNCTION dbo.StringToValues;


