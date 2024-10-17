--1.
SELECT * -- select - оператор; * - выводим все записи со значениями во всех колонках;
FROM   products; -- from - оператор;

--2. 
SELECT product_id,
       name,
       price
FROM   products
ORDER BY name asc; -- сортировка значений по колонкам (asc or desc);

--3.
SELECT *
FROM   courier_actions
ORDER BY courier_id asc, action asc, time desc
LIMIT 1000; -- используем для ограничения числа извлекаемых из таблицы записей;

--4.
SELECT name,
       price
FROM   products
ORDER BY price desc
LIMIT 5;

--5.
SELECT name as product_name, -- alias;
       price as product_price
FROM   products
ORDER BY price desc
LIMIT 5;

--6.
SELECT name,
       length(name) as name_length, -- функция; подсчитываем длину в символах для каждого значения в столбце;
       price
FROM   products
ORDER BY name_length desc
LIMIT 1;

--7.
-- функции можно применять к результату других функций;
-- split_part - разбивает строку на подстроки по разделителю и возвращает подстроку с заданным номером;
-- upper - приводит текстовое значение к верхнему регистру;
-- left - возвращает указанное число символов символьного выражения слева;
SELECT name,
       upper(split_part(name, ' ', 1)) as first_word, -- выводим только первое слово в верхнем регистре;
       price
FROM   products
ORDER BY name asc;

--8.
SELECT name,
       price,
       cast(price as varchar) as price_char -- выполняем преобразование числа в текст; column::varchar;
FROM   products
ORDER BY name

--9.
SELECT concat('Заказ № ', order_id, ' создан ', date(creation_time)) as order_info -- соединяем значения из разных столбцов в одну строку;
FROM   orders 
LIMIT 200;

--10.
SELECT courier_id,
       date_part('year', birth_date) as birth_year -- извлекаем год рождения из даты; (year, month, day, hour, minute);
FROM   couriers
ORDER BY birth_year desc, courier_id asc;

--11.
-- coalesce - возвращает первое не NULL значение из списка поданных ей на вход аргументов;
SELECT courier_id,
       coalesce(cast(date_part('year', birth_date) as varchar), 'unknown') as birth_year 
-- вместо null возвращаем 'unknown' — значение типа varchar -> извлечённый из даты год нужно привести к этому типу;
FROM   couriers
ORDER BY birth_year desc, courier_id;

--12.
SELECT product_id,
       name,
       price as old_price,
       (price+price*5/100) as new_price -- увеличесние цены на 5%;
FROM   products
ORDER BY new_price desc, product_id;

--13.
SELECT name,
       product_id,
       price as old_price,
       round((price+price/100*5), 1) as new_price -- ROUND - округления чисел с плавающей точкой;
FROM   products
ORDER BY new_price desc, product_id;

--14.
SELECT name,
       product_id,
       price as old_price,
       case when name = 'икра' and
                 price = '800' then price -- не повышаем цену на икру, которая стоит 800 рублей;
            when price > 100 then price+price/100*5 -- повышвем цену только на товары, которые стоят больше 100;
            else price -- цену остальных товаров оставляем без измеений;
            end as new_price 
FROM   products
ORDER BY new_price desc, product_id;

--15.
SELECT name,
       product_id,
       price,
       round(price/120*20, 2) as tax, -- вычисляем НДС каждого товара в таблице products;
       round(price-price/120*20, 2) as price_before_tax -- рассчитываем цену без учёта НДС;
FROM   products
ORDER BY price_before_tax desc, product_id

