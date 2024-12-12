
--
SELECT  month,
		 year,
		 SUM(revenue) OVER () AS total_revenue
FROM revenues
ORDER BY  year, month;

--
SELECT month,
		 year,
		 SUM(revenue) OVER(PARTITION BY year) AS year_revenue
FROM revenues
ORDER BY  year, month;

--
SELECT *,
        row_number() over(order by points desc, time asc) as place
FROM results
ORDER BY place asc;

--
SELECT month,
		 year,
		 round(100*revenue/sum(revenue) over(partition by year),1) AS month_percent
FROM revenues
ORDER BY  year, month;

--
SELECT row_number() over() AS line_num,
		 order_id,
		 product_id
FROM orders_products
ORDER BY  order_id, product_id;

--
SELECT *,
	sum(population) over(partition by country) AS country_population
FROM cities
ORDER BY  country_population, population;

-- 
SELECT *, 
    sum(price*count) over() as total
FROM products;

--
SELECT ROW_NUMBER() OVER(ORDER BY price asc) AS num,
		 name,
		 count,
		 price
FROM products limit 5 offset 10;

-- 
SELECT *,
		 round(100*(price*count)/sum(price*count) over(),1) AS percent
FROM products
ORDER BY  percent desc, id;

--
SELECT name,
		 rating,
		 genre
FROM 
	(SELECT name,
		 rating,
		 genre,
		 row_number() over(partition by genre ORDER BY  rating desc) AS rn
	FROM films) t1
WHERE rn<=2
ORDER BY  rating desc;

--
SELECT genre,
		 row_number() over(partition by genre ORDER BY  rating desc) AS genre_place, 
         rating, 
         name
FROM films
ORDER BY  genre, genre_place;

--
SELECT *,
		 sum(population) over(partition by country) AS country_population,
		 round((100*population/sum(population) over(partition by country)),2) AS percent
FROM cities
ORDER BY  country_population, percent;

--
SELECT *,
        ROUND((100*population/sum(population) over()),2) as  world_percent
FROM cities
ORDER BY world_percent desc, id;

-- 
SELECT  row_number() over(order by rating desc) as place,
        name, 
        rating
FROM films;

--
SELECT *,
        row_number() over(order by points desc) as place
FROM results
ORDER BY id;

--
SELECT FLOOR(year / 10) * 10 AS decade,
		 row_number() over(partition by FLOOR(year / 10) * 10 ORDER BY  FLOOR(year / 10) * 10, rating desc) AS place,
         name
FROM films
ORDER BY  FLOOR(year / 10) * 10, place;

--
SELECT street,
		house,
		price,
		rooms
FROM (SELECT street, house, price, rooms, RANK() OVER(ORDER BY price) as rank_num
        FROM flats
        WHERE rooms > 1) as place
WHERE place.rank_num < 4
ORDER BY rooms desc, price;

--
SELECT rooms, 
		street, 
		house,
		price
FROM (SELECT street, house, price, rooms, RANK() OVER(PARTITION BY rooms ORDER BY price) as rank_num
        FROM flats
        WHERE rooms > 1) as place
WHERE place.rank_num < 4
ORDER BY rooms, price;

--
SELECT street, 
		house, 
		price, 
		rooms
FROM (SELECT street, house, price, rooms, DENSE_RANK() OVER(ORDER BY price) as rank_num
        FROM flats
        WHERE rooms > 1) as place
WHERE place.rank_num < 4
ORDER BY price, rooms desc;

--
SELECT DENSE_RANK() OVER(ORDER BY sum(cyber_results.kills-cyber_results.deaths*3) desc) as place, 
		cyber_teams.team as team,
		sum(cyber_results.kills-cyber_results.deaths*3) as points
FROM cyber_results
LEFT JOIN cyber_teams on cyber_results.team_id=cyber_teams.id
GROUP BY cyber_teams.team
ORDER BY place, team;

--
SELECT NTILE(3) OVER(ORDER BY id) as mail_variant, 
		id,
		email,
		first_name
FROM users 
ORDER BY id;

--
SELECT NTILE(4) OVER(ORDER BY MD5(email)) as mail_variant, 
		id,
		email,
		first_name
FROM users 
ORDER BY id;

--
SELECT name, 
		first_name, 
		last_name,
		sum(amount) as amount,
		NTILE(4) OVER(PARTITION BY name ORDER BY sum(amount) desc) as c_level
FROM orders
LEFT JOIN users on orders.user_id = users.id
LEFT JOIN shops on orders.shop_id = shops.id
WHERE status="success"
GROUP BY name, first_name, last_name
ORDER BY name, c_level;

-- 
SELECT month, 
		first_name, 
		last_name, 
		amount
FROM (
    SELECT 
        MONTH(date) AS month, 
        users.first_name, 
        users.last_name, 
        SUM(orders.amount) AS amount, 
        NTILE(4) OVER (PARTITION BY MONTH(date) ORDER BY SUM(orders.amount) DESC) AS level
    FROM orders
    JOIN users ON orders.user_id = users.id
    WHERE orders.status = 'success'
    GROUP BY MONTH(date), users.first_name, users.last_name
	) AS t1
WHERE level = 1
ORDER BY month, amount ASC;

--
SELECT month, 
		SUM(CASE WHEN year = 2020 THEN income ELSE 0 END) AS in2020, 
		SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) AS in2021,
		SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) - 
		SUM(CASE WHEN year = 2020 THEN income ELSE 0 END) AS diff
FROM revenues
GROUP BY month;

--
SELECT CEIL(month / 3) AS quarter, 
		SUM(CASE WHEN year = 2020 THEN income ELSE 0 END) AS in2020, 
		SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) AS in2021,
		SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) - 
		SUM(CASE WHEN year = 2020 THEN income ELSE 0 END) AS diff
FROM revenues
GROUP BY quarter
ORDER BY quarter;

--
SELECT month,
    ROUND(
        SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) *
        (SUM(CASE WHEN year = 2021 THEN income ELSE 0 END) / 
         SUM(CASE WHEN year = 2020 THEN income ELSE NULL END))
    ) AS plan
FROM revenues
WHERE year IN (2020, 2021)
GROUP BY month
ORDER BY month;

--
SELECT
    RANK() OVER (ORDER BY SUBTIME(end_time, start_time)) as place,
    last_name, 
	first_name,
    TIME_FORMAT(SUBTIME(end_time, start_time), '%T') as time,
    TIME_FORMAT(SUBTIME(SUBTIME(end_time, start_time), 
    FIRST_VALUE(SUBTIME(end_time, start_time)) OVER (ORDER BY SUBTIME(end_time, start_time))), '%T') as chempion_lag
FROM runners
ORDER BY SUBTIME(end_time, start_time);





