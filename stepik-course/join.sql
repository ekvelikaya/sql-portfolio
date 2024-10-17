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

