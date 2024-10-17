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
	HAVING sum(amount)>10)

-- 14. 
CREATE TABLE ordering 
SELECT author,
	 title,
	 (SELECT avg(amount) FROM book) AS amount
FROM book
WHERE amount < (SELECT avg(amount) FROM book)


