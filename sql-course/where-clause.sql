-- Выведите всю информацию о товарах, цена которых не превышает 100 рублей. Результат отсортируйте по возрастанию id товара.

SELECT name,
       price,
       product_id
FROM   products
WHERE  price <= 100
ORDER BY product_id asc;

-- Отберите пользователей женского пола, выведите только id этих пользователей. Результат отсортируйте по возрастанию id. Добавьте в запрос оператор LIMIT и выведите только 1000 первых id из отсортированного списка.

SELECT user_id
FROM   users
WHERE  sex = 'female'
ORDER BY user_id limit 1000;

-- Отберите из таблицы user_actions все действия пользователей по созданию заказов, которые были совершены ими после полуночи 6 сентября 2022 года. Выведите колонки с id пользователей, id созданных заказов и временем их создания.

SELECT user_id,
       order_id,
       time
FROM   user_actions
WHERE  action = 'create_order'
   and time > '2022-09-06'
ORDER BY order_id asc;

-- Назначьте скидку 20% на все товары из таблицы products и отберите те, цена на которые с учётом скидки превышает 100 рублей. Выведите id товаров, их наименования, прежнюю цену и новую цену с учётом скидки. Колонку со старой ценой назовите old_price, с новой — new_price.

SELECT price as old_price,
       name,
       product_id,
       price-price*20/100 as new_price
FROM   products
WHERE  price-price*20/100 > 100
ORDER BY product_id asc;

-- Отберите из таблицы products все товары, названия которых либо начинаются со слова «чай», либо состоят из пяти символов. Выведите две колонки: id товаров и их наименования.

SELECT name,
       product_id
FROM   products
WHERE  split_part(name, ' ', 1) = 'чай'
    or length(name) = 5
ORDER BY product_id asc;

-- Отберите из таблицы products все товары, содержащие в своём названии последовательность символов «чай» (без кавычек). Выведите две колонки: id продукта и его название.

SELECT name,
       product_id
FROM   products
WHERE  name like '%чай%'
ORDER BY product_id asc;

-- Выберите из таблицы products id и наименования только тех товаров, названия которых начинаются на букву «с» и содержат только одно слово.

SELECT name,
       product_id
FROM   products
WHERE  name like 'с%'
   and name not like '% %'
ORDER BY product_id asc;

-- Составьте SQL-запрос, который выбирает из таблицы products все чаи стоимостью больше 60 рублей и вычисляет для них цену со скидкой 25%.
-- Скидку в % менеджер попросил указать в отдельном столбце в формате текста, то есть вот так: «25%» (без кавычек). Столбцы со скидкой и новой ценой назовите соответственно discount и new_price.
-- Также необходимо любым известным способом избавиться от «чайного гриба»: вряд ли менеджер имел в виду и его, когда ставил нам задачу.

SELECT price,
       name,
       product_id,
       '25%' as discount,
       price-price*25/100 as new_price
FROM   products
WHERE  name like '%чай%'
   and name not like '%гриб%'
   and price > '60'
ORDER BY product_id asc;

-- Из таблицы user_actions выведите всю информацию о действиях пользователей с id 170, 200 и 230 за период с 25 августа по 4 сентября 2022 года включительно.

SELECT *
FROM   user_actions
WHERE  user_id in (170, 200, 230)
   and time between '2022-08-25 00:00:00'
   and '2022-09-05 00:00:00'
ORDER BY order_id desc;

-- Выведите всю информацию о курьерах, у которых не указан их день рождения.

SELECT *
FROM   couriers
WHERE  birth_date is null
ORDER BY courier_id asc;

-- Определите id и даты рождения 50 самых молодых пользователей мужского пола из таблицы users. Не учитывайте тех пользователей, у которых не указана дата рождения.

SELECT user_id,
       birth_date
FROM   users
WHERE  birth_date is not null
   and sex = 'male'
ORDER BY birth_date desc limit 50;

-- Напишите SQL-запрос к таблице courier_actions, чтобы узнать id и время доставки последних 10 заказов, доставленных курьером с id 100.

SELECT order_id,
       time
FROM   courier_actions
WHERE  courier_id = '100'
   and action = 'deliver_order'
ORDER BY time desc limit 10;

-- Из таблицы user_actions получите id всех заказов, сделанных пользователями сервиса в августе 2022 года.

SELECT order_id
FROM   user_actions
WHERE  time between '2022-08-01'
   and '2022-09-01'
   and action = 'create_order'
ORDER BY order_id asc;

-- Из таблицы couriers отберите id всех курьеров, родившихся в период с 1990 по 1995 год включительно.

SELECT courier_id
FROM   couriers
WHERE  birth_date between '1990-01-01'
   and '1995-12-31'
ORDER BY courier_id asc;

-- Из таблицы user_actions получите информацию о всех отменах заказов, которые пользователи совершали в течение августа 2022 года по средам с 12:00 до 15:59.

SELECT action,
       user_id,
       time,
       order_id
FROM   user_actions
WHERE  action = 'cancel_order'
   and date_part('dow', time) = 3
   and date_part('year', time) = 2022
   and date_part('month', time) = 8
   and date_part('hour', time) between 12
   and 15
ORDER BY order_id desc;

-- Вычислите НДС каждого товара в таблице products и рассчитайте цену без учёта НДС. Однако теперь примите во внимание, что для товаров из списка налог составляет 10%.
-- Для остальных товаров НДС тот же — 20%. Выведите всю информацию о товарах, включая сумму налога и цену без его учёта. 
-- Колонки с суммой налога и ценой без НДС назовите соответственно tax и price_before_tax. Округлите значения в этих колонках до двух знаков после запятой.

SELECT product_id,
       name,
       price,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
            then round(price/110*10, 2)
            else round(price/120*20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
            then round(price-price/110*10,2)
            else round(price-price/120*20, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id asc;


