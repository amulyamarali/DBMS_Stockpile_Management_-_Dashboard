USE dbms_project;

-- TRIGGER 1 
 DELIMITER $$
                        CREATE TRIGGER for_viz
                        AFTER INSERT ON invoice
                        FOR EACH ROW
                        BEGIN
                        DECLARE old_sold INT; 
                        DECLARE quant_ord INT;
                        SELECT no_items INTO quant_ord
                        FROM invoice
                        WHERE prod_id = NEW.prod_id AND invoice_id = NEW.invoice_id;
                        SELECT sold INTO old_sold
                        FROM supply_chain
                        WHERE prod_id = NEW.prod_id;
                        UPDATE supply_chain
                        SET sold = quant_ord + old_sold
                        WHERE prod_id = NEW.prod_id;
                        END;
                        $$
                        DELIMITER ; 