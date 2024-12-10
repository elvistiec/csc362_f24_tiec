<?php
// Show all errors
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$dbhost = 'localhost';
$dbuser = 'elvis';
$dbpass = 'cheddar';

$conn = new mysqli($dbhost, $dbuser, $dbpass, 'robo_rest');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $order_id = intval($_POST['order_id']); // Ensure order_id is an integer

    // Delete from `dishes_ordered` first to maintain foreign key integrity
    $delete_dishes_query = "DELETE FROM dishes_ordered WHERE order_id = ?";
    $stmt = $conn->prepare($delete_dishes_query);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();

    // Now delete from `orders`
    $delete_order_query = "DELETE FROM orders WHERE order_id = ?";
    $stmt = $conn->prepare($delete_order_query);
    $stmt->bind_param("i", $order_id);
    $stmt->execute();

    // Redirect or confirm deletion
    echo "Order {$order_id} has been successfully deleted!";
}
?>

<a href="robo_rest_page.php">Back to Home</a>
