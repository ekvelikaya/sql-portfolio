-- 1.
create table author (author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50));

-- 2.
insert into author(author_id, name_author) 
values (1, 'Булгаков М.А.'), (2, 'Достоевский Ф.М.'), (3, 'Есенин С.А.'), (4, 'Пастернак Б.Л.');

-- 3. 
create table book (
      book_id INT PRIMARY KEY AUTO_INCREMENT, 
      title VARCHAR(50), 
      author_id INT NOT NULL, 
      genre_id INT,
      price DECIMAL(8,2), 
      amount INT, 
      FOREIGN KEY (author_id)  REFERENCES author (author_id),
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
);

-- 4. 
create table book (
      book_id INT PRIMARY KEY AUTO_INCREMENT, 
      title VARCHAR(50), 
      author_id INT, 
      genre_id INT,
      price DECIMAL(8,2), 
      amount INT, 
      FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE set null
);

-- 5. 
insert into book (book_id, title, author_id, genre_id, price, amount)
values 
    (6, "Стихотворения и поэмы", 3, 2, 650.00, 15),
    (7, "Черный человек", 3, 2, 570.20, 6),
    (8, "Лирика", 4, 2, 518.99, 2);

-- 6.
CREATE TABLE supply (
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT);

-- 7. 
INSERT INTO supply (supply_id, title, author, price, amount)
VALUES
    (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2),
    (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
    (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7),
    (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);

-- 8. 
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author not in ("Булгаков М.А.", "Достоевский Ф.М.");

-- 9. 
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author NOT IN (
        SELECT author
        FROM book
      );

SELECT * FROM book;

-- 10. 
UPDATE book
SET price = 0.9 * price
WHERE amount between 5 and 10;

-- 11. 
UPDATE book
SET   buy = IF(buy>amount, amount, buy),
      price = IF(buy=0, price*0.9, price);

-- 12.
UPDATE book, supply
SET book.amount = supply.amount+book.amount,
    book.price = (book.price+supply.price)/2
WHERE book.title=supply.title;
SELECT * FROM book;

-- 13. 
DELETE
FROM supply
WHERE author IN 
	(SELECT author
	FROM book
	GROUP BY  author
	HAVING sum(amount)>10);

-- 14. 
CREATE TABLE ordering 
SELECT author,
	 title,
	 (SELECT avg(amount) FROM book) AS amount
FROM book
WHERE amount < (SELECT avg(amount) FROM book);

-- 15.

UPDATE book
INNER JOIN author
	ON book.author_id=author.author_id
INNER JOIN supply
	ON book.title=supply.title
	    AND supply.author = author.name_author SET book.price=if(book.price <> supply.price,
		 (book.price * book.amount + supply.price * supply.amount)/(book.amount+supply.amount),
		 book.price),
		 book.amount=book.amount+supply.amount,
		 supply.amount=0
WHERE book.price <> supply.price;

-- 16.

INSERT INTO author(author_id, name_author)
SELECT supply_id AS author_id,
	    author
FROM supply
LEFT JOIN author
	ON supply.author=author.name_author
WHERE author_id is null;

-- 17.

INSERT INTO book(title, author_id, price, amount)
SELECT title,
		 author_id,
		 price,
		 amount
FROM author
INNER JOIN supply
	ON author.name_author = supply.author
WHERE amount <> 0;

-- 18.

UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Поэзия')
WHERE genre_id is null and book_id=10;

UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Приключения')
WHERE genre_id is null and book_id=11;

-- 19.

DELETE
FROM author
WHERE author_id IN 
	(SELECT author_id
	FROM book
	GROUP BY  author_id
	HAVING sum(amount) < 20);

-- 20. 

DELETE
FROM genre
WHERE genre_id IN 
	(SELECT genre_id
	FROM book
	GROUP BY  genre_id
	HAVING count(genre_id)<3);

-- 21.

insert into client(client_id, name_client, city_id, email)
values (5, 'Попов Илья', 1, 'popov@test');

-- 22.

INSERT INTO buy (buy_id, buy_description, client_id)
SELECT 
    (SELECT COALESCE(MAX(buy_id), 0) + 1 FROM buy) AS new_buy_id, 
    'Связаться со мной по вопросу доставки' AS buy_description,  
    client_id                                                  
FROM 
    client
WHERE 
    name_client = 'Попов Илья';

-- 23.

insert into buy_book(buy_id, book_id, amount)
values (5, 8, 2);
insert into buy_book(buy_id, book_id, amount)
values (5, 2, 1);

-- 24.

UPDATE book 
     INNER JOIN buy_book
     on book.book_id = buy_book.book_id
           SET book.amount = book.amount-buy_book.amount   
WHERE buy_book.buy_id = 5 ;

-- 25.

CREATE TABLE buy_pay(title varchar(50), name_author varchar(30), price decimal(8,2), amount int, Стоимость decimal(8,2));
INSERT INTO buy_pay (title, name_author, price, amount, Стоимость)
SELECT book.title,
		 author.name_author,
		 book.price,
		 buy_book.amount,
		 book.price*buy_book.amount
FROM author
INNER JOIN book
	ON author.author_id = book.author_id
INNER JOIN buy_book
	ON book.book_id = buy_book.book_id
WHERE buy_book.buy_id = 5
ORDER BY  title;SELECT title,
		 name_author,
		 price,
		 amount,
		 Стоимость
FROM buy_pay;

-- 26.

CREATE TABLE buy_pay
SELECT buy_id,
		 sum(buy_book.amount) AS Количество,
		 sum(price*buy_book.amount) AS Итого
FROM buy_book
INNER JOIN book
	ON book.book_id=buy_book.book_id
WHERE buy_id=5
GROUP BY  buy_id;

-- 27.

INSERT INTO buy_step(buy_id, step_id)
SELECT buy_id,
		 step_id
FROM buy
CROSS JOIN step
WHERE buy_id=5;

-- 28.

update buy_step
set date_step_beg='2020-04-12'
where buy_id=5 and step_id=1;

-- 29.

update buy_step
set date_step_end='2020-04-13'
where buy_id=5 and step_id=1;

update buy_step
set date_step_beg='2020-04-13'
where buy_id=5 and step_id=2;

-- 30.

CREATE TABLE applicant
SELECT program_id, enrollee.enrollee_id, SUM(result) AS itog
FROM enrollee
JOIN program_enrollee USING(enrollee_id)
JOIN program USING(program_id)
JOIN program_subject USING(program_id)
JOIN subject USING(subject_id)
JOIN enrollee_subject USING(subject_id)
WHERE enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY program_id, enrollee_id
ORDER BY program_id, itog DESC;

-- 31.

DELETE FROM applicant
USING
  applicant
  JOIN (
    SELECT program_enrollee.program_id, program_enrollee.enrollee_id 
    FROM program
    JOIN program_subject  USING(program_id)
    JOIN program_enrollee USING(program_id)
    JOIN enrollee_subject ON 
    enrollee_subject.enrollee_id = program_enrollee.enrollee_id AND
    enrollee_subject.subject_id = program_subject.subject_id
    WHERE result < min_result
 ) AS t1
 ON applicant.program_id = t1.program_id AND
    applicant.enrollee_id = t1.enrollee_id;

-- 32.

UPDATE applicant JOIN (
    SELECT enrollee_id, IFNULL(SUM(bonus), 0) AS Бонус FROM enrollee_achievement
    LEFT JOIN achievement USING(achievement_id)
    GROUP BY enrollee_id 
    ) AS t USING(enrollee_id)
SET itog = itog + Бонус;

-- 33.

CREATE TABLE applicant_order
SELECT * FROM applicant
ORDER BY 1, 3 DESC;
DROP TABLE applicant;

-- 34.

ALTER TABLE applicant_order ADD
str_id int FIRST;

-- 35.

SET @row_num := 1;
SET @num_pr := 0;
UPDATE applicant_order
    SET str_id = IF(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 AND @num_pr := @num_pr + 1);

-- 36.

CREATE TABLE student
SELECT name_program, name_enrollee, itog FROM enrollee
	JOIN applicant_order USING (enrollee_id)
	JOIN program USING (program_id)
WHERE str_id<=plan
ORDER BY name_program, itog DESC;

-- 37.

INSERT INTO step_keyword
SELECT step.step_id, keyword.keyword_id 
FROM 
    keyword
    CROSS JOIN step
WHERE step.step_name REGEXP CONCAT(' ', CONCAT(keyword.keyword_name, '\\b'))
GROUP BY step.step_id, keyword.keyword_id
ORDER BY keyword.keyword_id;




