https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/
SELECT to_tsvector('The quick brown fox jumped over the lazy dog.'); 

SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('fox');
   
SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('foxes');
SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('foxtrot');

SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('jumping');   

SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('fox & dog');   
SELECT document_id, document_text FROM documents  
WHERE document_tokens @@ to_tsquery('jump & quick'); 
   
   SELECT count(*) FROM keys -- 14,940 reports51
SELECT count(*) FROM keys -- 8371808 moto
https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/

select keywords from keys 

select *  
from keys
-- where md5 like '%CE4%'
where keywords @@ to_tsquery('moto')  
ff016b90f22afcfaea82144bb67a4658
{"md5": "ff016b90f22afcfaea82144bb67a4658", "length": 1729, "packet": {"tag": 6, "data": "xsDNBGQ7Ae4BDACxwNHt6BdG4xqO3hhckB9Vmp85miU1enUbg0Xvmd+5g4ZY+8Jx/qYRBN2x5EOZQtLJD4gCTQKXh70h/7HbuGqM2TwItTpXRvYKRbaU4O6aKYZT6cQC9fZ4GNeRUI5/wukHfVM9jpRlvsiESTimS5TeB/D04wRrRjLpZEnH3n5nIsEc0EknLIbbxdqC9wApLn6rdW5kTu2Y+GZvr0m/cNpYhnUJXwLGRFvce73Pti0rsbx0qTD6n6t87g+YCGAqaULQv3FsKpwuOd8tPam+eNsc0M/1UVTVXhIaIj/SyJrhpY6lHCo/J7Cst7vCkkGK7ER6AWzddeHWoVn34c1aJmPCK2JcGqhFsJ3DRY63UrIaKdLJucKr3bz37+AeTSVP8H2AmIaooDQ4yV1Iv2TxOfflWaX8uBqQjelLZfj9ZmQu+YQVWe7IJ0lYPwIUhQFW9JYkQ+Mz2pZB7/y3307qdSKMmFXxh7RYZPuWElcTPv8RpowJRfLhWig0ni5s5/aKPm0AEQEAAQ==", "parsed": true}, "subKeys": [{"packet": {"tag": 14, "data": "zsDNBGQ7Ae4BDADILYOm8utTbXpYqJIj3k4mWVfV0SmDUlo2a4cT/llr4z5031M9XQ4c3k6dW9PgRB/jZaeH93R8S9rM1azaxW/c1eLioHyXiZFNum+2/foENKIVWODpAmtXafiVIuugUOHWQf0IUavomsjSm2ucbIVS7/sPBwf0xtu15KK/3dzSMpY6RIgozt3amSuRIwb6UOlqHxQFGAjdjgygYlGLmJ8JeZCMXhsqMd52RF2ojQhkizJus93pj+4jryp8wifEjWn7WO9+G0mK/WhI/yPcMmMroima9ksjWKrItJ/SUdVy/xeutvt//VPFBvRLskiJW6RKBle+HoSRqqb56m2HHJCv+YOmeHCghMC/Kw5sO/dEULK41KXARYVG+e0HHt5LkDdvnynWh3hYoxCTCyRJryTDNUp/DgZD5itq1EI86v0+wiOKj1UVOCSjSPk76ws9w+6SE/MicN21l4fj0Cm/JgcGEf1wxJDpQICMQtoNvEUsuGDzwaPmV3k+/7jZIAGmu4UAEQEAAQ==", "parsed": true}, "creation": "2023-04-15T19:58:38Z", "algorithm": {"code": 1, "name": "rsa"}, "bitLength": 3072, "longKeyID": "42c0828b7de5eb73", "shortKeyID": "7de5eb73", "signatures": [{"packet": {"tag": 2, "data": "wsD8BBgBCgAmFiEEI85H/KX15TD6VPgghYWG1K56Pm8FAmQ7Ae4CGwwFCQlmAYAACgkQhYWG1K56Pm8/rAv+ImripyTlgN1WlriOWRoL1BXWJjnHO0ahToOTvdoCnkOPclV2Xa2CkcTwXA0gCZUjLUq3F4t79bVZxLjOYLXJuQecpUp2mS/Ts66H9MLKZ3MvMZcQMfYnznHZ4+Qd99hlA/vqtGXsqqHsNDaDW9ev/aRvXNkzFREGC2kYOlpiqYeKlBjc6FTOyFyGX8eCDOthDb5xBmZnDL3Z+cBv7oGcRQ6Ody2A6Ezr8kr6h5FEJZQRMAkMmOHOGfmuGH18lK7yxpCT1nRhAqoDW6ansHegjWWeFCEd/F+ejbXbQVyGoCOybc4PdAdI7HghO29C+olI4MGEu1YzxJkBcZnDnFnJD3H+LDtcPDLksOfhHix3pWC0U4rSQ2IDQ6J9qEOHYwuX8ejs9OoEw5q140BRvZelK/6y4BiO/y8VCrw8nfOgsvM3rRZjHBqc+y4zQj2dWrx3aT1s4TXCSJomU/FZ5opaKURWXFfAk5ibUbO+iL0KTaRaiZfwI70iM5ICPDuV4zXY", "parsed": true}, "sigType": 24, "creation": "2023-04-15T19:58:38Z", "expiration": "2028-04-13T19:58:38Z", "issuerKeyID": "858586d4ae7a3e6f"}], "fingerprint": "c8b4582dd6213b8b4f4d2ff342c0828b7de5eb73", "neverExpires": true}], "userIDs": [{"packet": {"tag": 13, "data": "zRdCcmVudCBNb3RvIDxicmVudEBtb3RvPg==", "parsed": true}, "keywords": "Brent Moto <brent@moto>", "signatures": [{"packet": {"tag": 2, "data": "wsEUBBMBCgA+FiEEI85H/KX15TD6VPgghYWG1K56Pm8FAmQ7Ae4CGwMFCQlmAYAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQhYWG1K56Pm8XjQv/XTy1qocOmI7hKws4sTApnB7aUngC/wDNWVeZRHWSW7RELotnY0ARtX2jHanbvXgnmp47tZ3PivbnUOPIWZDmh1dPmj3tQ2yVBPp2q6skZDvt9wtkAO4fuXE5AP1gFZeCpR91rDBxCj+HsrQTYdNvBILVR21jlzgbeVi7PsmbhKpS8kjE8uXYweDzLXXULp4Vdp5NqzSkCLsAVA0nIi87+W3LuBPjuD3oNPQHMWU1GmjoNkDgJ9i2t1joybViQE93CUvIRSj8t4whBgNhwPoUogzht2EMjASZNK/k+ZhjlJBXBkARIjusg60hfAb6Dtt9C8v0/tjE1dFTUjd3IrhAUgBAO6/CsBB74NRMP03nQl6/ZvjyCHa+u/wa/TVwrKpwIeA9QhTYrPTPjrNHPQ92gC4LE0n8Mo3anyw0N4ms4+YHTsnStpHC/LSW/hKXUjj4VJJ7rcLAyw/0OjBgSspYYwfOGut7mAI0QbQ6mKwC7BwyUEQO9ql0/qQoEmPX0cFv", "parsed": true}, "sigType": 19, "creation": "2023-04-15T19:58:38Z", "expiration": "2028-04-13T19:58:38Z", "issuerKeyID": "858586d4ae7a3e6f"}]}], "creation": "2023-04-15T19:58:38Z", "algorithm": {"code": 1, "name": "rsa"}, "bitLength": 3072, "longKeyID": "858586d4ae7a3e6f", "shortKeyID": "ae7a3e6f", "fingerprint": "23ce47fca5f5e530fa54f820858586d4ae7a3e6f", "neverExpires": true}
limit 10

where rfingerprint like '%CE4%'
where rfingerprint ='23CE47FCA5F5E530FA54F820858586D4AE7A3E6F'
858586D4AE7A3E6F

select rfingerprint  
from subkeys
where rfingerprint like '%CE4%'