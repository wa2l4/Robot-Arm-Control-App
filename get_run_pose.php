<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "robotf_arm";

$conn = new mysqli($host, $user, $password, $dbname);
if ($conn->connect_error) {
    die(json_encode(["success" => false, "error" => "Connection failed"]));
}

$sql = "SELECT id, motor1, motor2, motor3, motor4 FROM poses";
$result = $conn->query($sql);

$poses = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $poses[] = $row;
    }
    echo json_encode(["success" => true, "data" => $poses]);
} else {
    echo json_encode(["success" => true, "data" => []]);
}

$conn->close();
?>
