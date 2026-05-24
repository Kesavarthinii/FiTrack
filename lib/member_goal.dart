import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberGoal extends StatefulWidget {
  final String memberId;
  const MemberGoal({Key? key, required this.memberId}) : super(key: key);

  @override
  State<MemberGoal> createState() => _MemberGoalState();
}

class _MemberGoalState extends State<MemberGoal> {
  bool loading = true;

  String? selectedGoal;
  TextEditingController noteCtrl = TextEditingController();

  String recommendedCalories = "";
  String recommendedDiet = "";
  String intensity = "";

  final goals = [
    "Weight Loss",
    "Weight Gain",
    "Muscle Building",
    "Cardio Improvement",
    "Strength Training",
    "Endurance Training",
    "General Fitness",
    "Others"
  ];

  @override
  void initState() {
    super.initState();
    loadGoal();
  }

  Future<void> loadGoal() async {
    final res = await ApiService.getGoal(widget.memberId);

    if (res["status"] == "success") {
      selectedGoal =
          (res["goal"]?.toString().trim().isEmpty ?? true) ? null : res["goal"];

      noteCtrl.text = res["goal_note"] ?? "";

      recommendedCalories = res["recommended_cal"].toString();
      recommendedDiet = res["recommended_diet"].toString();
      intensity = res["intensity"].toString();
    }

    setState(() => loading = false);
  }

  Future<void> saveGoal() async {
    final res = await ApiService.saveGoal(
        widget.memberId, selectedGoal ?? "", noteCtrl.text);

    if (res["status"] == "success") {
      recommendedCalories = res["recommendation"]["calories"].toString();
      recommendedDiet = res["recommendation"]["diet"].toString();
      intensity = res["recommendation"]["intensity"].toString();
    }

    setState(() {});
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
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.redAccent))
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: const Text(
                                "My Goal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ⭐ Dropdown (modern rounded glass look)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: DropdownButtonFormField(
                          value: selectedGoal,
                          dropdownColor: const Color(0xFF1A1A1A),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: "Select Goal",
                            labelStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          items: goals
                              .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g,
                                      style:
                                          const TextStyle(color: Colors.white))))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedGoal = v.toString()),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ⭐ Goal Note Input
                      TextField(
                        controller: noteCtrl,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Goal Note",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.06),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1.2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ⭐ Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveGoal,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            "Save Goal",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      if (recommendedCalories.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recommended Plan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 16),

                            infoBox("Calories", recommendedCalories),
                            infoBox("Diet Type", recommendedDiet),
                            infoBox("Intensity", intensity),
                          ],
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ⭐ Card B — Premium Info Box
  Widget infoBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
