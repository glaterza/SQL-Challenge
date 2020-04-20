-- 1. Total number, average and standard deviation of purchase quantities per weekday (Monday­Friday) ordered by descending number of purchases.
SELECT
	DATE(purchase_date)		AS weekday,
--  DAYNAME(purchase_date)	AS dayname,
    SUM(quantity)			AS total_qty,
    AVG(quantity)			AS avg_qty,
    STD(quantity)			AS stdev_qty
FROM transactions
WHERE WEEKDAY(DATE(purchase_date)) < 5
GROUP BY DATE(purchase_date)
-- , DAYNAME(purchase_date)
ORDER BY SUM(quantity) DESC;
    





-- 2. Total revenue of items that are sold more than 20 times in 2017.

SELECT * FROM transactions LIMIT 10;

WITH sold as (
	SELECT
		item_id_FK			AS item,
		SUM(quantity)		AS sold
	FROM transactions
	GROUP BY item_id_FK
 	HAVING sold >= 12000       -- NOTA: en lugar de 20, voy a tomar 12.000 para usar mejor los datos sintéticos
	ORDER BY SUM(quantity) DESC
    ) -- sold
SELECT 
	item,
    sold,
    price,
    price * sold  AS revenue
FROM SOLD
LEFT JOIN prices ON sold.item = prices.item_id
ORDER BY revenue DESC
;






-- 3. Date with the highest and lowest total purchase quantity.
WITH max AS (
	SELECT 
		DATE(purchase_date) 		AS date_max,
		SUM(quantity)				AS qty_max
	FROM transactions
	GROUP BY DATE(purchase_date)
	ORDER BY SUM(quantity) DESC
	LIMIT 1
	), -- max
    min AS (
    SELECT 
		DATE(purchase_date) 		AS date_min,
		SUM(quantity)				AS qty_min
	FROM transactions
	GROUP BY DATE(purchase_date)
	ORDER BY SUM(quantity) ASC
	LIMIT 1
    ) -- min
SELECT -- tabla con la solución
	max.date_max,
    max.qty_max,
    min.date_min,
    min.qty_min
FROM min
JOIN max;





-- 4. For each item get the transaction_ID with the highest quantity.

WITH trans AS(
		SELECT
			item_id_FK,
            transaction_id,
            SUM(quantity)   	AS qty
		FROM transactions
        GROUP BY item_id_FK, transaction_id
			),-- end trans
	max_qty AS(
		SELECT
			item_id_FK,
            MAX(quantity)		AS highest_qty
		FROM transactions
        GROUP BY item_id_FK
        ) -- end max_qty
SELECT 
	max_qty.item_id_FK,
    trans.transaction_id,
    max_qty.highest_qty
FROM max_qty
LEFT JOIN trans ON max_qty.item_id_FK 	= trans.item_id_FK AND
				   max_qty.highest_qty  = trans.qty
GROUP BY max_qty.item_id_FK, trans.transaction_id
ORDER BY max_qty.item_id_FK;