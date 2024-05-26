<?php
include 'db_connect.php';

$id = $_POST['id'];

$sql = "DELETE FROM stray WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "Record deleted successfully"]);
} else {
    echo json_encode(["error" => $conn->error]);
}

$conn->close();
?>
