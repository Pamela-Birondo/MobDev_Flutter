<?php
include 'db_connect.php';

$id = $_POST['id'];
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

$sql = "UPDATE stray SET images='$images', date='$date', gender='$gender', size='$size', breed='$breed', color='$color', actionTaken='$actionTaken', `condition`='$condition', details='$details', locationLat='$locationLat', locationLng='$locationLng', isRescued='$isRescued', reported='$reported', postedBy='$postedBy' WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "Record updated successfully"]);
} else {
    echo json_encode(["error" => $conn->error]);
}

$conn->close();
?>
