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