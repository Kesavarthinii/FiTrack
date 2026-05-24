import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberCheckin extends StatefulWidget {
  final String memberId;

  const MemberCheckin({Key? key, required this.memberId}) : super(key: key);

  @override
  State<MemberCheckin> createState() => _MemberCheckinState();
}

class _MemberCheckinState extends State<MemberCheckin> {
  String message = "";
  List attendance = [];
  bool loading = false;

  Future<void> checkIn() async {
    final res = await ApiService.memberCheckIn(widget.memberId);
    message = res["message"];
    await loadAttendance();
  }

  Future<void> checkOut() async {
    final res = await ApiService.memberCheckOut(widget.memberId);
    message = res["message"];
    await loadAttendance();
  }

  Future<void> loadAttendance() async {
    final res = await ApiService.getMemberAttendance(widget.memberId);

    if (res["status"] == "success") {
      attendance = res["records"];
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ Premium Gradient (C2)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF151515), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ Header A with Back Arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    const Text(
                      "Check-In / Check-Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 40), // keeps title centered
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ Check-In / Check-Out Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : checkIn,
                        style: _buttonStyle(),
                        child: const Text(
                          "Check-In",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : checkOut,
                        style: _buttonStyle(),
                        child: const Text(
                          "Check-Out",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (message.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "My Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ⭐ List Section (Card B Style)
              Expanded(
                child: attendance.isEmpty
                    ? const Center(
                        child: Text(
                          "No attendance records yet",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: attendance.length,
                        itemBuilder: (_, i) {
                          final r = attendance[i];
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
                                  color: Colors.redAccent.withOpacity(0.25),
                                  blurRadius: 22,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r["date"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Check-In: ${r['checkin']}",
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                                Text(
                                  "Check-Out: ${r['checkout']}",
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

  // ⭐ Button Style (consistent across app)
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      shadowColor: Colors.redAccent.withOpacity(0.5),
    );
  }
}
