<?php
// Show all errors from the PHP interpreter.
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Show all errors from the MySQLi Extension.
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$dbhost = 'localhost';
$dbuser = 'webuser';
$dbpass = 'mewtwo';

$conn = new mysqli($dbhost, $dbuser, $dbpass, 'instrument_rentals');

if (isset($_POST['add_records'])) {
    // Handle adding records
    $insertQuery = file_get_contents("add_instruments.sql");
    if ($conn->query($insertQuery) === TRUE) {
        header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
        exit();
    } else {
        echo "Error inserting records: " . $conn->error;
    }
}

if (isset($_POST['delbtn']) && !empty($_POST['delete_ids'])) {
    // Handle deleting records
    $delete_sql = file_get_contents("delete_instrument.sql");
    $del_stmt = $conn->prepare($delete_sql);
    
    if (!$del_stmt) {
        echo "Error preparing statement: " . $conn->error;
        exit();
    }
    
    $del_stmt->bind_param('i', $id);
    foreach ($_POST['delete_ids'] as $id) {
        $id = (int)$id;
        $del_stmt->execute();
    }
    $del_stmt->close();
    
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

// Load the SQL query to select instruments and fetch the result
$sql_location = '/home/elvis/csc362_f24_tiec/html/';
$sel_tbl = file_get_contents($sql_location . 'select_instruments.sql');
$result = $conn->query($sel_tbl);

function result_to_html_table($result) {
    $qryres = $result->fetch_all();
    $n_rows = $result->num_rows;
    $n_cols = $result->field_count;
    $fields = $result->fetch_fields();
    ?>

    <form method="POST">
        <table>
            <thead>
                <tr>
                    <td><b>Delete?</b></td>
                    <?php for ($i = 0; $i < $n_cols; $i++) { ?>
                        <td><b><?php echo $fields[$i]->name; ?></b></td>
                    <?php } ?>
                </tr>
            </thead>
            <tbody>
                <?php for ($i = 0; $i < $n_rows; $i++) { ?>
                    <?php 
                    $id = $qryres[$i][0]; // Assuming instrument_id is the first column
                    $studentName = $qryres[$i][2]; // Assuming student_name is the third column
                    
                    // Check if the instrument is checked out by verifying if student_name is not empty
                    $isCheckedOut = !empty($studentName);
                    ?>
                    <tr>
                        <!-- Checkbox column, disabled if the instrument is checked out -->
                        <td>
                            <input type="checkbox" 
                                   name="delete_ids[]" 
                                   value="<?php echo $id; ?>" 
                                   <?php echo $isCheckedOut ? 'disabled="disabled"' : ''; ?> />
                        </td>
                        
                        <!-- Data columns -->
                        <?php for ($j = 0; $j < $n_cols; $j++) { ?>
                            <td><?php echo $qryres[$i][$j]; ?></td>
                        <?php } ?>
                    </tr>
                <?php } ?>
            </tbody>
        </table>
        <p><input type="submit" name="delbtn" value="Delete Selected Records" /></p>
    </form>

    <?php
}

// Call the function to display the table
result_to_html_table($result);
?>

<!-- Form to add new records -->
<form method="POST">
    <input type="submit" name="add_records" value="Add extra records" />
</form>
