<?php
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "robotf_arm");
if ($conn->connect_error) {
    echo json_encode([
        "success" => false,
        "error" => "Connection failed: " . $conn->connect_error,
    ]);
    exit;
}

$result = $conn->query("SELECT * FROM poses ORDER BY id DESC");
$poses = [];

while ($row = $result->fetch_assoc()) {
    $poses[] = $row;
}

echo json_encode([
    "success" => true,
    "poses" => $poses
]);

$conn->close();
?>
