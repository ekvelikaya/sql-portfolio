-- Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

SELECT to_char(trans_date, 'yyyy-mm') AS month, 
        country, 
        COUNT(amount) AS trans_count,
        COUNT(CASE WHEN state = 'approved' THEN id ELSE NULL end) AS approved_count,
        SUM(amount) AS trans_total_amount, 
        SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 end) AS approved_total_amount
FROM Transactions
GROUP BY  month, country;

-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring". 
-- Return the result table ordered by rating in descending order.

SELECT *
FROM cinema
WHERE id%2!=0
    AND description!= 'boring'
ORDER BY  rating desc;

-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. 
-- If a product does not have any sold units, its average selling price is assumed to be 0.

SELECT p.product_id,
         COALESCE(ROUND(SUM(p.price * u.units)::DECIMAL / SUM(u.units),2), 0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
        AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY  p.product_id;

-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

SELECT project_id,
         round(avg(experience_years), 2) AS average_years
FROM Project p
LEFT JOIN Employee e
    ON p.employee_id=e.employee_id
GROUP BY  project;

-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

SELECT contest_id,
         round(count(distinct user_id)*100::decimal/(SELECT count(*) FROM users), 2) AS percentage
FROM Register
GROUP BY  contest_id
ORDER BY  percentage desc, contest_id asc;

-- We define query quality as: The average of the ratio between query rating and its position.
-- We also define poor query percentage as: The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.

SELECT query_name,
		 ROUND(SUM(rating::numeric / position) / COUNT(result), 2) quality,
		 ROUND(100. * COUNT(rating) FILTER (WHERE rating < 3 ) / COUNT(rating), 2) as poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY  query_name;

-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
-- The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

SELECT ROUND(COUNT(distinct customer_id) FILTER(WHERE min_time=customer_pref_delivery_date) *100 
        / CAST(COUNT(distinct customer_id) AS DECIMAL),2) AS immediate_percentage
FROM 
	(SELECT customer_id,
		 min(order_date) AS min_time
	FROM Delivery
	GROUP BY  customer_id) t1
JOIN Delivery using(customer_id);

SELECT ROUND(AVG(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 end)*100,2) AS immediate_percentage
FROM delivery
WHERE (customer_id, order_date) IN 
	(SELECT customer_id, min(order_date)
	FROM delivery
	GROUP BY  customer_id);

-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

SELECT ROUND(COUNT(player_id) FILTER ( WHERE data_diff = 1 )
                 / COUNT(DISTINCT player_id)::numeric, 2) fraction
FROM (SELECT player_id,
             event_date - FIRST_VALUE(event_date) OVER (PARTITION BY player_id
                 ORDER BY
                     event_date) data_diff
      FROM Activity) t1