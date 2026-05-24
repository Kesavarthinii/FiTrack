import 'package:flutter/material.dart';
import 'api_service.dart';

class AssignSubscription extends StatefulWidget {
  const AssignSubscription({Key? key}) : super(key: key);

  @override
  State<AssignSubscription> createState() => _AssignSubscriptionState();
}

class _AssignSubscriptionState extends State<AssignSubscription> {
  String? selectedMemberId;
  String? selectedPackage;
  bool loading = false;

  List<Map<String, dynamic>> members = [];
  final List<String> packages = ["Monthly", "Quarterly", "Yearly"];

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  void loadMembers() async {
    final res = await ApiService.getAllMembers();

    if (res["status"] == "success") {
      final list = res["members"] as List;
      members = list
          .map((e) => {"id": e["member_id"], "name": e["name"]})
          .toList();
      setState(() {});
    }
  }

  void submit() async {
    if (selectedMemberId == null || selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select member and package")),
      );
      return;
    }

    setState(() => loading = true);
    final res =
        await ApiService.assignSubscription(selectedMemberId!, selectedPackage!);
    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"])));

    if (res["status"] == "success") {
      selectedMemberId = null;
      selectedPackage = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ BACKGROUND FIX
      appBar: AppBar(
        title: const Text("Assign Subscription"),
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

            // PACKAGE DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedPackage,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Package",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              items: packages
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Text(p,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedPackage = v),
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
                        "Assign Subscription",
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
