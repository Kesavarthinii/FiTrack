// lib/trainer_member_goal.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class TrainerMemberGoal extends StatefulWidget {
  final String memberId;
  const TrainerMemberGoal({Key? key, required this.memberId}) : super(key: key);

  @override
  State<TrainerMemberGoal> createState() => _TrainerMemberGoalState();
}

class _TrainerMemberGoalState extends State<TrainerMemberGoal> {
  bool loading = true;

  String goal = "";
  String goalNote = "";
  String recommendedCalories = "";
  String recommendedDiet = "";
  String intensity = "";

  @override
  void initState() {
    super.initState();
    loadGoal();
  }

  Future<void> loadGoal() async {
    final res = await ApiService.getMemberGoal(widget.memberId);

    if (res["status"] == "success") {
      goal = res["goal"] ?? "";
      goalNote = res["goal_note"] ?? "";
      recommendedCalories = res["recommended_cal"].toString();
      recommendedDiet = res["recommended_diet"].toString();
      intensity = res["intensity"].toString();
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ Premium Gradient Theme (C2)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF151515), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: loading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: Colors.redAccent),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ⭐ Header A
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Goal (${widget.memberId})",
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

                      const SizedBox(height: 25),

                      buildBox("Goal", goal),
                      buildBox("Notes", goalNote),
                      const SizedBox(height: 20),
                      buildBox("Calories", recommendedCalories),
                      buildBox("Diet Type", recommendedDiet),
                      buildBox("Intensity", intensity),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}
