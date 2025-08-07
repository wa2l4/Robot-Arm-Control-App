<?php
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "robotf_arm");
if ($conn->connect_error) {
  echo json_encode(["success" => false, "error" => "Connection failed: " . $conn->connect_error]);
  exit;
}

if (!isset($_POST['motor1'], $_POST['motor2'], $_POST['motor3'], $_POST['motor4'])) {
  echo json_encode(["success" => false, "error" => "Missing motor data"]);
  exit;
}

$m1 = intval($_POST['motor1']);
$m2 = intval($_POST['motor2']);
$m3 = intval($_POST['motor3']);
$m4 = intval($_POST['motor4']);

$stmt = $conn->prepare("INSERT INTO poses (motor1, motor2, motor3, motor4) VALUES (?, ?, ?, ?)");
$stmt->bind_param("iiii", $m1, $m2, $m3, $m4);

if ($stmt->execute()) {
  echo json_encode(["success" => true]);
} else {
  echo json_encode(["success" => false, "error" => "Error saving pose"]);
}

$stmt->close();
$conn->close();
?>
