// lib/trainer_member_attendance.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class TrainerMemberAttendance extends StatefulWidget {
  final String memberId;

  const TrainerMemberAttendance({Key? key, required this.memberId})
      : super(key: key);

  @override
  State<TrainerMemberAttendance> createState() =>
      _TrainerMemberAttendanceState();
}

class _TrainerMemberAttendanceState extends State<TrainerMemberAttendance> {
  bool loading = true;
  List records = [];
  String message = "";

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    setState(() => loading = true);

    final res = await ApiService.trainerViewAttendance(widget.memberId);

    if (res["status"] == "success") {
      records = res["records"];
      if (records.isEmpty) message = "No attendance found.";
    } else {
      message = res["message"] ?? "Failed to load attendance.";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 Premium Gradient Theme C2
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF151515), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // 🔥 Header A (Back arrow + centered title)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Attendance (${widget.memberId})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 🔥 Attendance List
              Expanded(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent),
                      )
                    : records.isEmpty
                        ? Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: records.length,
                            itemBuilder: (_, i) {
                              final r = records[i];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.3),
                                      blurRadius: 25,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "📅 ${r['date']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    _info("Check-In", r['checkin']),
                                    _info("Check-Out", r['checkout']),
                                    _info("Duration", "${r['duration']} mins"),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$title: $value",
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      ),
    );
  }
}
