--Loop_through_Table_Rows
--https://www.mssqltips.com/sqlservertip/6148/sql-server-loop-through-table-rows-without-cursor/
/*
CREATE TABLE Scratch.CursorTest
(
   CursorTestID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
   Filler        VARCHAR(4000), 
   RunningTotal  BIGINT 
)

INSERT INTO Scratch.CursorTest ( Filler, RunningTotal )
VALUES ( REPLICATE('a', 4000),  0  )
GO 500000

On the script above you will notice that I only used a single insert statement and I took advantage of the batch separator 
(the GO 500000 command) as a shortcut to execute this insert statement 500000 times. You can read more about this method 
to repeat batch execution on this tip: Executing a T-SQL batch multiple times using GO.

DECLARE @CursorTestID INT = 1;
DECLARE @RunningTotal BIGINT = 0;
DECLARE @RowCnt BIGINT = 0;

-- get a count of total rows to process 
SELECT @RowCnt = COUNT(0) FROM dbo.CursorTest;
 
WHILE @CursorTestID <= @RowCnt
BEGIN
   UPDATE dbo.CursorTest 
   SET RunningTotal = @RunningTotal  + @CursorTestID
   WHERE CursorTestID = @CursorTestID;

   SET @RunningTotal += @CursorTestID
    s
   SET @CursorTestID = @CursorTestID + 1 
 
END

