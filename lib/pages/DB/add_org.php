<?php
include 'db_connect.php';

$name = $_POST['name'];
$username = $_POST['username'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = $_POST['password'];
$profileImage = $_POST['profileImage'];
$address = $_POST['address'];

$sql = "INSERT INTO org (name, username, email, phone, password, profileImage, address) VALUES ('$name', '$username', '$email', '$phone', '$password', '$profileImage', '$address')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "New record created successfully"]);
} else {
    echo json_encode(["error" => $conn->error]);
}

$conn->close();
?>
