<?php
include 'db_connect.php';

$sql = "SELECT * FROM org";
$result = $conn->query($sql);

$orgs = array();
while ($row = $result->fetch_assoc()) {
    $orgs[] = $row;
}

echo json_encode($orgs);

$conn->close();
?>
