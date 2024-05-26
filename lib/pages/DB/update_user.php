<?php
include 'db_connect.php';

$id = $_POST['id'];
$name = $_POST['name'];
$username = $_POST['username'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = $_POST['password'];
$profileImage = $_POST['profileImage'];
$address = $_POST['address'];

$sql = "UPDATE user SET name='$name', username='$username', email='$email', phone='$phone', password='$password', profileImage='$profileImage', address='$address' WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "Record updated successfully"]);
} else {
    echo json_encode(["error" => $conn->error]);
}

$conn->close();
?>