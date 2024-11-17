-- Введение и операторы

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

-- Группировка и агрегатные функции

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

-- Объединение таблиц - JOIN

-- 16.

SELECT e.DeviceID,
		 d.UserID,
		 e.events
FROM events e
LEFT JOIN devices d
	ON e.DeviceID = d.DeviceID
ORDER BY  DeviceID DESC;

-- 17.

SELECT Source,
		 count(UserID) AS users_count
FROM installs i
LEFT JOIN devices d
	ON i.DeviceID = d.DeviceID
GROUP BY  Source
ORDER BY  users_count DESC;

-- 18. 

SELECT 
    COUNT(DISTINCT c.UserID) as Uniq_users_count,
    i.Source as Source
FROM 
    checks as c
JOIN devices as d
    ON c.UserID = d.UserID
JOIN installs as i
    ON d.DeviceID = i.DeviceID
WHERE i.Source = 'Source_7'
GROUP BY 
    i.Source;

-- 19.

SELECT i.Source,
		 SUM(Rub) AS Revenue,
		 MIN(Rub) AS MinRub,
		 MAX(Rub) AS MaxRub,
		 AVG(Rub) AS AvgRub
FROM default.checks AS c
JOIN default.devices AS d
	ON c.UserID = d.UserID
JOIN installs AS i
	ON d.DeviceID = i.DeviceID
GROUP BY  i.Source;

-- 20.

SELECT c.UserID,
		 d.DeviceID
FROM default.checks c
LEFT JOIN default.devices d
	ON c.UserID = d.UserID
WHERE toMonth(BuyDate::date) = 10
		AND toYear(BuyDate::date) = 2019
ORDER BY  d.DeviceID ASC limit 10;

-- 21.

SELECT avg(e.events) AS avg_events,
		 i.Source,
		 e.AppPlatform
FROM default.events e
JOIN default.installs i
	ON e.DeviceID = i.DeviceID
GROUP BY  e.AppPlatform, i.Source
ORDER BY  avg_events desc;

-- 22.

SELECT count(distinct i.DeviceID),
		 Platform
FROM default.installs i
JOIN default.events e
	ON i.DeviceID = e.DeviceID
GROUP BY  Platform;

-- 23.

SELECT count(distinct i.DeviceID) as i_devices,
		 count(distinct e.DeviceID) as e_devices,
		 count(distinct e.DeviceID)/count(distinct i.DeviceID) as conversion,
		 Platform
FROM default.installs i
LEFT JOIN default.events e
	ON i.DeviceID = e.DeviceID
GROUP BY  Platform;

-- 24.

SELECT DISTINCT e.DeviceID
FROM default.events e
LEFT JOIN default.installs i
	ON e.DeviceID = i.DeviceID
WHERE i.DeviceID = 0
ORDER BY  DeviceID DESC limit 10;

-- Типы данных и их преобразование

-- 25.

SELECT toStartOfMonth(toDateOrNull(host_since)) AS StartMonth,
		 COUNT(DISTINCT host_id) AS NumHosts
FROM listings
GROUP BY  StartMonth
ORDER BY  NumHosts DESC 
LIMIT 10;

-- 26.

SELECT host_is_superhost,
    	AVG(toInt32OrNull(replaceAll(host_response_rate, '%', ''))) as AvgResp,
		MIN(toInt32OrNull(replaceAll(host_response_rate, '%', ''))) as MinResp,
    	MAX(toInt32OrNull(replaceAll(host_response_rate, '%', ''))) as MaxResp
FROM
    (SELECT 
        DISTINCT host_id,
            	host_response_rate,
            	host_is_superhost
    FROM listings) as sub
WHERE 
    host_is_superhost != ''
GROUP BY
    host_is_superhost
LIMIT 10;

-- 27.

SELECT host_id,
    	groupArray(id) as host_listings,
    	groupArray(price) as prices,
    	AVG(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as AvgPricePerHost
FROM
    listings
GROUP BY
    host_id
ORDER BY
    AvgPricePerHost DESC
LIMIT 10;

-- 28.

SELECT host_id,
    	groupArray(id) as host_listings,
    	MIN(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as MinPricePerHost,
    	MAX(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as MaxPricePerHost,
    	MaxPricePerHost - MinPricePerHost AS price_diff
FROM
    listings
GROUP BY
    host_id
ORDER BY
    price_diff DESC
LIMIT 10;

-- 29.

SELECT room_type,
		AVG(toFloat32OrNull(replaceRegexpAll(price, '[$,]', ''))) as AvgPrice,
		AVG(toFloat32OrNull(replaceRegexpAll(security_deposit, '[$,]', ''))) as AvgSecurityDeposit,
		AVG(toFloat32OrNull(replaceRegexpAll(cleaning_fee, '[$,]', ''))) as AvgClean
FROM
    listings
GROUP BY
    room_type
ORDER BY
    AvgSecurityDeposit DESC;

-- 30.

SELECT neighbourhood_cleansed,
		AVG(toFloat32OrNull(replaceRegexpAll(price, '[$,]', ''))) as AvgPrice,
		MAX(toFloat32OrNull(replaceRegexpAll(price, '[$,]', ''))) as MaxPrice,
		MIN(toFloat32OrNull(replaceRegexpAll(price, '[$,]', ''))) as MinPrice
FROM
    listings
GROUP BY
    neighbourhood_cleansed 
ORDER BY
    AvgPrice
LIMIT 10;

-- 31.

SELECT neighbourhood_cleansed,
    	AVG(toFloat32OrNull(square_feet)) as AvgSquare
FROM
    listings
WHERE
    room_type = 'Entire home/apt'
GROUP BY
    neighbourhood_cleansed 
ORDER BY
    AvgSquare DESC
LIMIT 10;

-- 32.

SELECT id,
		host_id,
		toFloat64OrNull(latitude) as latitude,
		toFloat64OrNull(longitude) as longitude,
		geoDistance(13.4050, 52.5200, longitude, latitude) as dist
FROM
    listings
WHERE 
    room_type = 'Private room'
ORDER BY
    dist 
LIMIT 1;

