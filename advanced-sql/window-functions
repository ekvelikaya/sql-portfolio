
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
