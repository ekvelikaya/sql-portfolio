-- 1. 

SELECT *
FROM checks
ORDER BY  Rub DESC limit 10;

-- 2. 

SELECT Rub AS Revenue,
		 BuyDate,
		 UserID
FROM checks
ORDER BY  UserID limit 15;

-- 3. 

SELECT min(BuyDate) AS MinDate,
		 max(BuyDate) AS MaxDate
FROM checks;

-- 4. 

SELECT DISTINCT UserID
FROM checks
ORDER BY  UserID ASC limit 10;

-- 5. 

SELECT Rub,
		 BuyDate,
		 UserID
FROM checks
WHERE BuyDate = '2019-03-08'
ORDER BY  Rub DESC limit 10;

-- 6. 

SELECT DISTINCT UserID
FROM checks
WHERE BuyDate = '2019-09-01'
		AND Rub > 2000
ORDER BY  UserID DESC;

-- 7. 

SELECT UserID,
		 count(Rub) AS NumChecks
FROM checks
GROUP BY  UserID
ORDER BY  NumChecks DESC limit 10;

-- 8.

SELECT UserID,
		 count(Rub) AS NumChecks,
		 sum(Rub) AS Revenue
FROM checks
GROUP BY  UserID
ORDER BY  Revenue DESC limit 10;

-- 9. 

SELECT BuyDate,
		 min(Rub) AS MinCheck,
		 max(Rub) AS MaxCheck,
		 avg(Rub) AS AvgCheck
FROM checks
GROUP BY  BuyDate
ORDER BY  BuyDate DESC limit 10;

-- 10.

SELECT UserID ,
		 sum( Rub ) AS Revenue
FROM checks
GROUP BY  UserID
HAVING sum(Rub) > 10000
ORDER BY  UserID DESC limit 10;

-- 11.

SELECT Country ,
		 sum( Quantity * UnitPrice) AS Revenue
FROM retail
GROUP BY  Country
ORDER BY  Revenue desc;

-- 12.

SELECT Country,
		 AVG(Quantity) AS AvgQuantity,
		 AVG(UnitPrice) AS AvgPrice
FROM retail
WHERE Description != 'Manual'
GROUP BY  Country
ORDER BY  AvgPrice DESC;

-- 13.

SELECT toStartOfMonth(InvoiceDate) AS month,
		 SUM(UnitPrice * Quantity) AS Revenue
FROM retail
WHERE Description != 'Manual'
GROUP BY  toStartOfMonth( InvoiceDate)
ORDER BY  Revenue DESC;

-- 14.

SELECT CustomerID ,
		 avg(UnitPrice) AS average_price
FROM retail
WHERE Description != 'Manual'
		AND InvoiceDate
	BETWEEN '2011-03-01'
		AND '2011-03-31'
GROUP BY  CustomerID
ORDER BY  average_price DESC;

-- 15.

SELECT 
    toStartOfMonth(InvoiceDate) as month,
    AVG(Quantity) as avg_q,
    MIN(Quantity) as min_q,
    MAX(Quantity) as max_q
FROM retail
WHERE Description!='Manual' and Country = 'United Kingdom' and Quantity>0
GROUP BY toStartOfMonth(InvoiceDate)
ORDER BY avg_q DESC
LIMIT 1;

