--Hello Brent, Trying to turn a varchar string into a numeric or int type. Do you have any suggestions? The normal varchar string looks like 'Scrap QTY: 3.00000'
 
--Brad found this answer
convert(numeric, REPLACE(TRANSLATE(note, 'abcdefghijklmnopqrstuvwxyz+()- ,#+:;', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', ''))

--https://www.sqlshack.com/sql-varchar-data-type-deep-dive/
