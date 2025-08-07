# Robot Arm Control 

## Project Overview

This project consists of a Flutter application to control a robot arm using servo motors. It includes all necessary libraries and permissions for the app, along with the backend PHP scripts and database setup.

---

## Features

- Flutter app with sliders to control 4 servo motors.
- Save, load, and run saved motor poses.
- Reset motor positions.
- Backend PHP scripts to handle pose storage and status update.

---

## Included Files

- `main.dart` — Flutter app source code.
- `pubspec.yaml` — Flutter dependencies.
- `AndroidManifest.xml` — Permissions including USB host access.
- `get_run_pose.php` — PHP script to retrieve saved poses from the database.
- `update_status.php` — PHP script to reset the pose status in the database.
- Other PHP scripts to save and delete poses.

---

## Database Setup

Create a MySQL database (e.g., `robotf_arm`) and a table `poses` with the following structure:

| Column  | Type         | Description                 |
|---------|--------------|-----------------------------|
| id      | INT, PK, AI  | Primary key, auto-increment |
| motor1  | INT          | Position for motor 1        |
| motor2  | INT          | Position for motor 2        |
| motor3  | INT          | Position for motor 3        |
| motor4  | INT          | Position for motor 4        |
| status  | INT          | Status flag (e.g., 0 or 1)  |

---

## How to Run

1. Set up a PHP-enabled web server (e.g., XAMPP) and import the database.
2. Place PHP scripts in the web server directory.
3. Update the server IP address in the Flutter app source (`main.dart`).
4. Run `flutter pub get` to fetch dependencies.
5. Build and run the Flutter app on an Android device with USB support.

---

## Permissions

The app requires the following Android permission in `AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.usb.host" />
