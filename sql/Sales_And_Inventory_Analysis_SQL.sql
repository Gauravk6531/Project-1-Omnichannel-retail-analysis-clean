CREATE TABLE retail_sales_cleaned (
    transaction_date DATE,
    sales_type VARCHAR(50),
    is_return INT,
    reason_of_return VARCHAR(255),
    supplier VARCHAR(100),
    product_no VARCHAR(50),
    product_description VARCHAR(255),
    product_division VARCHAR(100),
    product_category VARCHAR(100),
    product_subcategory VARCHAR(100),
    product_segment VARCHAR(100),
    store VARCHAR(50),
    sales_channel VARCHAR(50),
    qty_sold INT,
    sales_amount DECIMAL(10,2),
    cogs DECIMAL(10,2),
    number_of_transactions INT
);

-- Importing sales data
LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Downloads/retail_sales_cleaned.csv'
INTO TABLE retail_sales_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Importing Inventory Data 
CREATE TABLE retail_inventory_cleaned (
    start_date DATE,
    end_date DATE,
    stock_status VARCHAR(50),
    supplier VARCHAR(100),
    product_no VARCHAR(50),
    product_description VARCHAR(255),
    product_division VARCHAR(100),
    product_category VARCHAR(100),
    product_subcategory VARCHAR(100),
    product_segment VARCHAR(100),
    store VARCHAR(50),
    store_type VARCHAR(100),
    sales_channel VARCHAR(50),
    qty_on_hand INT,
    stocks_selling_amount DECIMAL(12,2),
    cost_of_stocks DECIMAL(12,2),
    stock_unit_selling_price DECIMAL(10,2),
    stock_unit_cost_price DECIMAL(10,2)
);

-- Loading inventory Data 
LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Downloads/retail_inventory_cleaned.csv'
INTO TABLE retail_inventory_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM retail_sales_cleaned LIMIT 10;

SELECT COUNT(*) AS total_rows FROM retail_sales_cleaned;

-- Query 1.1: Total Unique Entities baseline
SELECT 
    (SELECT COUNT(DISTINCT product_no) FROM retail_sales_cleaned) AS unique_sales_products,
    (SELECT COUNT(DISTINCT product_no) FROM retail_inventory_cleaned) AS unique_inventory_products,
    (SELECT COUNT(DISTINCT store) FROM retail_sales_cleaned) AS unique_sales_stores,
    (SELECT COUNT(DISTINCT store) FROM retail_inventory_cleaned) AS unique_inventory_stores;

-- Query 1.2: Check for Sales Products missing from Inventory records
SELECT COUNT(DISTINCT s.product_no) AS sales_products_missing_in_inventory
FROM retail_sales_cleaned s
LEFT JOIN retail_inventory_cleaned i ON s.product_no = i.product_no
WHERE i.product_no IS NULL;

-- Query 1.3: Look at the high-level distribution of Sales Channels vs Store Types
SELECT sales_channel, store, COUNT(*) as txn_count
FROM retail_sales_cleaned
GROUP BY sales_channel, store
LIMIT 10;
-- There are zero "ghost sales" or untracked product numbers. This means we can safely run complex relational cross-table calculations—such as joining sales to inventory on product_no and store—without losing a single dollar of transaction volume.


