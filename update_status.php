<?php
$conn = new mysqli("localhost", "root", "", "robotf_arm");

$sql = "UPDATE status SET value = 0 WHERE id = 1";

if ($conn->query($sql) === TRUE) {
  echo "Status updated.";
} else {
  echo "Error updating status.";
}

$conn->close();
?>
