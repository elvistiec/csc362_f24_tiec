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

?>
<!DOCTYPE html>
<head>
    <title>Place an Order</title>
</head>
<body>

<h1>Welcome to Alice's <code>Robotic</code> Restaurant</h1>
<p>You can <code>grep</code> anything you want from Alice's restaurant.</p>

<form action="order_confirm.php" method="POST">
    <h2>Menu</h2>
    <table>
        <thead>
            <tr>
                <th>Dish</th>
                <th>Price</th>
                <th>Quantity</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $menu_query = "SELECT dish_id, dish_name, dish_price_dollars FROM dishes";
            $menu_res = $conn->query($menu_query);
            while ($row = $menu_res->fetch_assoc()) {
                echo "<tr>";
                echo "<td>{$row['dish_name']}</td>";
                echo "<td>\${$row['dish_price_dollars']}</td>";
                echo "<td><input type='number' name='quantity[{$row['dish_id']}]' min='0' value='0'></td>";
                echo "</tr>";
            }
            ?>
        </tbody>
    </table>

    <h2>Customer Details</h2>
    <table>
        <tbody>
            <tr>
                <td style="text-align: right">Name:</td>
                <td><input type="text" name="cust_name" required/></td>
            </tr>
            <tr>
                <td style="text-align: right">Latitude:</td>
                <td><input type="text" name="cust_lat" pattern="[0-9]+(\.[0-9])?" title="Enter a valid decimal number" required/></td>
            </tr>
            <tr>
                <td style="text-align: right">Longitude:</td>
                <td><input type="text" name="cust_lon" pattern="[0-9]+(\.[0-9])?" title="Enter a valid decimal number" required/></td>
            </tr>
        </tbody>
    </table>
    
    <input type="submit" value="Place Order"/>
</form>

<h2>Cancel an Order</h2>
<form action="order_delete.php" method="POST">
    <table>
        <tbody>
            <tr>
                <td style="text-align: right">Order ID:</td>
                <td><input type="text" name="order_id" required/></td>
            </tr>
        </tbody>
    </table>
    <input type="submit" value="Delete Order"/>
</form>

<h2>Pending Orders</h2>
<?php
    $orders_query = "
        SELECT 
            o.order_id AS OrderID,
            c.customer_name AS Name,
            GROUP_CONCAT(CONCAT(do.dish_ordered_quantity, ' x ', d.dish_name) SEPARATOR ', ') AS Description,
            SUM(do.dish_ordered_quantity * d.dish_price_dollars) AS Total
        FROM 
            orders o
        LEFT JOIN 
            customers c ON o.customer_id = c.customer_id
        LEFT JOIN 
            dishes_ordered do ON o.order_id = do.order_id
        LEFT JOIN 
            dishes d ON do.dish_id = d.dish_id
        GROUP BY 
            o.order_id, c.customer_name
        ORDER BY 
            o.order_id;
    ";
    
    if (!$orders_res = $conn->query($orders_query)) {
        echo "<i>Failed to load orders!</i>\n";
        exit();
    }

    // Render the orders table.
    if ($orders_res->num_rows > 0) {
        echo '<table border="1">';
        echo '<tr><th>OrderID</th><th>Name</th><th>Description</th><th>Total</th></tr>';
        while ($row = $orders_res->fetch_assoc()) {
            echo '<tr>';
            echo '<td>' . htmlspecialchars($row['OrderID']) . '</td>';
            echo '<td>' . htmlspecialchars($row['Name'] ?? '') . '</td>';
            echo '<td>' . htmlspecialchars($row['Description'] ?? '') . '</td>';
            echo '<td>' . number_format($row['Total'], 2) . '</td>';
            echo '</tr>';
        }
        echo '</table>';
    } else {
        echo "<p>No pending orders found.</p>";
    }
?>
</body>
</html>
