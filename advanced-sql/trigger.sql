
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



