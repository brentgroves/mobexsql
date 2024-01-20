On the script above you will notice that I only used a single insert statement and I took advantage of the batch separator (the GO 500000 command) as a shortcut to execute this insert statement 500000 times. You can read more about this method to repeat batch execution on this tip: Executing a T-SQL batch multiple times using GO.

CREATE TABLE CursorTest
(
   CursorTestID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
   Filler        VARCHAR(4000), 
   RunningTotal  BIGINT 
)
GO 
The idea is to loop trough the table rows ordered by the CursorTestID column and update the RunningTotal column with the sum of the CursorTestID column value and the value of the RunningTotal column of the previous row.

But before starting, first we need to generate some test rows with the next Transac-SQL script.

INSERT INTO dbo.CursorTest ( Filler, RunningTotal )
VALUES ( REPLICATE('a', 4000),  0  )
GO 500000
On the script above you will notice that I only used a single insert statement and I took advantage of the batch separator (the GO 500000 command) as a shortcut to execute this insert statement 500000 times. You can read more about this method to repeat batch execution on this tip: Executing a T-SQL batch multiple times using GO.

Simple Example of a Basic Cursor to Loop through Table Rows in SQL Server
Let’s create a cursor to fill the RunningTotal column. Notice on the following example that I declared the cursor with the option FAST_FORWARD. This is done in order to enhance the performance of the cursor because according to Microsoft the FAST_FORWARD argument “Specifies a FORWARD_ONLY, READ_ONLY cursor with performance optimizations enabled”. In other words, we are instructing SQL Server to use a read only cursor that can only move forward and be scrolled from the first to the last row.  Here is the syntax:

DECLARE @CursorTestID INT;
DECLARE @RunningTotal BIGINT = 0;
 
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
    SELECT CursorTestID RunningTotal
    FROM   CursorTest
    ORDER BY CursorTestID;
 
OPEN CUR_TEST
FETCH NEXT FROM CUR_TEST INTO @CursorTestID
 
WHILE @@FETCH_STATUS = 0
BEGIN
   UPDATE dbo.CursorTest 
   SET RunningTotal = @RunningTotal + @CursorTestID
   WHERE CursorTestID = @CursorTestID;

   SET @RunningTotal += @CursorTestID

   FETCH NEXT FROM CUR_TEST INTO @CursorTestID
END
CLOSE CUR_TEST
DEALLOCATE CUR_TEST
GO
