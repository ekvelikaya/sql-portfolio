
-- 1.

CREATE PROCEDURE order_payment(order_id INT, amount INT, payment_date DATETIME)
BEGIN
    -- Обновляем статус заказа на "paid"
    UPDATE orders
    SET status = 'paid'
    WHERE id = order_id;
    -- Добавляем запись о транзакции
    INSERT INTO transactions (order_id, amount, date)
    VALUES (order_id, amount, payment_date);
END;

-- 2.

CREATE PROCEDURE active_products()
BEGIN
    SELECT id,
           name, 
           count, 
           price
    FROM products
    WHERE active = TRUE and count > 0
    ORDER BY price;
END;

-- 3.

CREATE PROCEDURE create_user(first_name VARCHAR(50), last_name VARCHAR(50), password VARCHAR(50))
BEGIN
    INSERT INTO users (first_name, last_name, password)
    VALUES (first_name, last_name, SHA(password));
END;

-- 4.

CREATE PROCEDURE create_user(first_name VARCHAR(50), last_name VARCHAR(50), password VARCHAR(50))
BEGIN
    INSERT INTO users (first_name, last_name, password)
    VALUES (TRIM(first_name), TRIM(last_name), SHA(password));
END;

-- 5.

DELIMITER $$
CREATE PROCEDURE payment(account_id INT, p_amount INT)
BEGIN
    START TRANSACTION;
    UPDATE accounts SET amount = amount - p_amount WHERE id = account_id;
    
    INSERT INTO operations (account_id, amount, direction) 
    VALUES (account_id, p_amount, 'outcome');
    
    IF p_amount < 1000 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END $$
DELIMITER ;

-- 6.

DELIMITER $$
CREATE PROCEDURE get_client_balance (client_id INT)
    BEGIN 
        SELECT SUM(balance) FROM accounts WHERE user_id = client_id;
    END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_client_balance (client_id INT) RETURNS DECIMAL
    BEGIN 
        DECLARE client_balance DECIMAL DEFAULT 0;
        SELECT SUM(balance) INTO client_balance FROM accounts WHERE user_id = client_id;
        RETURN client_balance;
    END $$
DELIMITER ;



