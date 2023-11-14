s = [1,2,3,4]
import itertools as it 
m = [0,1,0]
x = list(it.permutations(s))
# print(x)

res = []
count = 0

for per in x:
    for i in range(3):
        if per[i]-per[i+1] >= 0:
            res.append(1)
        else:
            res.append(0)
    if res == m:
        count+=1
    res = []

print(m,count)


import time

print("Date", time.strftime("%y-%m-%d"))

trigger = "             DELIMITER $$
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
                        
        "

print(trigger)