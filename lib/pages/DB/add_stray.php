<?php
include 'db_connect.php';

$images = $_POST['images'];
$date = $_POST['date'];
$gender = $_POST['gender'];
$size = $_POST['size'];
$breed = $_POST['breed'];
$color = $_POST['color'];
$actionTaken = $_POST['actionTaken'];
$condition = $_POST['condition'];
$details = $_POST['details'];
$locationLat = $_POST['locationLat'];
$locationLng = $_POST['locationLng'];
$isRescued = $_POST['isRescued'];
$reported = $_POST['reported'];
$postedBy = $_POST['postedBy'];

$sql = "INSERT INTO stray (images, date, gender, size, breed, color, actionTaken, `condition`, details, locationLat, locationLng, isRescued, reported, postedBy) VALUES ('$images', '$date', '$gender', '$size', '$breed', '$color', '$actionTaken', '$condition', '$details', '$locationLat', '$locationLng', '$isRescued', '$reported', '$postedBy')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "New record created successfully"]);
} else {
    echo json_encode(["error" => $conn->error]);
}

$conn->close();
?>
