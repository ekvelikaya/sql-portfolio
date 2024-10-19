-- Примените оконные функции к таблице products и с помощью ранжирующих функций упорядочьте все товары по цене — от самых дорогих к самым дешёвым. Добавьте в таблицу следующие колонки:
-- Колонку product_number с порядковым номером товара (функция ROW_NUMBER).
-- Колонку product_rank с рангом товара с пропусками рангов (функция RANK).
-- Колонку product_dense_rank с рангом товара без пропусков рангов (функция DENSE_RANK).

SELECT product_id,
       name,
       price,
       row_number() OVER(ORDER BY price desc) as product_number,
       rank() OVER(ORDER BY price desc) as product_rank,
       dense_rank() OVER(ORDER BY price desc) as product_dense_rank
FROM   products;

-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке для каждой записи проставьте цену самого дорогого товара. Колонку с этим значением назовите max_price.

SELECT product_id,
       name,
       price,
       max(price) OVER() as max_price,
       round((price/max(price) OVER()), 2) as share_of_max
FROM   products
ORDER BY price desc, product_id;

-- Примените две оконные функции к таблице products. Одну с агрегирующей функцией MAX, а другую с агрегирующей функцией MIN — для вычисления максимальной и минимальной цены. 
-- Для двух окон задайте инструкцию ORDER BY по убыванию цены. Поместите результат вычислений в две колонки max_price и min_price.

SELECT name,
       product_id,
       price,
       max(price) OVER(ORDER BY price desc) as max_price,
       min(price) OVER(ORDER BY price desc) as min_price
FROM   products
ORDER BY price desc, product_id;

-- Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. При подсчёте числа заказов не учитывайте отменённые заказы (их можно определить по таблице user_actions). 
-- Колонку с днями назовите date, а колонку с числом заказов — orders_count.
-- Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей функцией SUM для расчёта накопительной суммы числа заказов. 
-- Не забудьте для окна задать инструкцию ORDER BY по дате.

SELECT creation_time::date as date,
       count(order_id) as orders_count,
       sum(count(order_id)::integer) OVER (ORDER BY creation_time::date) as orders_cum_count
FROM   orders
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
GROUP BY date;

-- Для каждого пользователя в таблице user_actions посчитайте порядковый номер каждого заказа.
-- Для этого примените оконную функцию ROW_NUMBER к колонке с временем заказа. Не забудьте указать деление на партиции по пользователям и сортировку внутри партиций. 
-- Отменённые заказы не учитывайте.

SELECT user_id,
       order_id,
       time,
       row_number () OVER (PARTITION BY user_id
                           ORDER BY time) as order_number
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_number limit 1000;

-- Дополните запрос из предыдущего задания и с помощью оконной функции для каждого заказа каждого пользователя рассчитайте, сколько времени прошло с момента предыдущего заказа. 

SELECT user_id,
       order_id,
       time,
       row_number() OVER(PARTITION BY user_id
                         ORDER BY time) as order_number,
       lag(time) OVER(PARTITION BY user_id
                      ORDER BY time) as time_lag,
       time-lag(time) OVER(PARTITION BY user_id
                           ORDER BY time) as time_diff
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY user_id, order_number
limit 1000;

-- На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в среднем времени проходит между его заказами. 
-- Посчитайте этот показатель только для тех пользователей, которые за всё время оформили более одного неотмененного заказа.

SELECT user_id,
       round(avg(hours_between))::integer as hours_between_orders
FROM   (SELECT order_id,
               user_id,
               extract(epoch
        FROM   time-lag(time)
        OVER(
        PARTITION BY user_id
        ORDER BY time))/3600 as hours_between
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t1
GROUP BY user_id having count(order_id) > 1
ORDER BY user_id limit 1000;

-- Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. Вы уже делали это в одной из предыдущих задач.
-- При подсчёте числа заказов не учитывайте отменённые заказы (их можно определить по таблице user_actions). Колонку с числом заказов назовите orders_count.
-- Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей функцией AVG для расчёта скользящего среднего числа заказов.
-- Скользящее среднее для каждой записи считайте по трём предыдущим дням. Подумайте, как правильно задать границы рамки, чтобы получить корректные расчёты.
-- Полученные значения скользящего среднего округлите до двух знаков после запятой. Колонку с рассчитанным показателем назовите moving_avg. Сортировку результирующей таблицы делать не нужно.

SELECT orders_count,
       date,
       round(avg(orders_count) OVER(ORDER BY date rows between 3 preceding and 1 preceding),
             2) as moving_avg
FROM   (SELECT count(order_id) as orders_count,
               creation_time::date as date
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY date) t;

-- Отметьте в отдельной таблице тех курьеров, которые доставили в сентябре 2022 года заказов больше, чем в среднем все курьеры.
-- Сначала для каждого курьера в таблице courier_actions рассчитайте общее количество доставленных в сентябре заказов. 
-- Затем в отдельном столбце с помощью оконной функции укажите, сколько в среднем заказов доставили в этом месяце все курьеры. После этого сравните число заказов, доставленных каждым курьером, со средним значением в новом столбце.
-- Если курьер доставил больше заказов, чем в среднем все курьеры, то в отдельном столбце с помощью CASE укажите число 1, в противном случае укажите 0.
-- Колонку с результатом сравнения назовите is_above_avg, колонку с числом доставленных заказов каждым курьером — delivered_orders, а колонку со средним значением — avg_delivered_orders. 
-- При расчёте среднего значения округлите его до двух знаков после запятой. Результат отсортируйте по возрастанию id курьера.

SELECT courier_id,
       count(order_id) as delivered_orders,
       round(avg(count(order_id)) OVER(), 2) as avg_delivered_orders,
       case when count(order_id) > avg(count(order_id)) OVER() then '1'
            else 0 end as is_above_avg
FROM   courier_actions
WHERE  action = 'deliver_order'
   and date_part('month', time) = 9
GROUP BY courier_id
ORDER BY courier_id;

-- По данным таблицы user_actions посчитайте число первых и повторных заказов на каждую дату.

SELECT count(order_id) as orders_count,
       date,
       order_type
FROM   (SELECT order_id,
               case when row_number() OVER(PARTITION BY user_id
                                           ORDER BY time) = '1' then 'Первый'
                    else 'Повторный' end as order_type,
               time::date as date
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t1
GROUP BY order_type, date
ORDER BY date asc, order_type;

-- К запросу, полученному на предыдущем шаге, примените оконную функцию и для каждого дня посчитайте долю первых и повторных заказов. 
-- Сохраните структуру полученной ранее таблицы и добавьте только одну новую колонку с посчитанными значениями.

SELECT count(order_id) as orders_count,
       date,
       order_type,
       round(count(order_id)/sum(count(order_id)) OVER(PARTITION BY date),
             2) as orders_share
FROM   (SELECT order_id,
               case when row_number() OVER(PARTITION BY user_id
                                           ORDER BY time) = '1' then 'Первый'
                    else 'Повторный' end as order_type,
               time::date as date
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t1
GROUP BY order_type, date
ORDER BY date asc, order_type;

-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке для каждой записи проставьте среднюю цену всех товаров. Колонку с этим значением назовите avg_price.
-- Затем с помощью оконной функции и оператора FILTER в отдельной колонке рассчитайте среднюю цену товаров без учёта самого дорогого. Колонку с этим средним значением назовите avg_price_filtered. 
-- Полученные средние значения в колонках avg_price и avg_price_filtered округлите до двух знаков после запятой.
-- Выведите всю информацию о товарах, включая значения в новых колонках. Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию id товара.

SELECT name,
       price,
       product_id,
       round(avg(price) OVER(), 2) as avg_price,
       round(avg(price) filter (WHERE price not in (SELECT max(price) FROM  products)) OVER(), 2) as avg_price_filtered
FROM   products
ORDER BY price desc, product_id;

-- Для каждой записи в таблице user_actions с помощью оконных функций и предложения FILTER посчитайте, сколько заказов сделал и сколько отменил каждый пользователь на момент совершения нового действия.
-- Иными словами, для каждого пользователя в каждый момент времени посчитайте две накопительные суммы — числа оформленных и числа отменённых заказов. 
-- Если пользователь оформляет заказ, то число оформленных им заказов увеличивайте на 1, если отменяет — увеличивайте на 1 количество отмен.
-- Колонки с накопительными суммами числа оформленных и отменённых заказов назовите соответственно created_orders и canceled_orders. 
-- На основе этих двух колонок для каждой записи пользователя посчитайте показатель cancel_rate, т.е. долю отменённых заказов в общем количестве оформленных заказов. 
-- Значения показателя округлите до двух знаков после запятой. Колонку с ним назовите cancel_rate.

SELECT user_id,
       order_id,
       action,
       time,
       count(order_id) filter(WHERE action = 'cancel_order') OVER(PARTITION BY user_id ORDER BY time) as canceled_orders,
       count(order_id) filter(WHERE action = 'create_order') OVER(PARTITION BY user_id ORDER BY time) as created_orders,
       round(count(order_id) filter(WHERE action = 'cancel_order') OVER (PARTITION BY user_id ORDER BY time) / 
       count(order_id) filter(WHERE action = 'create_order') OVER(PARTITION BY user_id ORDER BY time)::decimal, 2) as cancel_rate
FROM   user_actions
ORDER BY user_id, order_id, time
limit 1000;

-- С помощью оконной функции отберите из таблицы courier_actions всех курьеров, которые работают в нашей компании 10 и более дней. 
-- Также рассчитайте, сколько заказов они уже успели доставить за всё время работы. 
-- Будем считать, что наш сервис предлагает самые выгодные условия труда и поэтому за весь анализируемый период ни один курьер не уволился из компании. 
-- Возможные перерывы между сменами не учитывайте — для нас важна только разница во времени между первым действием курьера и текущей отметкой времени.
-- Текущей отметкой времени, относительно которой необходимо рассчитывать продолжительность работы курьера, считайте время последнего действия в таблице courier_actions. 
-- Учитывайте только целые дни, прошедшие с момента первого выхода курьера на работу (часы и минуты не учитывайте).

with t1 as (SELECT courier_id,
                   order_id,
                   time,
                   action,
                   min(time) filter(WHERE action = 'accept_order') OVER (PARTITION BY courier_id) as min_time,
                   max(time) OVER() as max_time
            FROM   courier_actions)
SELECT courier_id,
       date_part('day', max_time-min_time)::integer as days_employed,
       count(order_id) filter(WHERE action = 'deliver_order') as delivered_orders
FROM   t1
GROUP BY courier_id, days_employed having date_part('day', max_time-min_time)::integer >= 10
ORDER BY days_employed desc, courier_id;






