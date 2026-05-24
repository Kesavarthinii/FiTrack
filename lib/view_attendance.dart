import 'package:flutter/material.dart';
import 'api_service.dart';

class ViewAttendance extends StatefulWidget {
  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  TextEditingController memberIdCtrl = TextEditingController();
  bool loading = false;
  String message = "";
  List records = [];

  Future<void> loadAttendance() async {
    if (memberIdCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Member ID")),
      );
      return;
    }

    setState(() {
      loading = true;
      message = "";
      records = [];
    });

    // 🔥 ADMIN VIEW ATTENDANCE (API CALL)
    final res =
        await ApiService.getMemberAttendance(memberIdCtrl.text.trim());

    if (res["status"] == "success") {
      records = res["records"];
      if (records.isEmpty) {
        message = "No attendance found.";
      }
    } else {
      message = res["message"] ?? "Failed to load attendance";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 FitRack Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0B0B0B), Color(0xff1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // 🔥 Custom Header (Consistent with Admin Theme)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.45),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "View Attendance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 🔥 Input + Button Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 26,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 🔹 Member ID Input
                      TextField(
                        controller: memberIdCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Member ID",
                          labelStyle:
                              const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.35)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 🔹 Load Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : loadAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 12,
                            shadowColor:
                                Colors.redAccent.withOpacity(0.6),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Load Attendance",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Message
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                ),

              const SizedBox(height: 10),

              // 🔹 Attendance List
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final r = records[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.redAccent.withOpacity(0.25),
                            blurRadius: 22,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📅 Date: ${r['date']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Check-in: ${r['checkin']}",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            "Check-out: ${r['checkout']}",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            "Duration: ${r['duration']} mins",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
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
}
