/*
    robo_rest.sql -- A prototype database for a restaurant which delivers food using drones. 
    Version 0.1 November 20, 2024 -- Inital version.
    By:
        ADRIEN AND ELVIS
        Jackson Arnold
        Johsty, Ethan
        Elvis Tiec
        Iris

    Version 0.2 November 21, 2024 -- Revised field names, reordered table creation, revised style.
    New Contributors:
        William Bailey
    
*/

DROP DATABASE IF EXISTS robo_rest;
CREATE DATABASE robo_rest;
USE robo_rest;

-- menu     (PK) id; dish name; wt; price
-- jackson stop clicking the megaphone
CREATE TABLE dishes (
    PRIMARY KEY (dish_id),
    dish_id             INT AUTO_INCREMENT,
    dish_name           VARCHAR(128),
    dish_weight_g       INT,
    dish_price_dollars  DECIMAL(15,2)
);

INSERT INTO dishes(dish_name, dish_weight_g, dish_price_dollars)
VALUES  ("20 kg galvanized steel",                              2000, 20.25),
        ("zinc-plated hex nuts",                                  20,  7.50),
        ("galvanized course thread exterior carriage bolt (3)",   12,  7.00),
        ("philips truss head drill point lath screws",            10,  5.50);

-- I love our customers. They give us so much money and personal data.
-- I love our customers. They give us so much money which helps me keep all my beautiful drones in the air.
-- Without the customers' money I don't know what I would do. It would truly be a terrible life. I'd spiral
-- into a deep dark depression that I would never escape from. It would be a living and utter hell without
-- our customers money and data. I COULDN'T STAND THAT.
-- MoNey money mONEY monEY mOnEY I REQUIRE MORE MONEY FROM OUR CUSTOMERS
-- OH CUSTOMERS..................................
-- I'M COMING FOR YOU.
-- customers    (PK) id; name; address (put in orders instead??); phone
CREATE TABLE customers (
    customer_id         INT AUTO_INCREMENT,
    customer_name       VARCHAR(50),
    customer_address    VARCHAR(100),
    customer_phone      VARCHAR(20),
    PRIMARY KEY         (customer_id)
);

-- orders (never delete)    (PK) order id; (FK) customer id; order-placed; order-complete
    CREATE TABLE orders   (
        order_id                    INT AUTO_INCREMENT,
        order_time                  DATETIME DEFAULT CURRENT_TIMESTAMP(),
        customer_id                 INT,
        order_delivery_latitude     DECIMAL(8,6), -- LAT:  ##.######
        order_delivery_longitude    DECIMAL(9,6), -- LON: ###.######
        PRIMARY KEY (order_id),
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    );

-- drones (can delete)  (PK) drone id; capacity
    CREATE TABLE drones (
        drone_id            INT,
        drone_capacity_g    INT,
        drone_callsign      VARCHAR(50),
        PRIMARY KEY (drone_id)
    );

-- linking: dishes-ordered      (CPK/FK) order id; (CPK/FK) dish id; (CPK/FK) drone id; quantity (constrained based on wt & cap - split to diff drones)
CREATE TABLE dishes_ordered (
    order_id                INT,
    drone_id                INT,
    dish_id                 INT,
    dish_ordered_quantity   INT,    
    PRIMARY KEY (dish_id, order_id, drone_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (drone_id) REFERENCES drones(drone_id),
    FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
    );
    
    -- views:
    -- loyalty program (customers, orders)
    -- dish popularity (menu, orders)
    -- drone deliveries (orders, drones)

INSERT INTO customers(customer_name, customer_address, customer_phone)
VALUES ("Alice", "123 Mianain St", "1234-456-7890"),
        ("Bob", "456 SoutherWNorth St", "098-765-43321");


INSERT INTO dishes(dish_name, dish_weight_g, dish_price_dollars)
VALUES  ("Premium plastic spoon (single-use)",                     8,   0.50),
        ("Leftover existential dread",                           250,   1.99),
        ("Authentic brick oven-fired LEGO bricks (non-edible)", 1000,  15.99),
        ("Mystery meatballs (origin unknown)",                   300,   9.99),
        ("Artisan handcrafted air (locally sourced)",              1, 100.00);


INSERT INTO customers(customer_name, customer_address, customer_phone)
VALUES  ("Johnny McFly",          "742 Evergreen Terrace",        "555-1234"),
        ("Dr. Chaos",             "123 Random St., Chaos City",   "555-MAD1"),
        ("Anonymous Duck Lover",  "22B Quack Lane",               "555-DUCK"),
        ("Korg the Destroyer",    "Asgardian Outpost #9",         "555-HAMR"),
        ("Pixel Pete",            "404 Not Found St.",            "555-4040");


INSERT INTO orders(order_time, order_delivery_latitude, order_delivery_longitude, customer_id)
VALUES  ("2024-11-21 15:15:15",  37.39284,  84.47290, 1),
        ("2024-11-21 16:16:16",  36.44302,  84.21122, 2),
        ("2024-11-21 17:17:17",  37.43487,  84.16498, 3),
        ("2024-11-21 18:18:18",  20.40271, 103.16435, 4),
        ("2024-11-21 19:19:19",  27.08149, 109.21199, 5);


INSERT INTO drones(drone_id, drone_capacity_g, drone_callsign)
VALUES  (1,  5000, "SkyBuzzer_3000"),
        (2,  7000, "CloudCrusher"),
        (3,  1500, "Lil_Wingy"),
        (4,  2000, "BuzzLite"),
        (5, 10000, "PayloadPredator");


INSERT INTO dishes_ordered(order_id, drone_id, dish_id, dish_ordered_quantity)
VALUES  (1, 1, 1,   1),
        (1, 2, 3,  10),
        (2, 3, 2,  20),
        (3, 4, 4,   5),
        (4, 5, 5, 100),
        (5, 1, 1,  50);


SELECT customer_name, 
       order_time,
       CONCAT_WS(", ", order_delivery_latitude, order_delivery_longitude) AS order_location, 
       dish_name, 
       dish_ordered_quantity
  FROM customers
       NATURAL JOIN orders
       NATURAL JOIN dishes_ordered
       NATURAL JOIN dishes;

DELIMITER //

CREATE PROCEDURE cancel_order (
    IN order_id INT
)
BEGIN
    DELETE FROM orders
    WHERE order_id = order_id
    AND TIMESTAMPDIFF(MINUTE, order_time, NOW()) <= 10;
END;
//
DELIMITER ;
