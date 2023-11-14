USE dbms_project;
DROP SCHEMA dbms_project;

DROP TABLE IF EXISTS owners;
CREATE TABLE owners (
	owner_id varchar(10) PRIMARY KEY,
    owner_name char(20) NOT NULL
);

INSERT INTO owners (owner_id, owner_name)
VALUES
    ('Owner001', 'John Doe'),
    ('Owner002', 'Alice Smith'),
    ('Owner003', 'Bob Johnson'),
    ('Owner004', 'Emily Davis'),
    ('Owner005', 'Michael Brown');
    
DROP TABLE IF EXISTS storages;
CREATE TABLE storages (
	storage_id varchar(10) PRIMARY KEY,
    owner_id varchar(10) NOT NULL,
    location_id varchar(10) NOT NULL,
    storage_name char(20) NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES location(location_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert values into the "storages" table
INSERT INTO storages (storage_id, owner_id, location_id, storage_name) 
VALUES 
    ('Storage001', 'Owner001', 'Loc001', 'Storage A'),
    ('Storage002', 'Owner001', 'Loc002', 'Storage B'),
    ('Storage003', 'Owner002', 'Loc003', 'Storage X'),
    ('Storage004', 'Owner002', 'Loc004', 'Storage Y'),
    ('Storage005', 'Owner003', 'Loc005', 'Storage M'),
    ('Storage006', 'Owner005', 'Loc006', 'Storage N'),
    ('Storage007', 'Owner004', 'Loc007', 'Storage P'),
    ('Storage008', 'Owner004', 'Loc008', 'Storage Q');

DROP TABLE IF EXISTS stock;
CREATE TABLE stock (
	stock_id varchar(10) PRIMARY KEY,
	storage_id varchar(10) NOT NULL,
    storage_name char(10) NOT NULL,
    owner_id varchar(10) NOT NULL,
    location_id varchar(10) NOT NULL,
    FOREIGN KEY (storage_id) REFERENCES storages(storage_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES location(location_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert values into the "stock" table
INSERT INTO stock (stock_id, storage_id, storage_name, owner_id, location_id)
VALUES
    ('Stock001', 'Storage001', 'Storage A', 'Owner001', 'Loc001'),
    ('Stock002', 'Storage002', 'Storage B', 'Owner001', 'Loc002'),
    ('Stock003', 'Storage003', 'Storage X', 'Owner002', 'Loc003'),
    ('Stock004', 'Storage004', 'Storage Y', 'Owner002', 'Loc004'),
    ('Stock005', 'Storage005', 'Storage M', 'Owner003', 'Loc005'),
    ('Stock006', 'Storage006', 'Storage N', 'Owner003', 'Loc006'),
    ('Stock007', 'Storage007', 'Storage P', 'Owner004', 'Loc007'),
    ('Stock008', 'Storage002', 'Storage B', 'Owner001', 'Loc002'),
    ('Stock009', 'Storage005', 'Storage M', 'Owner003', 'Loc005'),
    ('Stock0010','Storage008', 'Storage Q', 'Owner004', 'Loc008');
    

DROP TABLE IF EXISTS product;
CREATE TABLE product (
	prod_id varchar(10) PRIMARY KEY,
    prod_name char(20) NOT NULL,
    prod_brand char(20) NOT NULL,
    price int NOT NULL
);

-- Insert 20 products into the "product" table
INSERT INTO product (prod_id, prod_name, prod_brand, price)
VALUES
    ('Prod001', 'Laptop', 'Dell', 800),
    ('Prod002', 'Tablet', 'Dell', 400),
    ('Prod003', 'Smartphone', 'Apple', 1000),
    ('Prod004', 'Smartwatch', 'Apple', 150),
    ('Prod005', 'Camera', 'Canon', 600),
    ('Prod006', 'Printer', 'Canon', 200),
    ('Prod007', 'Headphones', 'Sony', 50),
    ('Prod008', 'TV', 'Sony', 900),
    ('Prod009', 'Washing Machine', 'Samsung', 600),
    ('Prod010', 'Refrigerator', 'Samsung', 500),
    ('Prod011', 'Blender', 'Hamilton Beach', 40),
    ('Prod012', 'Microwave', 'Panasonic', 150),
    ('Prod013', 'Vacuum Cleaner', 'Dyson', 300),
    ('Prod014', 'Coffee Maker', 'Keurig', 70),
    ('Prod015', 'Toaster', 'Cuisinart', 25),
    ('Prod016', 'Hair Dryer', 'Conair', 20),
    ('Prod017', 'Dishwasher', 'Bosch', 500),
    ('Prod018', 'Hand Mixer', 'Hamilton Beach', 35),
    ('Prod019', 'Iron', 'Rowenta', 50),
    ('Prod020', 'Blender', 'Ninja', 60);

DROP TABLE IF EXISTS supplier_details;
CREATE TABLE supplier_details (
	supply_id varchar(10) PRIMARY KEY,
    supplier_name char(20) NOT NULL,
    company char(20) NOT NULL
);

INSERT INTO supplier_details (supply_id, supplier_name, company)
VALUES
    ('Supply001', 'Supplier A', 'Company X'),
    ('Supply002', 'Supplier B', 'Company Y'),
    ('Supply003', 'Supplier C', 'Company Z'),
    ('Supply004', 'Supplier D', 'Company W'),
    ('Supply005', 'Supplier E', 'Company V');
    
    
DROP TABLE IF EXISTS supply_chain;
CREATE TABLE supply_chain (
	supply_id varchar(10) NOT NULL,
    storage_id varchar(10) NOT NULL,
    prod_id varchar(10) NOT NULL,
    quantity int NOT NULL,
    FOREIGN KEY (supply_id) REFERENCES supplier_details(supply_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (storage_id) REFERENCES storages(storage_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES product(prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert 20 records into the "supply_chain" table with limited unique IDs
INSERT INTO supply_chain (supply_id, storage_id, prod_id, quantity)
VALUES
    ('Supply001', 'Storage001', 'Prod001', 100),
    ('Supply002', 'Storage002', 'Prod002', 50),
    ('Supply003', 'Storage003', 'Prod003', 75),
    ('Supply004', 'Storage004', 'Prod004', 60),
    ('Supply005', 'Storage005', 'Prod005', 90),
    ('Supply001', 'Storage006', 'Prod006', 40),
    ('Supply002', 'Storage007', 'Prod007', 30),
    ('Supply003', 'Storage008', 'Prod008', 80),
    ('Supply004', 'Storage001', 'Prod009', 55),
    ('Supply005', 'Storage002', 'Prod010', 70),
    ('Supply001', 'Storage003', 'Prod011', 65),
    ('Supply002', 'Storage004', 'Prod012', 85),
    ('Supply003', 'Storage005', 'Prod013', 45),
    ('Supply004', 'Storage006', 'Prod014', 95),
    ('Supply005', 'Storage007', 'Prod015', 110),
    ('Supply001', 'Storage008', 'Prod016', 25),
    ('Supply002', 'Storage001', 'Prod017', 120),
    ('Supply003', 'Storage002', 'Prod018', 35),
    ('Supply004', 'Storage003', 'Prod019', 130),
    ('Supply005', 'Storage004', 'Prod020', 75);



DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice(
	invoice_id varchar(10) PRIMARY KEY,
    order_no varchar(10) NOT NULL,
    cust_id varchar(10) NOT NULL,
    no_items int NOT NULL,
    total_price int NOT NULL,
    FOREIGN KEY (order_no) REFERENCES orders(order_no) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert 15 records into the "invoice" table with unique invoice_id and order_no
INSERT INTO invoice (invoice_id, order_no, cust_id, no_items, total_price)
VALUES
    ('Invoice001', 'Order001', 'Cust001', 5, 100),
    ('Invoice002', 'Order002', 'Cust002', 3, 50),
    ('Invoice003', 'Order003', 'Cust003', 4, 80),
    ('Invoice004', 'Order004', 'Cust004', 6, 120),
    ('Invoice005', 'Order005', 'Cust005', 2, 40),
    ('Invoice006', 'Order006', 'Cust006', 7, 140),
    ('Invoice007', 'Order007', 'Cust007', 3, 60),
    ('Invoice008', 'Order008', 'Cust008', 4, 80),
    ('Invoice009', 'Order009', 'Cust009', 5, 100),
    ('Invoice010', 'Order010', 'Cust001', 3, 60),
    ('Invoice011', 'Order011', 'Cust002', 4, 80),
    ('Invoice012', 'Order012', 'Cust003', 2, 40),
    ('Invoice013', 'Order013', 'Cust004', 6, 120),
    ('Invoice014', 'Order014', 'Cust005', 5, 100),
    ('Invoice015', 'Order015', 'Cust0010', 4, 80);


DROP TABLE IF EXISTS location;
CREATE TABLE location(
	location_id varchar(10) PRIMARY KEY,
    country char(20) NOT NULL,
    city char(20) NOT NULL,
    pin_code int NOT NULL 
);

INSERT INTO location (location_id, country, city, pin_code)
VALUES
    ('Loc001', 'USA', 'New York', 10001),
    ('Loc002', 'Canada', 'Toronto', 20001),
    ('Loc003', 'UK', 'London', 30001),
    ('Loc004', 'France', 'Paris', 40001),
    ('Loc005', 'Germany', 'Berlin', 50001),
    ('Loc006', 'Australia', 'Sydney', 60001),
    ('Loc007', 'Japan', 'Tokyo', 70001),
    ('Loc008', 'India', 'Mumbai', 80001);

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	cust_id varchar(10) PRIMARY KEY,
    cust_name char(20) NOT NULL,
    locatoin_id varchar(10) NOT NULL,
    ph_no varchar(10) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES location(location_id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO customer (cust_id, cust_name, locatoin_id, ph_no)
VALUES
    ('Cust001', 'John Doe', 'Loc001', '1234567890'),
    ('Cust002', 'Alice Smith', 'Loc002', '9876543210'),
    ('Cust003', 'Bob Johnson', 'Loc003', '5551234567'),
    ('Cust004', 'Emily Davis', 'Loc004', '9998887777'),
    ('Cust005', 'Michael Brown', 'Loc005', '4443332222'),
    ('Cust006', 'Sarah Wilson', 'Loc006', '7776665555'),
    ('Cust007', 'David Lee', 'Loc007', '1112223333'),
    ('Cust008', 'Laura Miller', 'Loc008', '3334445555'),
    ('Cust009', 'Samuel Jackson', 'Loc009', '6667778888'),
    ('Cust010', 'Olivia White', 'Loc010', '2221110000');


DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	order_no varchar(10) PRIMARY KEY,
	ord_date date NOT NULL,
    cust_id varchar(10) NOT NULL,
    cust_name char(20) NOT NULL,
    storage_id varchar(10) NOT NULL,
    invoice_id varchar(10) NOT NULL,
    location_id varchar(10) NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (storage_id) REFERENCES storages(storage_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES location(location_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert 15 records into the "orders" table with unique order_no and invoice_id, along with repeating cust_id and cust_name
INSERT INTO orders (order_no, ord_date, cust_id, cust_name, storage_id, invoice_id, location_id)
VALUES
    ('Order001', '2023-10-01', 'Cust001', 'John Doe', 'Storage001', 'Invoice001', 'Loc001'),
    ('Order002', '2023-10-02', 'Cust002', 'Alice Smith', 'Storage002', 'Invoice002', 'Loc002'),
    ('Order003', '2023-10-03', 'Cust003', 'Bob Johnson', 'Storage003', 'Invoice003', 'Loc003'),
    ('Order004', '2023-10-04', 'Cust004', 'Emily Davis', 'Storage004', 'Invoice004', 'Loc004'),
    ('Order005', '2023-10-05', 'Cust005', 'Michael Brown', 'Storage005', 'Invoice005', 'Loc005'),
    ('Order006', '2023-10-06', 'Cust001', 'John Doe', 'Storage006', 'Invoice006', 'Loc006'),
    ('Order007', '2023-10-07', 'Cust002', 'Alice Smith', 'Storage007', 'Invoice007', 'Loc007'),
    ('Order008', '2023-10-08', 'Cust003', 'Bob Johnson', 'Storage008', 'Invoice008', 'Loc008'),
    ('Order009', '2023-10-09', 'Cust004', 'Emily Davis', 'Storage001', 'Invoice009', 'Loc001'),
    ('Order010', '2023-10-10', 'Cust005', 'Michael Brown', 'Storage002', 'Invoice010', 'Loc002'),
    ('Order011', '2023-10-11', 'Cust001', 'John Doe', 'Storage003', 'Invoice011', 'Loc003'),
    ('Order012', '2023-10-12', 'Cust002', 'Alice Smith', 'Storage004', 'Invoice012', 'Loc004'),
    ('Order013', '2023-10-13', 'Cust003', 'Bob Johnson', 'Storage005', 'Invoice013', 'Loc005'),
    ('Order014', '2023-10-14', 'Cust004', 'Emily Davis', 'Storage006', 'Invoice014', 'Loc006'),
    ('Order015', '2023-10-15', 'Cust005', 'Michael Brown', 'Storage007', 'Invoice015', 'Loc007');











