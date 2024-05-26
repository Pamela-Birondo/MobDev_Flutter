<?php
include 'db_connect.php';

$sql = "SELECT * FROM stray";
$result = $conn->query($sql);

$strays = array();
while ($row = $result->fetch_assoc()) {
    $strays[] = $row;
}

echo json_encode($strays);

$conn->close();
?>
