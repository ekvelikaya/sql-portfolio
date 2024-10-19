-- Выведите id всех уникальных пользователей из таблицы user_actions. 

SELECT DISTINCT user_id
FROM   user_actions
ORDER BY user_id asc;

-- Примените DISTINCT сразу к двум колонкам таблицы courier_actions и отберите уникальные пары значений courier_id и order_id.

SELECT DISTINCT courier_id,
                order_id
FROM   courier_actions
ORDER BY courier_id asc, order_id;

-- Посчитайте максимальную и минимальную цены товаров в таблице products.

SELECT max(price) as max_price,
       min(price) as min_price
FROM   products;

-- Как вы помните, в таблице users у некоторых пользователей не были указаны их даты рождения. Посчитайте в одном запросе количество всех записей в таблице и количество только тех записей, для которых в колонке birth_date указана дата рождения.

SELECT count(*) as dates,
       count(birth_date) as dates_not_null
FROM   users;

-- Посчитайте количество всех значений в колонке user_id в таблице user_actions, а также количество уникальных значений в этой колонке (т.е. количество уникальных пользователей сервиса).

SELECT count(user_id) as users,
       count(distinct user_id) as unique_users
FROM   user_actions;

-- Посчитайте количество курьеров женского пола в таблице couriers. Полученный столбец с одним значением назовите couriers.

SELECT count(sex) as couriers
FROM   couriers
WHERE  sex = 'female';

-- Рассчитайте время, когда были совершены первая и последняя доставки заказов в таблице courier_actions.

SELECT min(time) as first_delivery,
       max(time) as last_delivery
FROM   courier_actions
WHERE  action = 'deliver_order';

-- Представьте, что один из пользователей сервиса сделал заказ, в который вошли одна пачка сухариков, одна пачка чипсов и один энергетический напиток. Посчитайте стоимость такого заказа.

SELECT sum(price) as order_price
FROM   products
WHERE  name in ('сухарики', 'чипсы', 'энергетический напиток');

-- Посчитайте количество заказов в таблице orders с девятью и более товарами. Для этого воспользуйтесь функцией array_length, отфильтруйте данные по количеству товаров в заказе и проведите агрегацию. 

SELECT count(array_length(product_ids, 1)) as orders
FROM   orders
WHERE  array_length(product_ids, 1) >= 9
ORDER BY orders desc;

-- С помощью функции AGE и агрегирующей функции рассчитайте возраст самого молодого курьера мужского пола в таблице couriers.

SELECT age(max(birth_date))::varchar as min_age
FROM   couriers
WHERE  sex = 'male';

-- Посчитайте стоимость заказа, в котором будут три пачки сухариков, две пачки чипсов и один энергетический напиток. Колонку с рассчитанной стоимостью заказа назовите order_price.

SELECT sum(case when name = 'сухарики' then price*3
                when name = 'чипсы' then price*2
                when name = 'энергетический напиток' then price
                else 0 end) as order_price
FROM   products;

-- Рассчитайте среднюю цену товаров в таблице products, в названиях которых присутствуют слова «чай» или «кофе». 
-- Любым известным способом исключите из расчёта товары, содержащие в названии «иван-чай» или «чайный гриб».
-- Среднюю цену округлите до двух знаков после запятой. Столбец с полученным значением назовите avg_price.

SELECT round(avg(price), 2) as avg_price
FROM   products
WHERE  (name like '%чай%'
    or name like '%кофе%')
   and name not like '%иван-чай%'
   and name not like '%чайный гриб%';

-- Воспользуйтесь функцией AGE и рассчитайте разницу в возрасте между самым старым и самым молодым пользователями мужского пола в таблице users. 

SELECT age(max(birth_date), min(birth_date))::varchar as age_diff
FROM   users
WHERE  sex = 'male';

-- Рассчитайте среднее количество товаров в заказах из таблицы orders, которые пользователи оформляли по выходным дням (суббота и воскресенье) в течение всего времени работы сервиса.

SELECT round(avg(array_length(product_ids, 1)), 2) as avg_order_size
FROM   orders
WHERE  date_part('dow', creation_time) = 0
    or date_part('dow', creation_time) = 6;

-- На основе данных в таблице user_actions посчитайте количество уникальных пользователей сервиса, количество уникальных заказов, поделите одно на другое и выясните, сколько заказов приходится на одного пользователя.

SELECT count(distinct(user_id)) as unique_users,
       count(distinct(order_id)) as unique_orders,
       round(count(distinct(order_id))/count(distinct(user_id))::decimal, 2) as orders_per_user
FROM   user_actions;

-- Посчитайте, сколько пользователей никогда не отменяли свой заказ. Для этого из общего числа всех уникальных пользователей отнимите число уникальных пользователей, которые хотя бы раз отменяли заказ. 

SELECT count(distinct(user_id))-count(distinct(user_id)) filter (WHERE action like 'cancel_order') as users_count
FROM   user_actions;

-- Посчитайте общее количество заказов в таблице orders, количество заказов с пятью и более товарами и найдите долю заказов с пятью и более товарами в общем количестве заказов.

SELECT count(order_id) as orders,
       count(product_ids) filter (WHERE array_length(product_ids, 1) >= 5) as large_orders,
       round(count(product_ids) filter (WHERE array_length(product_ids, 1) >= 5)::decimal/count(order_id)::decimal, 2) as large_orders_share
FROM   orders;