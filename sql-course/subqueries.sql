-- Используя данные из таблицы user_actions, рассчитайте среднее число заказов всех пользователей нашего сервиса.

SELECT round(avg(orders_count), 2) as orders_avg
FROM   (SELECT user_id,
               count(order_id) as orders_count
        FROM   user_actions
        WHERE  action = 'create_order'
        GROUP BY user_id) as t1;

with t1 as (SELECT user_id,
                   count(order_id) as orders_count
            FROM   user_actions
            WHERE  action = 'create_order'
            GROUP BY user_id)
SELECT round(avg(orders_count), 2) as orders_avg
FROM   t1;

-- Выведите из таблицы products информацию о всех товарах кроме самого дешёвого.

SELECT product_id,
       name,
       price
FROM   products
WHERE  price > (SELECT min(price)
                FROM   products)
ORDER BY product_id desc;

-- Выведите информацию о товарах в таблице products, цена на которые превышает среднюю цену всех товаров на 20 рублей и более. Результат отсортируйте по убыванию id товара.

SELECT *
FROM   products
WHERE  price > (SELECT avg(price)+20
                FROM   products)
ORDER BY product_id desc;

-- Посчитайте количество уникальных клиентов в таблице user_actions, сделавших за последнюю неделю хотя бы один заказ.

SELECT count(distinct user_id) as users_count
FROM   user_actions
WHERE  time between (SELECT max(time)-interval '1 week'
                     FROM   user_actions) and (SELECT max(time)
                          FROM   user_actions) and action = 'create_order';

-- С помощью функции AGE и агрегирующей функции снова определите возраст самого молодого курьера мужского пола в таблице couriers, но в этот раз при расчётах в качестве первой даты используйте последнюю дату из таблицы courier_actions.

SELECT min(age((SELECT max(time)::date
                FROM   courier_actions), birth_date))::varchar as min_age
FROM   couriers
WHERE  sex = 'male';

-- Из таблицы user_actions с помощью подзапроса или табличного выражения отберите все заказы, которые не были отменены пользователями.

SELECT order_id
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY order_id limit 1000;

-- Используя данные из таблицы user_actions, рассчитайте, сколько заказов сделал каждый пользователь и отразите это в столбце orders_count.
-- В отдельном столбце orders_avg напротив каждого пользователя укажите среднее число заказов всех пользователей, округлив его до двух знаков после запятой.
-- Также для каждого пользователя посчитайте отклонение числа заказов от среднего значения. Отклонение считайте так: число заказов «минус» округлённое среднее значение. Колонку с отклонением назовите orders_diff.

with t1 as (SELECT user_id,
                   count(order_id) as orders_count
            FROM   user_actions
            WHERE  action = 'create_order'
            GROUP BY user_id)
SELECT user_id,
       orders_count,
       (SELECT round(avg(orders_count), 2) FROM   t1) as orders_avg, 
       orders_count-(SELECT round(avg(orders_count), 2) FROM   t1) as orders_diff
FROM   t1
ORDER BY user_id asc limit 1000;

-- Назначьте скидку 15% на товары, цена которых превышает среднюю цену на все товары на 50 и более рублей, а также скидку 10% на товары, цена которых ниже средней на 50 и более рублей. 
-- Цену остальных товаров внутри диапазона (среднее - 50; среднее + 50) оставьте без изменений. При расчёте средней цены, округлите её до двух знаков после запятой.

with t1 as (SELECT round(avg(price), 2) as avg_price
            FROM   products)
SELECT case when price >= (SELECT * FROM   t1) + 50 then price-(price*15/100)
            when price <= (SELECT * FROM   t1) - 50 then price-(price*10/100) 
            when price between (SELECT * FROM   t1) + 50 and (SELECT * FROM   t1) - 50 then price 
            else price end as new_price, 
            price, 
            name, 
            product_id
FROM   products
ORDER BY price desc, product_id asc;

-- Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами, но не были созданы пользователями. Посчитайте количество таких заказов.

SELECT count(distinct order_id) as orders_count
FROM   courier_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions);

-- Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами, но не были доставлены пользователям. Посчитайте количество таких заказов.

SELECT count(order_id) as orders_count
FROM   courier_actions
WHERE  order_id not in (SELECT order_id
                        FROM   courier_actions
                        WHERE  action = 'deliver_order');

-- Определите количество отменённых заказов в таблице courier_actions и выясните, есть ли в этой таблице такие заказы, которые были отменены пользователями, но при этом всё равно были доставлены. 
-- Посчитайте количество таких заказов.

SELECT count(distinct order_id) as orders_canceled,
       count(order_id) filter (WHERE action = 'deliver_order') as orders_canceled_and_delivered
FROM   courier_actions
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order');

-- По таблицам courier_actions и user_actions снова определите число недоставленных заказов и среди них посчитайте количество отменённых заказов и количество заказов, которые не были отменены (и соответственно, пока ещё не были доставлены).

with t1 as (SELECT action,
                   count(order_id) as orders_undelivered
            FROM   courier_actions
            WHERE  order_id not in (SELECT order_id
                                    FROM   courier_actions
                                    WHERE  action = 'deliver_order')
            GROUP BY action)
SELECT (SELECT count(order_id) filter (WHERE action = 'cancel_order')
        FROM   user_actions) as orders_canceled, orders_undelivered-(SELECT count(order_id) filter (WHERE action = 'cancel_order')
                                                             FROM   user_actions) as orders_in_process, orders_undelivered
FROM   t1
GROUP BY orders_undelivered;

-- Отберите из таблицы users пользователей мужского пола, которые старше всех пользователей женского пола.

SELECT user_id,
       birth_date
FROM   users
WHERE  sex = 'male'
   and birth_date < (SELECT min(birth_date) filter (WHERE sex = 'female')
                  FROM   users)
ORDER BY user_id asc;

-- Выведите id и содержимое 100 последних доставленных заказов из таблицы orders.

SELECT order_id,
       product_ids
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   courier_actions
                    WHERE  action = 'deliver_order'
                    ORDER BY time desc limit 100)
ORDER BY order_id asc;

-- Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более заказов.

SELECT birth_date,
       courier_id,
       sex
FROM   couriers
WHERE  courier_id in (SELECT courier_id
                      FROM   courier_actions
                      WHERE  action = 'deliver_order'
                         and date_trunc('month', time) = '2022-09-01'
                      GROUP BY courier_id having count(order_id) >= 30
                      ORDER BY courier_id asc);

-- Рассчитайте средний размер заказов, отменённых пользователями мужского пола.

SELECT round(avg(array_length(product_ids, 1)), 3) as avg_order_size
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order'
                       and user_id in (SELECT user_id
                                    FROM   users
                                    WHERE  sex = 'male'));

-- Посчитайте возраст каждого пользователя в таблице users.
-- Для тех пользователей, у которых в таблице users не указана дата рождения, укажите среднее значение возраста всех остальных пользователей, округлённое до целого числа.

with t1 as (SELECT user_id,
                   date_part('year', age((SELECT max(time)
                                   FROM   user_actions), birth_date)) as age_of_all
            FROM   users)
SELECT user_id,
       coalesce(age_of_all, (SELECT round(avg(age_of_all))
                      FROM   t1))::integer as age
FROM   t1
ORDER BY user_id asc;

-- Для каждого заказа, в котором больше 5 товаров, рассчитайте время, затраченное на его доставку. 
-- В расчётах учитывайте только неотменённые заказы. Время, затраченное на доставку, выразите в минутах, округлив значения до целого числа.

SELECT order_id,
       min(time) as time_accepted,
       max(time) as time_delivered,
       (extract(epoch
FROM   max(time) - min(time))/60)::integer as delivery_time
FROM   courier_actions
WHERE  order_id in (SELECT order_id
                    FROM   orders
                    WHERE  array_length(product_ids, 1) > 5)
   and order_id not in (SELECT order_id
                     FROM   user_actions
                     WHERE  action = 'cancel_order')
GROUP BY order_id
ORDER BY order_id;

-- Для каждой даты в таблице user_actions посчитайте количество первых заказов, совершённых пользователями.
-- Первыми заказами будем считать заказы, которые пользователи сделали в нашем сервисе впервые. В расчётах учитывайте только неотменённые заказы.

SELECT first_order_date as date,
       count(user_id) as first_orders
FROM   (SELECT user_id,
               min(time)::date as first_order_date
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY user_id) t
GROUP BY first_order_date
ORDER BY date;

-- Выберите все колонки из таблицы orders и дополнительно в качестве последней колонки укажите функцию unnest, применённую к колонке product_ids.
-- Эту последнюю колонку назовите product_id. Больше ничего с данными делать не нужно.

SELECT creation_time,
       order_id,
       product_ids,
       unnest(product_ids) as product_id
FROM   orders limit 100;

-- Используя функцию unnest, определите 10 самых популярных товаров в таблице orders.
-- Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего.
-- Если товар встречается в одном заказе несколько раз (когда было куплено несколько единиц товара), это тоже учитывается при подсчёте. Учитывайте только неотменённые заказы.

with t2 as (SELECT product_id,
                   count(product_id) as times_purchased
            FROM   (SELECT order_id,
                           unnest(product_ids) as product_id
                    FROM   orders) as t1
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')
            GROUP BY product_id
            ORDER BY times_purchased desc limit 10)
SELECT *
FROM   t2
ORDER BY product_id asc;

-- Из таблицы orders выведите id и содержимое заказов, которые включают хотя бы один из пяти самых дорогих товаров, доступных в нашем сервисе.

SELECT DISTINCT(order_id),
                product_ids
FROM   (SELECT order_id,
               product_ids,
               unnest(product_ids) as product_id
        FROM   orders) as t1
WHERE  product_id in (SELECT product_id
                      FROM   products
                      ORDER BY price desc limit 5)
ORDER BY 1;

