// lib/trainer_member_diet.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class TrainerMemberDiet extends StatefulWidget {
  final String memberId;
  final String trainerId;

  const TrainerMemberDiet({
    Key? key,
    required this.memberId,
    required this.trainerId,
  }) : super(key: key);

  @override
  State<TrainerMemberDiet> createState() => _TrainerMemberDietState();
}

class _TrainerMemberDietState extends State<TrainerMemberDiet> {
  bool loading = true;
  bool isEditing = false;

  Map<String, TextEditingController> fields = {};
  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  @override
  void initState() {
    super.initState();
    for (var d in days) {
      fields[d] = TextEditingController();
    }
    loadDiet();
  }

  Future<void> loadDiet() async {
    final res = await ApiService.getDiet(widget.memberId);

    if (res["status"] == "success") {
      final diet = res["diet"];
      for (var d in days) {
        fields[d]!.text = diet[d] ?? "";
      }
    }

    loading = false;
    setState(() {});
  }

  Future<void> saveDiet() async {
    Map<String, String> data = {};
    for (var d in days) {
      data[d] = fields[d]!.text;
    }

    final res = await ApiService.saveDietPlan(
      widget.memberId,
      widget.trainerId,
      data,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"])));

    if (res["status"] == "success") {
      setState(() => isEditing = false);
    }
  }

  Future<void> deleteDiet() async {
    final res = await ApiService.deleteDiet(widget.memberId);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"])));

    if (res["status"] == "success") {
      for (var d in days) fields[d]!.clear();
      setState(() => isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ Gradient C2
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
              // ⭐ Header A (back, title, edit/delete)
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

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Diet Plan (${widget.memberId})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    if (!loading && !isEditing)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => setState(() => isEditing = true),
                      ),

                    if (!loading && !isEditing)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: deleteDiet,
                      ),
                  ],
                ),
              ),

              Expanded(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            ...days.map((d) => buildDietField(d)),

                            const SizedBox(height: 25),

                            if (isEditing)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: saveDiet,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save Diet Plan",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Neon Glass TextField
  Widget buildDietField(String day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: fields[day],
        enabled: isEditing,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: day.toUpperCase(),
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
    );
  }
}
