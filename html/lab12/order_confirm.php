<?php
// Show all errors from the PHP interpreter.
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Show all errors from the MySQLi Extension.
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$dbhost = 'localhost';
$dbuser = 'elvis';
$dbpass = 'cheddar';

$conn = new mysqli($dbhost, $dbuser, $dbpass, 'robo_rest');

// Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect customer and order information
    $cust_name = $_POST['cust_name'];
    $cust_address = $_POST['cust_address'] ?? "Unknown Address"; // Address field if included
    $cust_phone = $_POST['cust_phone'] ?? "Unknown Phone";
    $order_lat = $_POST['cust_lat'];
    $order_lon = $_POST['cust_lon'];
    $quantities = $_POST['quantity'];

    // Start transaction to ensure atomicity
    $conn->begin_transaction();
    try {
        // Insert customer details (or fetch existing customer_id if applicable)
        $cust_query = "INSERT INTO customers (customer_name, customer_address, customer_phone) VALUES (?, ?, ?)";
        $cust_stmt = $conn->prepare($cust_query);
        $cust_stmt->bind_param("sss", $cust_name, $cust_address, $cust_phone);
        $cust_stmt->execute();
        $customer_id = $conn->insert_id;

        // Insert new order with delivery latitude and longitude
        $order_query = "INSERT INTO orders (customer_id, order_delivery_latitude, order_delivery_longitude) VALUES (?, ?, ?)";
        $order_stmt = $conn->prepare($order_query);
        $order_stmt->bind_param("idd", $customer_id, $order_lat, $order_lon);
        $order_stmt->execute();
        $order_id = $conn->insert_id;

        // Insert ordered dishes
        $dish_order_query = "INSERT INTO dishes_ordered (order_id, drone_id, dish_id, dish_ordered_quantity) VALUES (?, 1, ?, ?)";
        $dish_order_stmt = $conn->prepare($dish_order_query);

        foreach ($quantities as $dish_id => $quantity) {
            if ($quantity > 0) { // Only insert if quantity is greater than 0
                $dish_order_stmt->bind_param("iii", $order_id, $dish_id, $quantity);
                $dish_order_stmt->execute();
            }
        }

        // Commit transaction
        $conn->commit();

        echo "<h1>Order Confirmation</h1>";
        echo "<p>Thank you, $cust_name! Your order has been placed successfully.</p>";
        echo "<p>Order ID: $order_id</p>";
        echo "<p>Delivery to latitude: $order_lat, longitude: $order_lon.</p>";
    } catch (Exception $e) {
        // Rollback on error
        $conn->rollback();
        echo "<p>Failed to place the order: " . $e->getMessage() . "</p>";
    }
}
?>

<a href="robo_rest_page.php">Back to Home</a>