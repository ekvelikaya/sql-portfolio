-- Объедините таблицы user_actions и users по ключу user_id. В результат включите две колонки с user_id из обеих таблиц. Эти две колонки назовите соответственно user_id_left и user_id_right. 
-- Также в результат включите колонки order_id, time, action, sex, birth_date. Отсортируйте получившуюся таблицу по возрастанию id пользователя (в любой из двух колонок с id).

SELECT user_actions.user_id as user_id_left,
       users.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions
    INNER JOIN users
        ON user_actions.user_id = users.user_id
ORDER BY user_id_left asc;

-- А теперь попробуйте немного переписать запрос из прошлого задания и посчитать количество уникальных id в объединённой таблице. То есть снова объедините таблицы, но в этот раз просто посчитайте уникальные user_id в одной из колонок с id. 
-- Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.

SELECT count(distinct a.user_id) as users_count
FROM   user_actions a join users b using(user_id);

-- С помощью LEFT JOIN объедините таблицы user_actions и users по ключу user_id. Обратите внимание на порядок таблиц — слева users_actions, справа users. В результат включите две колонки с user_id из обеих таблиц. 
-- Эти две колонки назовите соответственно user_id_left и user_id_right. 
-- Также в результат включите колонки order_id, time, action, sex, birth_date. Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).

SELECT a.user_id as user_id_left,
       b.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions a
    LEFT JOIN users b using(user_id)
ORDER BY user_id_left;

-- Теперь снова попробуйте немного переписать запрос из прошлого задания и посчитайте количество уникальных id в колонке user_id, пришедшей из левой таблицы user_actions. 
-- Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.

SELECT count(distinct a.user_id) as users_count
FROM   user_actions a
    LEFT JOIN users b
        ON a.user_id = b.user_id;

-- Возьмите запрос из задания 3, где вы объединяли таблицы user_actions и users с помощью LEFT JOIN, добавьте к запросу оператор WHERE и исключите NULL значения в колонке user_id из правой таблицы.
-- Включите в результат все те же колонки и отсортируйте получившуюся таблицу по возрастанию id пользователя в колонке из левой таблицы.

SELECT a.user_id as user_id_left,
       b.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions a
    LEFT JOIN users b using(user_id)
WHERE  b.user_id is not null
ORDER BY user_id_left asc;

-- С помощью FULL JOIN объедините по ключу birth_date таблицы, полученные в результате вышеуказанных запросов (то есть объедините друг с другом два подзапроса). 
-- Не нужно изменять их, просто добавьте нужный JOIN. В результат включите две колонки с birth_date из обеих таблиц.
-- Эти две колонки назовите соответственно users_birth_date и couriers_birth_date. Также включите в результат колонки с числом пользователей и курьеров — users_count и couriers_count.

SELECT a.birth_date as users_birth_date,
       b.birth_date as couriers_birth_date,
       users_count,
       couriers_count
FROM   (SELECT birth_date,
               count(user_id) as users_count
        FROM   users
        WHERE  birth_date is not null
        GROUP BY birth_date) a full join (SELECT birth_date,
                                         count(courier_id) as couriers_count
                                  FROM   couriers
                                  WHERE  birth_date is not null
                                  GROUP BY birth_date) b using (birth_date)
ORDER BY users_birth_date asc, couriers_birth_date asc;

-- Объедините два следующих запроса друг с другом так, чтобы на выходе получился набор уникальных дат из таблиц users и couriers:
SELECT birth_date
FROM users
WHERE birth_date IS NOT NULL

SELECT birth_date
FROM couriers
WHERE birth_date IS NOT NULL

-- Поместите в подзапрос полученный после объединения набор дат и посчитайте их количество. Колонку с числом дат назовите dates_count.

SELECT count(distinct birth_date) as dates_count
FROM   (SELECT birth_date
        FROM   users
        WHERE  birth_date is not null
        UNION
        SELECT birth_date
        FROM   couriers
        WHERE  birth_date is not null) t1;

-- Из таблицы users отберите id первых 100 пользователей (просто выберите первые 100 записей, используя простой LIMIT) и с помощью CROSS JOIN объедините их со всеми наименованиями товаров из таблицы products. Выведите две колонки — id пользователя и наименование товара.
-- Результат отсортируйте сначала по возрастанию id пользователя, затем по имени товара — тоже по возрастанию.

SELECT name,
       user_id
FROM   products cross join (SELECT user_id
                            FROM   users limit 100) t1
ORDER BY user_id asc, name asc;

-- Для начала объедините таблицы user_actions и orders — это вы уже умеете делать. В качестве ключа используйте поле order_id.
-- Выведите id пользователей и заказов, а также список товаров в заказе. Отсортируйте таблицу по id пользователя по возрастанию, затем по id заказа — тоже по возрастанию.

SELECT user_id,
       order_id,
       product_ids
FROM   user_actions a
    LEFT JOIN orders b using(order_id)
ORDER BY user_id asc, order_id asc 
limit 1000;

-- Снова объедините таблицы user_actions и orders, но теперь оставьте только уникальные неотменённые заказы (мы делали похожий запрос на прошлом уроке).
--  Остальные условия задачи те же: вывести id пользователей и заказов, а также список товаров в заказе.
-- Отсортируйте таблицу по id пользователя по возрастанию, затем по id заказа — тоже по возрастанию.

SELECT DISTINCT a.order_id as order_id,
                product_ids,
                user_id
FROM   user_actions a
    LEFT JOIN orders b using(order_id)
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id asc, a.order_id asc 
limit 1000;

-- Используя запрос из предыдущего задания, посчитайте, сколько в среднем товаров заказывает каждый пользователь. Выведите id пользователя и среднее количество товаров в заказе. 
-- Среднее значение округлите до двух знаков после запятой. Колонку посчитанными значениями назовите avg_order_size. Результат выполнения запроса отсортируйте по возрастанию id пользователя. 

SELECT user_id,
       round(avg(array_length(product_ids, 1)), 2) as avg_order_size
FROM   (SELECT user_id,
               order_id
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t
    LEFT JOIN orders using(order_id)
GROUP BY user_id
ORDER BY user_id 
limit 1000;

-- Для начала к таблице с заказами (orders) примените функцию unnest, как мы делали в прошлом уроке. Колонку с id товаров назовите product_id. 
-- Затем к образовавшейся расширенной таблице по ключу product_id добавьте информацию о ценах на товары (из таблицы products). Должна получиться таблица с заказами, товарами внутри каждого заказа и ценами на эти товары. 
-- Выведите колонки с id заказа, id товара и ценой товара. Результат отсортируйте сначала по возрастанию id заказа, затем по возрастанию id товара.

SELECT order_id,
       product_id,
       price
FROM   (SELECT order_id,
               unnest(product_ids) as product_id
        FROM   orders) a
    LEFT JOIN products using(product_id)
ORDER BY order_id, product_id
limit 1000;

-- Используя запрос из предыдущего задания, рассчитайте суммарную стоимость каждого заказа. Выведите колонки с id заказов и их стоимостью. 
-- Колонку со стоимостью заказа назовите order_price. Результат отсортируйте по возрастанию id заказа.

SELECT order_id,
       sum(price) as order_price
FROM   (SELECT order_id,
               unnest(product_ids) as product_id
        FROM   orders) a
    LEFT JOIN products using(product_id)
GROUP BY order_id limit 1000;

-- Объедините запрос из предыдущего задания с частью запроса, который вы составили в задаче 11, то есть объедините запрос со стоимостью заказов с запросом, в котором вы считали размер каждого заказа из таблицы user_actions.
-- На основе объединённой таблицы для каждого пользователя рассчитайте следующие показатели:
-- общее число заказов — колонку назовите orders_count
-- среднее количество товаров в заказе — avg_order_size
-- суммарную стоимость всех покупок — sum_order_value
-- среднюю стоимость заказа — avg_order_value
-- минимальную стоимость заказа — min_order_value
-- максимальную стоимость заказа — max_order_value

SELECT user_id,
       count(distinct order_id) as orders_count,
       round(avg(order_size), 2) as avg_order_size,
       sum(order_price) as sum_order_value,
       round(avg(order_price), 2) as avg_order_value,
       min(order_price) as min_order_value,
       max(order_price) as max_order_value
FROM   (SELECT order_id,
               sum(price) as order_price
        FROM   (SELECT order_id,
                       unnest(product_ids) as product_id
                FROM   orders) a
            LEFT JOIN products using(product_id)
        GROUP BY order_id) t1
    LEFT JOIN (SELECT order_id,
                      user_id,
                      array_length(product_ids, 1) as order_size
               FROM   (SELECT user_id,
                              order_id
                       FROM   user_actions
                       WHERE  order_id not in (SELECT order_id
                                               FROM   user_actions
                                               WHERE  action = 'cancel_order')) t
                   LEFT JOIN orders using(order_id)) t2 using(order_id)
GROUP BY t2.user_id
limit 1000;

-- По данным таблиц orders, products и user_actions посчитайте ежедневную выручку сервиса. Под выручкой будем понимать стоимость всех реализованных товаров, содержащихся в заказах.

SELECT sum(price)::decimal as revenue,
       date
FROM   (SELECT price,
               product_id
        FROM   products) a
    LEFT JOIN (SELECT creation_time::date as date,
                      order_id,
                      unnest(product_ids) as product_id
               FROM   orders
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order')) b using(product_id)
GROUP BY date
ORDER BY date;

-- По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года.
-- Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. Если товар встречается в одном заказе несколько раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара.

with t3 as (SELECT DISTINCT product_id,
                            order_id,
                            name,
                            time
            FROM   (SELECT order_id,
                           unnest(product_ids) as product_id
                    FROM   orders) t1
                LEFT JOIN products using (product_id)
                LEFT JOIN courier_actions using (order_id)
            WHERE  action = 'deliver_order'
               and time >= '2022-09-01'
               and time <= '2022-09-30')
SELECT name,
       count(product_id) as times_purchased
FROM   t3
GROUP BY name
ORDER BY times_purchased desc
limit 10;

-- Возьмите запрос, составленный на одном из прошлых уроков, и подтяните в него из таблицы users данные о поле пользователей таким образом, чтобы все пользователи из таблицы user_actions остались в результате. 
-- Затем посчитайте среднее значение cancel_rate для каждого пола, округлив его до трёх знаков после запятой. Колонку с посчитанным средним значением назовите avg_cancel_rate.
-- Помните про отсутствие информации о поле некоторых пользователей после join, так как не все пользователи из таблицы user_action есть в таблице users. 
-- Для этой группы тоже посчитайте cancel_rate и в результирующей таблице для пустого значения в колонке с полом укажите ‘unknown’ (без кавычек). 
-- Возможно, для этого придётся вспомнить, как работает COALESCE.

SELECT coalesce(sex, 'unknown') as sex,
       round(avg(cancel_rate), 3) as avg_cancel_rate
FROM   (SELECT user_id,
               count(distinct order_id) filter (WHERE action = 'cancel_order')::decimal / count(distinct order_id) as cancel_rate
        FROM   user_actions
        GROUP BY user_id) a
    LEFT JOIN users b using(user_id)
GROUP BY sex
ORDER BY sex asc;

-- По таблицам orders и courier_actions определите id десяти заказов, которые доставляли дольше всего.

SELECT order_id
FROM   (SELECT creation_time,
               time,
               time-creation_time as timefororder,
               order_id,
               action
        FROM   orders
            LEFT JOIN courier_actions using(order_id)
        WHERE  action = 'deliver_order'
        ORDER BY timefororder desc limit 10) t;

-- Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров. Наименования возьмите из таблицы products. Колонку с новыми списками наименований назовите product_names. 

SELECT order_id,
       array_agg(name) as product_names
FROM   (SELECT order_id,
               unnest(product_ids) as product_id
        FROM   orders) a
    LEFT JOIN products using(product_id)
GROUP BY order_id
limit 1000;

-- Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.
-- Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера. Возраст измерьте числом полных лет, как мы делали в прошлых уроках.
-- Считайте его относительно последней даты в таблице user_actions — как для пользователей, так и для курьеров. Колонки с возрастом назовите user_age и courier_age.

SELECT DISTINCT order_id,
                courier_id,
                user_id,
                date_part('year', age((SELECT max(time) FROM   user_actions), 
                couriers.birth_date))::varchar as courier_age,
                date_part('year', age((SELECT max(time) FROM   user_actions), users.birth_date))::varchar as user_age
FROM   (SELECT order_id
        FROM   (SELECT order_id,
                       array_length(product_ids, 1) as count
                FROM   orders
                ORDER BY count desc) t
        WHERE  count = 9) t1
    LEFT JOIN courier_actions using(order_id)
    LEFT JOIN user_actions using(order_id)
    LEFT JOIN couriers using(courier_id)
    LEFT JOIN users using (user_id)
ORDER BY order_id;


