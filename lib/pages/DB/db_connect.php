<?php
$servername = "localhost";
$username = "id22190224_petrescuer";
$password = "Pamela818274?";
$dbname = "id22190224_my_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
