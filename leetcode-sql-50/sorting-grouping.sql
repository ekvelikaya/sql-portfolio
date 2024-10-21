
-- Write a solution to calculate the number of unique subjects each teacher teaches in the university.

SELECT teacher_id,
		 count(distinct subject_id) AS cnt
FROM teacher
GROUP BY  teacher_id;

-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date <= DATE '2019-07-27' AND activity_date > DATE '2019-07-27' - INTERVAL '30 days'
GROUP BY activity_date;

-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold.

SELECT product_id,
		 year AS first_year,
		 quantity,
		 price
FROM sales
LEFT JOIN Product using(product_id)
WHERE (product_id, year) IN (SELECT product_id,
		                    min(year)
	                        FROM Sales
	                        GROUP BY  product_id);

-- Write a solution to find all the classes that have at least five students.

SELECT class
FROM Courses
GROUP BY  class
HAVING count(student) >=5;

-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.

SELECT user_id,
		 count(follower_id) AS followers_count
FROM Followers
GROUP BY  user_id
ORDER BY  user_id asc;

-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.

SELECT max(num) AS num
FROM 
	(SELECT num
	FROM MyNumbers
	GROUP BY  num
	HAVING count(num) = 1);

-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

SELECT
    customer_id
FROM
    customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(DISTINCT product_key) FROM product)
