<?php
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "robotf_arm");
if ($conn->connect_error) {
    echo json_encode(["success" => false, "error" => "Connection failed"]);
    exit;
}

if (!isset($_POST['id'])) {
    echo json_encode(["success" => false, "error" => "Missing id"]);
    exit;
}

$id = intval($_POST['id']);

$stmt = $conn->prepare("DELETE FROM poses WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => "Failed to delete"]);
}

$stmt->close();
$conn->close();
?>
