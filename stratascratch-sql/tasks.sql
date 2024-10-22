-- Find the last time each bike was in use. Output both the bike number and the date-timestamp of the bike's last use (i.e., the date-time the bike was returned). 
-- Order the results by bikes that were most recently used.

SELECT bike_number,
		 max(end_time) AS last_time
FROM dc_bikeshare_q1_2012
GROUP BY  bike_number
ORDER BY  last_time desc;

-- You have been asked to find the job titles of the highest-paid employees.
-- Your output should include the highest-paid title or multiple titles with the same salary.

SELECT worker_title
FROM worker w
LEFT JOIN title t
	ON w.worker_id=t.worker_ref_id
WHERE salary = 
	(SELECT max(salary)
	FROM worker);

-- Find the number of employees working in the Admin department that joined in April or later.

SELECT count(worker_id)
FROM worker
WHERE joining_date >= '2014-04-01'
GROUP BY  department
HAVING department='Admin';

-- Find the 3 most profitable companies in the entire world. Output the result along with the corresponding company name. Sort the result based on profits in descending order.

SELECT company,
		 profits
FROM forbes_global_2010_2014
ORDER BY  profits DESC limit 3;

-- Calculate each user's average session time. A session is defined as the time difference between a page_load and page_exit. 
-- For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, 
-- consider only the latest page_load and earliest page_exit, with an obvious restriction that load time event should happen before exit time event . 
-- Output the user_id and their average session time.

with t1 AS 
	(SELECT user_id,
		 min(timestamp) AS first_time,
		 timestamp::date AS d1
	FROM facebook_web_log
	WHERE action='page_exit'
	GROUP BY  user_id, d1), t2 AS 
	(SELECT user_id,
		 max(timestamp) AS last_time,
		 timestamp::date AS d2
	FROM facebook_web_log
	WHERE action='page_load'
	GROUP BY  user_id, d2)
SELECT t1.user_id,
		 avg(first_time-last_time)
FROM t1
JOIN t2
	ON t1.user_id=t2.user_id
		AND t1.d1=t2.d2
GROUP BY  t1.user_id;

-- Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on.
--  Output the user, total emails, and their activity rank. Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order.
-- In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails. For tie breaker use alphabetical order of the user usernames.

SELECT from_user,
		 count(*) AS total_emails,
		 row_number() over(order by count(*) desc,
		 from_user asc)
FROM google_gmail_emails
GROUP BY  from_user;

-- Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase within 7 days of any other of their purchases.
-- Output a list of user_ids of these returning active users.

SELECT DISTINCT user_id from
	(SELECT user_id,
		 lead(created_at) over(partition by user_id
	ORDER BY  created_at)-created_at AS days
	FROM amazon_transactions ) t1
WHERE days<=7; 

-- You are given a table of product launches by company by year. 
-- Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year.
-- Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

with t1 AS 
	(SELECT count(product_name) AS a_2019_count,
		 company_name
	FROM car_launches
	WHERE year='2019'
	GROUP BY  company_name
	ORDER BY  company_name), t2 AS 
	(SELECT count(product_name) AS a_2020_count,
		 company_name
	FROM car_launches
	WHERE year='2020'
	GROUP BY  company_name
	ORDER BY  company_name)
SELECT t1.company_name,
		 a_2020_count-a_2019_count AS net_products
FROM t1
JOIN t2
	ON t1.company_name=t2.company_name;

-- Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the absolute difference in salaries.

SELECT max(salary) filter(where d.department='marketing')-max(salary) filter(where d.department='engineering')
FROM db_employee e
JOIN db_dept d
	ON e.department_id=d.id; 

-- We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. 
-- Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, department ID, and current salary. 
-- Order your list by employee ID in ascending order.

SELECT id,
		 first_name,
		 last_name,
		 department_id,
		 max(salary) AS current_salary
FROM ms_employee_salary
GROUP BY  id, first_name, last_name, department_id
ORDER BY  id asc;

-- Find the number of rows for each review score earned by 'Hotel Arena'.
-- Output the hotel name (which should be 'Hotel Arena'), review score along with the corresponding number of rows with that score for the specified hotel.

SELECT hotel_name,
		 reviewer_score,
		 count(reviewer_score)
FROM hotel_reviews
WHERE hotel_name = 'Hotel Arena'
GROUP BY  hotel_name, reviewer_score;

-- Count the number of movies that Abigail Breslin was nominated for an oscar.

SELECT count(distinct movie)
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin';

-- Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

SELECT post_id,
		 poster,
		 post_text,
		 post_keywords,
		 post_date
FROM facebook_posts
WHERE post_id IN 
	(SELECT post_id
	FROM facebook_reactions
	WHERE reaction = 'heart');



