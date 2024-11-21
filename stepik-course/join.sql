-- 1.
SELECT b.title,
		 g.name_genre,
		 b.price
FROM book b
JOIN author a
	ON b.author_id=a.author_id
JOIN genre g
	ON b.genre_id=g.genre_id
WHERE amount>8
ORDER BY  price desc;

-- 2. 
SELECT name_genre
FROM 
	(SELECT name_genre,
		 book_id
	FROM genre
	LEFT JOIN book using(genre_id)
	WHERE book_id is null) t1;

-- 3.
SELECT name_city,
		 name_author,
		 date_add('2020-01-01', interval FLOOR(RAND()*365) day) AS Дата
FROM author
CROSS JOIN city
ORDER BY  1, 3 desc;

-- 4.
SELECT name_genre,
		 title,
		 name_author
FROM book
INNER JOIN author
	ON book.author_id=author.author_id
INNER JOIN genre
	ON book.genre_id=genre.genre_id
WHERE name_genre='Роман'
ORDER BY  title;

-- 5.
SELECT name_author,
		 sum(amount) AS Количество
FROM author
LEFT JOIN book
	ON author.author_id=book.author_id
GROUP BY  name_author
HAVING sum(amount) < 10
		OR Количество is null
ORDER BY  Количество;

-- 6.
SELECT name_author
FROM book
LEFT JOIN genre
USING (genre_id)
LEFT JOIN author
USING (author_id)
GROUP BY  name_author
HAVING count(distinct name_genre)=1
ORDER BY  name_author;

-- 7. 
SELECT book.title AS Название,
		 author AS Автор,
		 book.amount + supply.amount AS Количество
FROM book
JOIN supply
	ON supply.title = book.title
		AND supply.price = book.price;

-- 8.

SELECT buy.buy_id,
		 book.title,
		 book.price,
		 buy_book.amount
FROM client
INNER JOIN buy
	ON client.client_id=buy.client_id
INNER JOIN buy_book
	ON buy.buy_id=buy_book.buy_id
INNER JOIN book
	ON book.book_id=buy_book.book_id
WHERE client.client_id=1
ORDER BY  buy_id, title;

-- 9.

SELECT name_author,
		 title,
		 count(buy_book.book_id) AS Количество
FROM author
LEFT JOIN book
	ON book.author_id=author.author_id
LEFT JOIN buy_book
	ON buy_book.book_id=book.book_id
WHERE title is not null
GROUP BY  name_author, title
ORDER BY  name_author, title;

-- 10.

SELECT name_city,
		 count(*) AS Количество
FROM buy
INNER JOIN client
	ON client.client_id=buy.client_id
INNER JOIN city
	ON city.city_id=client.city_id
GROUP BY  name_city;

-- 11.

SELECT buy_id,
		 date_step_end
FROM buy_step
WHERE step_id=1
		AND date_step_end is not null;

-- 12.

SELECT buy.buy_id,
		 name_client,
		 sum(buy_book.amount*book.price) AS Стоимость
FROM buy
JOIN client
	ON buy.client_id=client.client_id
JOIN buy_book
	ON buy_book.buy_id=buy.buy_id
JOIN book
	ON book.book_id=buy_book.book_id
GROUP BY  buy.buy_id
ORDER BY  buy.buy_id;

-- 13.

WITH genre_totals AS 
		(SELECT genre_id, SUM(amount) AS total_amount
		FROM book
		GROUP BY  genre_id ), 
	most_popular_genre AS 
		(SELECT genre_id
		FROM genre_totals
		WHERE total_amount = (SELECT MAX(total_amount) FROM genre_totals))

SELECT b.title,
		 a.name_author,
		 g.name_genre,
		 b.price,
		 b.amount
FROM book b
INNER JOIN author a
	ON a.author_id = b.author_id
INNER JOIN genre g
	ON b.genre_id = g.genre_id
WHERE b.genre_id IN (SELECT genre_id FROM most_popular_genre)
ORDER BY  b.title; 

-- 14.

SELECT buy.buy_id,
		 name_client,
		 sum(buy_book.amount*book.price) AS Стоимость
FROM buy
JOIN client
	ON buy.client_id=client.client_id
JOIN buy_book
	ON buy_book.buy_id=buy.buy_id
JOIN book
	ON book.book_id=buy_book.book_id
GROUP BY  buy.buy_id
ORDER BY  buy.buy_id;

-- 15.

SELECT buy.buy_id,
		 step.name_step
FROM buy
JOIN buy_step
	ON buy_step.buy_id=buy.buy_id
JOIN step
	ON step.step_id=buy_step.step_id
WHERE date_step_beg is NOT null
		AND date_step_end is NULL;


