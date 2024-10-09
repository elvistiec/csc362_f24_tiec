DROP DATABASE IF EXISTS flying_carpets_gallery;
CREATE DATABASE flying_carpets_gallery;

USE flying_carpets_gallery;

-- creating tables
CREATE TABLE customers
(
    customer_id INT AUTO_INCREMENT,
    customer_name   VARCHAR(64),
    customer_address    VARCHAR(256),
    customer_phone_number   VARCHAR(15) UNIQUE,
    PRIMARY KEY (customer_id)
);

CREATE TABLE rugs
(
    rug_id  INT AUTO_INCREMENT,
    rug_description VARCHAR(256),
    rug_purchase_price  INT NOT NULL,
    rug_date_acquired   DATE,
    rug_markup  INT CHECK (rug_markup > 0),
    rug_list_price  INT NOT NULL,
    PRIMARY KEY (rug_id)
);

CREATE TABLE sales
(
    sale_id INT AUTO_INCREMENT,
    sale_date   DATE,
    sale_price  INT NOT NULL,
    sale_original_cost  INT NOT NULL,
    sale_net INT NOT NULL,
    sale_return_date    DATE,
    rug_id  INT,
    customer_id INT,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (rug_id) REFERENCES rugs(rug_id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE trials
(
    trial_id INT AUTO_INCREMENT,
    trial_start_date   DATE,
    trial_expected_return_date    DATE,
    trial_actual_return_date    DATE,
    rug_id  INT,
    customer_id INT,
    PRIMARY KEY (trial_id),
    FOREIGN KEY (rug_id) REFERENCES rugs(rug_id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE reservations
(
    reservation_id INT AUTO_INCREMENT,
    reservation_start_date   DATE,
    reservation_end_date    DATE,
    rug_id  INT,
    customer_id INT,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (rug_id) REFERENCES rugs(rug_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- filling in data
INSERT INTO customers (customer_name, customer_address, customer_phone_number)
VALUES ("Akira Ingram", "68 Country Drive, Roseville, MI 48066", "(926) 252-6716"),
("Meredith Spencer", "9044 Piper Lane, North Royalton, OH 44133", "(817) 530-5994"),
("Marco Page", "747 East Harrison Lane, Atlanta, GA 30303", "(588) 799-6535"),
("Sandra Page", "47 East Harrison Lane, Atlanta, GA 30303", "(997) 697-2666"),
("Gloria Gomez", "78 Corona Rd. Fullerton, CA 92831", "(111) 222 -3333"),
("Bria Le", "386 Silver Spear Ct, Coraopolis, PA 15108", "(222) 333-4444");

INSERT INTO rugs (rug_description, rug_purchase_price, rug_date_acquired, rug_markup, rug_list_price)
VALUES ("Turkey Ushak 1925 5x7 Wool", 625, "2017-04-06", 100, 1250),
("Iran Tabriz 1910 10x14 Silk", 28000, "2017-04-06", 75, 49000),
("India Agra 2017 Wool 8x10", 1200, "2017-06-15", 100, 2400),
("India Agra 2017 Wool 4x6", 450, "2017-06-15", 120, 990);

INSERT INTO sales (customer_id, rug_id, sale_date, sale_price, sale_original_cost, sale_net, sale_return_date)
VALUES (5, 1, "2017-12-14", 990, 625, 365, NULL),
(6, 3, "2017-12-24", 2400, 1200, 1200, NULL),
(2, 2, "2017-12-24", 40000, 28000, 12000, "2017-12-26");

INSERT INTO trials (customer_id, rug_id, trial_start_date, trial_expected_return_date, trial_actual_return_date)
VALUES (1, 1, "2024-09-01", "2024-09-15", NULL);

INSERT INTO reservations (customer_id, rug_id, reservation_start_date, reservation_end_date)
VALUES (3, 2, "2024-09-01", "2024-09-15");

