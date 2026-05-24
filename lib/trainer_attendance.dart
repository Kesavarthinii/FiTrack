// lib/trainer_attendance.dart
import 'package:flutter/material.dart';
import 'trainer_members.dart';

class TrainerAttendance extends StatelessWidget {
  final String trainerId;
  const TrainerAttendance({Key? key, required this.trainerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Member Attendance ($trainerId)"), backgroundColor: Colors.red),
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TrainerMembers(trainerId: trainerId)));
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Open Assigned Members to View Attendance"),
        ),
      ),
    );
  }
}
