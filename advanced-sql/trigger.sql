
-- 1.

CREATE TRIGGER calc_client_balance AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    UPDATE users SET balance = get_client_balance(OLD.user_id)
    WHERE id = NEW.user_id;
END;

-- 2.

CREATE TRIGGER calc_client_balance_after_insert AFTER INSERT ON accounts
FOR EACH ROW
BEGIN
    UPDATE users SET balance = get_client_balance(NEW.user_id)
    WHERE id = NEW.user_id;
END;

-- 3.

CREATE TRIGGER clear_names BEFORE INSERT ON users
FOR EACH ROW
BEGIN
   SET 
       NEW.first_name = TRIM(NEW.first_name),
       NEW.last_name = TRIM(NEW.last_name);
END;

-- 4.

CREATE TRIGGER clear_data BEFORE INSERT ON users
FOR EACH ROW
BEGIN
   SET 
       NEW.first_name = TRIM(NEW.first_name),
       NEW.last_name = TRIM(NEW.last_name),
       NEW.email = TRIM(LOWER(NEW.email));
END;

