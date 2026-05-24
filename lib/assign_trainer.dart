import 'package:flutter/material.dart';
import 'api_service.dart';

class AssignTrainer extends StatefulWidget {
  const AssignTrainer({Key? key}) : super(key: key);

  @override
  State<AssignTrainer> createState() => _AssignTrainerState();
}

class _AssignTrainerState extends State<AssignTrainer> {
  String? selectedMemberId;
  String? selectedTrainerId;
  bool loading = false;

  List<Map<String, dynamic>> members = [];
  List<Map<String, dynamic>> trainers = [];

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  void loadLists() async {
    final mRes = await ApiService.getAllMembers();
    final tRes = await ApiService.getAllTrainers();

    if (mRes["status"] == "success") {
      final list = mRes["members"] as List;
      members =
          list.map((e) => {"id": e["member_id"], "name": e["name"]}).toList();
    }

    if (tRes["status"] == "success") {
      final list = tRes["trainers"] as List;
      trainers =
          list.map((e) => {"id": e["trainer_id"], "name": e["name"]}).toList();
    }

    setState(() {});
  }

  void submit() async {
    if (selectedMemberId == null || selectedTrainerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select member and trainer")),
      );
      return;
    }

    setState(() => loading = true);
    final res =
        await ApiService.assignTrainer(selectedMemberId!, selectedTrainerId!);
    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "No response")));

    if (res["status"] == "success") {
      selectedMemberId = null;
      selectedTrainerId = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ BACKGROUND FIX
      appBar: AppBar(
        title: const Text("Assign Trainer"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // MEMBER DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedMemberId,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Select Member",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              items: members.map((m) {
                final display = "${m['id']} - ${m['name']}";
                return DropdownMenuItem<String>(
                  value: m['id'],
                  child: Text(display,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedMemberId = v),
            ),

            const SizedBox(height: 12),

            // TRAINER DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedTrainerId,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Select Trainer",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              items: trainers.map((t) {
                final display = "${t['id']} - ${t['name']}";
                return DropdownMenuItem<String>(
                  value: t['id'],
                  child: Text(display,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedTrainerId = v),
            ),

            const SizedBox(height: 30),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Assign Trainer",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
