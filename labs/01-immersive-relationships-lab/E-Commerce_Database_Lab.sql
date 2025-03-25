-- 1. Create the Database Tables
-- Address Table:
CREATE TABLE address (
address_id SERIAL PRIMARY KEY,
street_address VARCHAR(255) NOT NULL,
zip_code VARCHAR(20) NOT NULL,
city VARCHAR(100) NOT NULL,
country VARCHAR(100) NOT NULL
);

-- User Table:
CREATE TABLE users (
user_id SERIAL PRIMARY KEY,
username VARCHAR(20) NOT NULL UNIQUE CHECK (LENGTH(username) BETWEEN 6 AND 20),
password VARCHAR(255) NOT NULL CHECK (LENGTH(password) >= 6),
email VARCHAR(255) NOT NULL UNIQUE,
address_id INT REFERENCES address (address_id) UNIQUE
);

-- Category Table:
CREATE TABLE category (
category_id SERIAL PRIMARY KEY,
category_name VARCHAR(255) NOT NULL UNIQUE
);

-- Product Table:
CREATE TABLE product (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(255) NOT NULL,
price DECIMAL(10,2) NOT NULL CHECK (price > 0),
quantity INT NOT NULL CHECK (quantity >= 0),
creator_id INT REFERENCES users(user_id),
category_id INT REFERENCES category(category_id)
);

-- 3. Sample Data
-- Inserting sample addresses
INSERT INTO address (street_address, zip_code, city, country) 
VALUES 
    ('123 Elm St', '12345', 'New York', 'USA'),
    ('456 Oak St', '67890', 'Los Angeles', 'USA');

-- Inserting sample users
INSERT INTO users (username, password, email, address_id) 
VALUES 
    ('john_doe', 'password123', 'john@example.com', 1),
    ('jane_smith', 'securepass456', 'jane@example.com', 2);

-- Inserting sample categories
INSERT INTO category (category_name) 
VALUES 
    ('Electronics'),
    ('Fashion'),
    ('Home Appliances');

-- Inserting sample products
INSERT INTO product (product_name, price, quantity, creator_id, category_id) 
VALUES 
    ('Smartphone', 599.99, 100, 1, 1),
    ('Laptop', 799.99, 50, 1, 1),
    ('T-shirt', 19.99, 200, 2, 2),
    ('Washing Machine', 499.99, 30, 2, 3);


-- 4. Queries

-- Query the products created by a user with id = 1:
SELECT * 
FROM product
INNER JOIN users ON users.user_id = product.creator_id
WHERE product.creator_id = 1;


-- Query all products in a specific category:
SELECT product.*, category.category_name
FROM product
INNER JOIN category ON category.category_id = product.category_id
WHERE category.category_name = 'Electronics';

-- Query all products with stock lower than 50:
SELECT * 
FROM product
WHERE quantity < 50;

-- Query all products with a price greater than $100:
SELECT *
FROM product
WHERE price > 100;

-- 5. Bonus: Additional Queries

--Find the category with the highest number of products
SELECT product.category_id, category.category_name, count(product.category_id) AS number_of_products
FROM product
INNER JOIN category ON category.category_id = product.category_id
GROUP BY product.category_id, category.category_name
ORDER BY number_of_products DESC
LIMIT 1;

-- Find users who do not have any products listed:
SELECT users.*
FROM users
LEFT JOIN product ON product.creator_id = users.user_id
WHERE product.creator_id IS NULL;
