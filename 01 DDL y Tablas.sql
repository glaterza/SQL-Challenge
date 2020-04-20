/*
Test 3 – Consultas SQL
Table of transactions (Transaction_ID, Item_ID, quantity, purchase_date (MM/DD/YY))
Table of prices (Item_ID, price)
*/




--  DB schema
DROP DATABASE IF EXISTS LA_NACION;
CREATE DATABASE LA_NACION;
USE LA_NACION;





-- table schemas
CREATE TABLE prices (
	item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    price int
); -- prices

CREATE TABLE transactions (
	transaction_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    item_id_FK int,
    FOREIGN KEY (item_id_FK)
		REFERENCES prices(item_id)
        ON DELETE CASCADE,
    quantity int,
    purchase_date datetime
    ); -- transactions





-- variables for table population
SET @max_items 			= 25;
SET @max_price			= 500;
SET @min_price			= 20;  -- guaymallén triple en el chino, 18/04/2020
SET @max_transactions 	= 2000;
SET @max_qty			= 300;
SET @end_date 			= UNIX_TIMESTAMP('2017-01-31');
SET @start_date		 	= UNIX_TIMESTAMP('2017-01-01');



-- prices table populator
DELIMITER //
CREATE PROCEDURE LA_NACION.load_prices()
BEGIN

DECLARE startLoop int DEFAULT 1;
DECLARE endLoop INT;
SET endLoop = @max_items; 

WHILE startLoop <= endLoop DO
    INSERT INTO prices
		(price) VALUES 
			(FLOOR(RAND()*(@max_price-@min_price))+@min_price);
    SET startLoop = startLoop + 1;
END WHILE;
END //
DELIMITER ;
-- end proc load_prices


CALL LA_NACION.load_prices();
-- SELECT * FROM prices;




-- transactions table populator
DELIMITER //
CREATE PROCEDURE LA_NACION.load_transactions()
BEGIN

DECLARE startLoop int DEFAULT 1;
DECLARE endLoop INT;
SET endLoop = @max_transactions; 

WHILE startLoop <= endLoop DO
    INSERT INTO transactions
		(item_id_FK, quantity, purchase_date) VALUES 
			(
			(FLOOR(RAND()*@max_items+1)), (FLOOR(RAND()*(@max_qty))+1),(FROM_UNIXTIME(RAND() * (@end_date - @start_date) + @start_date)
			));
    SET startLoop = startLoop + 1;
END WHILE;
END //
DELIMITER ;
-- end proc load_transactions




CALL LA_NACION.load_transactions();
-- SELECT * FROM transactions;