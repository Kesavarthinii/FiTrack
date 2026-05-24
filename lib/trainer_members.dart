import 'package:flutter/material.dart';
import 'api_service.dart';
import 'trainer_member_goal.dart';
import 'trainer_member_attendance.dart';
import 'trainer_member_diet.dart';

class TrainerMembers extends StatefulWidget {
  final String trainerId;
  const TrainerMembers({Key? key, required this.trainerId}) : super(key: key);

  @override
  State<TrainerMembers> createState() => _TrainerMembersState();
}

class _TrainerMembersState extends State<TrainerMembers> {
  bool loading = true;
  List<Map<String, dynamic>> members = [];
  String message = "";

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  Future<void> loadMembers() async {
    setState(() {
      loading = true;
      message = "";
    });

    final res = await ApiService.getAssignedMembers(widget.trainerId);

    if (res["status"] == "success") {
      members = List<Map<String, dynamic>>.from(res["members"]);
      if (members.isEmpty) message = "No members assigned.";
    } else {
      message = res["message"] ?? "Failed to load members";
    }

    setState(() => loading = false);
  }

  void openMemberOptions(String id, String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$name ($id)",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 25),

              buildOption(Icons.flag, "View Goal", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainerMemberGoal(memberId: id),
                  ),
                );
              }),

              buildOption(Icons.timer, "View Attendance", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TrainerMemberAttendance(memberId: id),
                  ),
                );
              }),

              buildOption(Icons.restaurant, "Give Diet Plan", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainerMemberDiet(
                      memberId: id,
                      trainerId: widget.trainerId,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildOption(IconData icon, String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ C2 Premium Gradient
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
              // ⭐ Header A
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Assigned Members",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: loadMembers,
                      icon: const Icon(Icons.refresh,
                          color: Colors.white),
                    )
                  ],
                ),
              ),

              Expanded(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent))
                    : members.isEmpty
                        ? Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: members.length,
                            itemBuilder: (_, i) {
                              final m = members[i];
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withOpacity(0.06),
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  border: Border.all(
                                      color: Colors.white
                                          .withOpacity(0.12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent
                                          .withOpacity(0.25),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    m["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    m["member_id"],
                                    style: const TextStyle(
                                        color: Colors.white70),
                                  ),
                                  trailing: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white70),
                                  onTap: () => openMemberOptions(
                                      m["member_id"], m["name"]),
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
