

SELECT bike_number,
		 max(end_time) AS last_time
FROM dc_bikeshare_q1_2012
GROUP BY  bike_number
ORDER BY  last_time desc;



SELECT worker_title
FROM worker w
LEFT JOIN title t
	ON w.worker_id=t.worker_ref_id
WHERE salary = 
	(SELECT max(salary)
	FROM worker);



SELECT count(worker_id)
FROM worker
WHERE joining_date >= '2014-04-01'
GROUP BY  department
HAVING department='Admin';



SELECT company,
		 profits
FROM forbes_global_2010_2014
ORDER BY  profits DESC limit 3;



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


SELECT from_user,
		 count(*) AS total_emails,
		 row_number() over(order by count(*) desc,
		 from_user asc)
FROM google_gmail_emails
GROUP BY  from_user;




SELECT DISTINCT user_id from
	(SELECT user_id,
		 lead(created_at) over(partition by user_id
	ORDER BY  created_at)-created_at AS days
	FROM amazon_transactions ) t1
WHERE days<=7; 




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




SELECT max(salary) filter(where d.department='marketing')-max(salary) filter(where d.department='engineering')
FROM db_employee e
JOIN db_dept d
	ON e.department_id=d.id; 




SELECT id,
		 first_name,
		 last_name,
		 department_id,
		 max(salary) AS current_salary
FROM ms_employee_salary
GROUP BY  id, first_name, last_name, department_id
ORDER BY  id asc;




SELECT hotel_name,
		 reviewer_score,
		 count(reviewer_score)
FROM hotel_reviews
WHERE hotel_name = 'Hotel Arena'
GROUP BY  hotel_name, reviewer_score;




SELECT count(distinct movie)
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin';




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