import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ServoControllerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ServoControllerPage extends StatefulWidget {
  const ServoControllerPage({super.key});

  @override
  State<ServoControllerPage> createState() => _ServoControllerPageState();
}

class _ServoControllerPageState extends State<ServoControllerPage> {
  double motor1 = 90;
  double motor2 = 90;
  double motor3 = 90;
  double motor4 = 90;

  List<Map<String, dynamic>> savedPoses = [];

  final String baseUrl = 'http://192.168.100.196/robotf_arm';

  @override
  void initState() {
    super.initState();
    fetchPoses();
  }

  Future<void> fetchPoses() async {
    final url = Uri.parse('$baseUrl/get_poses.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['poses'] != null) {
          setState(() {
            savedPoses = List<Map<String, dynamic>>.from(data['poses'] as List);
          });
        } else {
          print('Error fetching poses: ${data['error'] ?? 'Unknown error'}');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception fetching poses: $e');
    }
  }

  Future<void> savePose() async {
    final url = Uri.parse('$baseUrl/save_pose.php');
    try {
      final response = await http.post(
        url,
        body: {
          'motor1': motor1.toInt().toString(),
          'motor2': motor2.toInt().toString(),
          'motor3': motor3.toInt().toString(),
          'motor4': motor4.toInt().toString(),
        },
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        fetchPoses();
      } else {
        print('Error saving pose: ${data['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Exception saving pose: $e');
    }
  }

  Future<void> runPose(Map<String, dynamic> pose) async {
    setState(() {
      motor1 = double.tryParse(pose['motor1'].toString()) ?? 90;
      motor2 = double.tryParse(pose['motor2'].toString()) ?? 90;
      motor3 = double.tryParse(pose['motor3'].toString()) ?? 90;
      motor4 = double.tryParse(pose['motor4'].toString()) ?? 90;
    });

    final url = Uri.parse('$baseUrl/run_pose.php');
    try {
      await http.post(
        url,
        body: {
          'motor1': pose['motor1'].toString(),
          'motor2': pose['motor2'].toString(),
          'motor3': pose['motor3'].toString(),
          'motor4': pose['motor4'].toString(),
        },
      );
    } catch (e) {
      print('Error running pose: $e');
    }
  }

  Future<void> deletePose(String id) async {
    final url = Uri.parse('$baseUrl/delete_pose.php');
    try {
      final response = await http.post(url, body: {'id': id});
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        fetchPoses();
      } else {
        print('Error deleting pose: ${data['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Exception deleting pose: $e');
    }
  }

  void resetMotors() {
    setState(() {
      motor1 = 90;
      motor2 = 90;
      motor3 = 90;
      motor4 = 90;
    });
  }

  Widget buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          min: 0,
          max: 180,
          divisions: 180,
          label: value.toInt().toString(),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildPoseItem(Map<String, dynamic> pose) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text('Pose ${pose['id']}'),
        subtitle: Text(
          'M1: ${pose['motor1']}°, M2: ${pose['motor2']}°, M3: ${pose['motor3']}°, M4: ${pose['motor4']}°',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => runPose(pose),
              tooltip: 'Load',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deletePose(pose['id'].toString()),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Arm Controller'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildSlider(
              "Motor 1",
              motor1,
              (val) => setState(() => motor1 = val),
            ),
            buildSlider(
              "Motor 2",
              motor2,
              (val) => setState(() => motor2 = val),
            ),
            buildSlider(
              "Motor 3",
              motor3,
              (val) => setState(() => motor3 = val),
            ),
            buildSlider(
              "Motor 4",
              motor4,
              (val) => setState(() => motor4 = val),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetMotors,
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: savePose,
                  child: const Text("Save Pose"),
                ),
                ElevatedButton(
                  onPressed: () => runPose({
                    'motor1': motor1.toInt(),
                    'motor2': motor2.toInt(),
                    'motor3': motor3.toInt(),
                    'motor4': motor4.toInt(),
                  }),
                  child: const Text("Run"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Saved Poses:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...savedPoses.map(buildPoseItem).toList(),
          ],
        ),
      ),
    );
  }
}
