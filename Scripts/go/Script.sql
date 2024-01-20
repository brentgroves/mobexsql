-- create schema tutors;
-- DROP TABLE IF EXISTS tutors.album;
CREATE TABLE tutors.album (
  id         INT AUTO_INCREMENT NOT NULL,
  title      VARCHAR(128) NOT NULL,
  artist     VARCHAR(255) NOT NULL,
  price      DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`id`)
);

select * from tutors.album
stmtIns, err := db.Prepare("INSERT INTO tutors.album VALUES( ?, ?, ? )") // ? = placeholder

-- INSERT INTO tutors.album
  (title, artist, price)
VALUES
  ('Blue Train', 'John Coltrane', 56.99),
  ('Giant Steps', 'John Coltrane', 63.99),
  ('Jeru', 'Gerry Mulligan', 17.99),
  ('Sarah Vaughan', 'Sarah Vaughan', 34.98);
  
 select * from tutors.album
