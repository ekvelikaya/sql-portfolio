-- С помощью оператора GROUP BY посчитайте количество курьеров мужского и женского пола в таблице couriers.

SELECT sex,
       count(courier_id) as couriers_count
FROM   couriers
GROUP BY sex
ORDER BY count(courier_id) asc;

-- Посчитайте количество созданных и отменённых заказов в таблице user_actions.

SELECT action,
       count(order_id) as orders_count
FROM   user_actions
GROUP BY action
ORDER BY orders_count asc;

-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, сколько заказов было сделано в каждом из них.

SELECT count(order_id) as orders_count,
       date_trunc('month', creation_time) as month
FROM   orders
GROUP BY month
ORDER BY month asc;

-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, сколько заказов было сделано и сколько было отменено в каждом из них.

SELECT action,
       count(order_id) as orders_count,
       date_trunc('month', time) as month
FROM   user_actions
GROUP BY action, month
ORDER BY month asc, action asc;

-- По данным в таблице users посчитайте максимальный порядковый номер месяца среди всех порядковых номеров месяцев рождения пользователей сервиса. С помощью группировки проведите расчёты отдельно в двух группах — для пользователей мужского и женского пола.

SELECT sex,
       max(date_part('month', birth_date)::integer) as max_month
FROM   users
GROUP BY sex
ORDER BY sex;

-- По данным в таблице users посчитайте порядковый номер месяца рождения самого молодого пользователя сервиса. С помощью группировки проведите расчёты отдельно в двух группах — для пользователей мужского и женского пола.

SELECT sex,
       date_part('month', max(birth_date))::integer as max_month
FROM   users
GROUP BY sex
ORDER BY sex;

-- Посчитайте максимальный возраст пользователей мужского и женского пола в таблице users. Возраст измерьте числом полных лет.

SELECT sex,
       date_part('year', age(min(birth_date)))::varchar as max_age
FROM   users
GROUP BY sex
ORDER BY max_age;

-- Разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем числом полных лет) и посчитайте количество пользователей каждого возраста.

SELECT count(user_id) as users_count,
       date_part('year', age(birth_date))::integer as age
FROM   users
GROUP BY age
ORDER BY age asc;

-- Вновь разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем количеством полных лет), только теперь добавьте в группировку ещё и пол пользователя. Затем посчитайте количество пользователей в каждой половозрастной группе.

SELECT sex,
       count(user_id) as users_count,
       date_part('year', age(birth_date))::integer as age
FROM   users
WHERE  birth_date is not null
GROUP BY age, sex
ORDER BY age asc, sex asc;

-- Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов в каждой группе за неделю с 29 августа по 4 сентября 2022 года включительно. Для расчётов используйте данные из таблицы orders.

SELECT count(order_id) as orders_count,
       array_length(product_ids, 1) as order_size
FROM   orders
WHERE  creation_time between '2022-08-29'
   and '2022-09-05 00:00:00'
GROUP BY order_size
ORDER BY order_size asc;

-- Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов в каждой группе. Учитывайте только заказы, оформленные по будням. В результат включите только те размеры заказов, общее число которых превышает 2000. Для расчётов используйте данные из таблицы orders.

SELECT count(order_id) as orders_count,
       array_length(product_ids, 1) as order_size
FROM   orders
WHERE  date_part('dow', creation_time) between 1
   and 5
GROUP BY order_size
having count(order_id) > 2000
ORDER BY order_size asc;

-- По данным из таблицы user_actions определите пять пользователей, сделавших в августе 2022 года наибольшее количество заказов.

SELECT user_id,
       count(order_id) as created_orders
FROM   user_actions
WHERE  time between '2022-08-01'
   and '2022-09-01'
GROUP BY user_id, action 
having action = 'create_order'
ORDER BY created_orders desc, user_id asc limit 5;

-- А теперь по данным таблицы courier_actions определите курьеров, которые в сентябре 2022 года доставили только по одному заказу.

SELECT courier_id
FROM   courier_actions
WHERE  date_part('month', time) = 9
   and date_part('year', time) = 2022
   and action = 'deliver_order'
GROUP BY courier_id
HAVING count(order_id) = 1
ORDER BY courier_id asc;

-- Из таблицы user_actions отберите пользователей, у которых последний заказ был создан до 8 сентября 2022 года.

SELECT user_id
FROM   user_actions
WHERE  action = 'create_order'
GROUP BY user_id having max(time) < '2022-09-08'
ORDER BY user_id asc;

-- Разбейте заказы из таблицы orders на 3 группы в зависимости от количества товаров, попавших в заказ:
-- Малый (от 1 до 3 товаров);
-- Средний (от 4 до 6 товаров);
-- Большой (7 и более товаров).

SELECT case when array_length(product_ids, 1) between 1 and
                 3 then 'Малый'
            when array_length(product_ids, 1) between 4 and
                 6 then 'Средний'
            when array_length(product_ids, 1) >= 7 then 'Большой' end as order_size,
       count(order_id) as orders_count
FROM   orders
GROUP BY order_size
ORDER BY orders_count asc;

-- Разбейте пользователей из таблицы users на 4 возрастные группы:
-- от 18 до 24 лет;
-- от 25 до 29 лет;
-- от 30 до 35 лет;
-- старше 36.
-- Посчитайте число пользователей, попавших в каждую возрастную группу.

SELECT case 
    when extract(year FROM   age(birth_date)) between 18 and 24 then '18-24' 
    when extract(year FROM   age(birth_date)) between 25 and 29 then '25-29'
    when extract(year FROM   age(birth_date)) between 30 and 35 then '30-35'
    when extract(year FROM   age(birth_date)) >= 36 then '36+' 
    end as group_age, 
    count(user_id) as users_count FROM   users
WHERE  birth_date is not null
GROUP BY group_age
ORDER BY group_age asc;

-- По данным из таблицы orders рассчитайте средний размер заказа по выходным и будням.
-- Группу с выходными днями (суббота и воскресенье) назовите «weekend», а группу с будними днями (с понедельника по пятницу) — «weekdays» (без кавычек).

SELECT case when date_part('dow', creation_time) in (0, 6) then 'weekend'
            when date_part('dow', creation_time) between 1 and
                 5 then 'weekdays' end as week_part,
       round(avg(array_length(product_ids, 1)), 2) as avg_order_size
FROM   orders
GROUP BY week_part
ORDER BY avg_order_size asc;

-- Для каждого пользователя в таблице user_actions посчитайте общее количество оформленных заказов и долю отменённых заказов.
-- Новые колонки назовите соответственно orders_count и cancel_rate. Колонку с долей отменённых заказов округлите до двух знаков после запятой.
-- В результат включите только тех пользователей, которые оформили больше трёх заказов и у которых показатель cancel_rate составляет не менее 0.5.

SELECT user_id,
       count(order_id) filter (WHERE action = 'create_order') as orders_count,
       round((count(order_id) filter (WHERE action = 'cancel_order')::numeric / count(order_id) filter (WHERE action = 'create_order')), 2) as cancel_rate
FROM   user_actions
GROUP BY user_id 
having count(order_id) filter (WHERE  action = 'create_order') > 3 
                                and round((count(order_id) filter (WHERE  action = 'cancel_order')::numeric / count(order_id) filter (WHERE  action = 'create_order')), 2) >= 0.5
ORDER BY user_id asc;

-- Для каждого дня недели в таблице user_actions посчитайте:
-- Общее количество оформленных заказов.
-- Общее количество отменённых заказов.
-- Общее количество неотменённых заказов (т.е. доставленных).
-- Долю неотменённых заказов в общем числе заказов (success rate).
-- Новые колонки назовите соответственно created_orders, canceled_orders, actual_orders и success_rate. Колонку с долей неотменённых заказов округлите до трёх знаков после запятой.
-- Все расчёты проводите за период с 24 августа по 6 сентября 2022 года включительно, чтобы во временной интервал попало равное количество разных дней недели.
-- Группы сформируйте следующим образом: выделите день недели из даты с помощью функции to_char с параметром 'Dy', также выделите порядковый номер дня недели с помощью функции DATE_PART с параметром 'isodow'. Далее сгруппируйте данные по двум полям и проведите все необходимые расчёты.

SELECT count(order_id) filter (WHERE action = 'create_order') as created_orders,
       count(order_id) filter (WHERE action = 'cancel_order') as canceled_orders,
       count(order_id) filter (WHERE action = 'create_order') - count(order_id) filter (WHERE action = 'cancel_order') as actual_orders,
       round((count(order_id) filter (WHERE action = 'create_order')::decimal - count(order_id) filter (WHERE action = 'cancel_order')::decimal)/count(order_id) filter (WHERE action = 'create_order')::decimal,
             3) as success_rate,
       date_part('isodow', time)::varchar as weekday_number,
       to_char(time, 'Dy') as weekday
FROM   user_actions
WHERE  time between '2022-08-24'
   and '2022-09-07'
GROUP BY date_part('isodow', time), to_char(time, 'Dy')
ORDER BY weekday_number asc;









