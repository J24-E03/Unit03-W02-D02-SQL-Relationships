-- creates

CREATE TABLE public.address (
	id BIGSERIAL PRIMARY KEY NOT NULL,
	street_address text NOT NULL,
	zip_code text NOT NULL,
	city text NOT NULL,
	country text NOT NULL
);

CREATE TABLE public."user" (
	id BIGSERIAL PRIMARY KEY NOT NULL,
	username varchar(20) NOT NULL UNIQUE CHECK (LENGTH(username) BETWEEN 6 AND 20),
	"password" varchar(255) NOT NULL,
	email text NOT NULL,
	address_id integer NOT NULL,
	CONSTRAINT username_unique UNIQUE (username),
	CONSTRAINT useremail_unique UNIQUE (email),
	CONSTRAINT user_address_fk FOREIGN KEY (id) REFERENCES public.address(id) ON delete CASCADE ON update CASCADE
);

CREATE TABLE public.category (
	id BIGSERIAL PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT categoryname_unique UNIQUE ("name")
);

CREATE TABLE public.product (
	id BIGSERIAL PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	price numeric(99, 2) NOT NULL,
	quantity integer NOT NULL,
	creator_id integer NOT NULL,
	category_id integer NOT NULL,
	CONSTRAINT product_user_fk FOREIGN KEY (creator_id) REFERENCES public."user"(id) ON delete CASCADE ON update CASCADE,
	CONSTRAINT product_category_fk FOREIGN KEY (category_id) REFERENCES public.category(id) ON delete CASCADE ON update CASCADE
);

-- inserts

INSERT INTO address (street_address, zip_code, city, country)
VALUES
    ('123 Elm St', '12345', 'New York', 'USA'),
    ('456 Oak St', '67890', 'Los Angeles', 'USA');

INSERT INTO "user" (username, password, email, address_id)
VALUES
    ('john_doe', 'password123', 'john@example.com', 1),
    ('jane_smith', 'securepass456', 'jane@example.com', 2);

INSERT INTO category (name)
VALUES
    ('Electronics'),
    ('Fashion'),
    ('Home Appliances');

INSERT INTO product (name, price, quantity, creator_id, category_id)
VALUES
    ('Smartphone', 599.99, 100, 1, 1),
    ('Laptop', 799.99, 50, 1, 1),
    ('T-shirt', 19.99, 200, 2, 2),
    ('Washing Machine', 499.99, 30, 2, 3);

-- selects

SELECT p.*, u.* FROM product p
INNER JOIN "user" u on u.id = p.creator_id
WHERE p.creator_id = 1;

SELECT p.* FROM product p
INNER JOIN category c on c.id = p.category_id
WHERE c."name" = 'Electronics';

SELECT * FROM product
WHERE quantity < 50;

SELECT * FROM product
WHERE price > 100;

SELECT c."name", COUNT(p.id) AS product_count
FROM category c
INNER JOIN product p ON p.category_id = c.id
GROUP BY c."name"
ORDER BY product_count DESC
LIMIT 1;

SELECT u.* FROM "user" u
INNER JOIN product p ON p.creator_id = u.id
GROUP BY u.id
HAVING COUNT(p.id) = 0;
