<?php
    // Show ALL PHP's errors.
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    // Show all errors from the MySQLi Extension.
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);  
?>
<!DOCTYPE html>
<html>
<head>
<title>Table Details View</title>
</head>
<body>
    <h1>Tables in the <u style="font-family:monospace"><?php echo $_GET['dbname']; ?></u> Database</h1>
    <?php
        $dbname = $_GET["dbname"];
        if (!$conn = new mysqli('localhost','elvis','cheddar',$dbname)) {
            echo "Could not connect.<br>";
            echo "Error Num: $conn->connect_errno <br>";
            echo "Error Msg: $conn->connect_error <br>";
            exit;
        }
        $query = "SHOW TABLES";
        $stmt = $conn->prepare($query);
        if (!$stmt) {
            echo "Couldn't prepare statement!";
            echo exit;
        }
        $stmt->execute();
        $result = $stmt->get_result();
        $conn->close();

        // Make sure our query didn't fail.
        if (!$result) {
        echo "Query failed!" . "<br>";
        echo "Unable to execute query: " . $query;
        exit;
        }
    ?>
    <h3>Tables:</h3>
    <ul>        
    <?php
        while($rec = $result->fetch_array(MYSQLI_BOTH)){
        echo "<li>" . $rec[0] . "</li>";
        }        
    ?>
    </ul>
</body>
</html>