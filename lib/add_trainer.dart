import 'package:flutter/material.dart';
import 'api_service.dart';

class AddTrainer extends StatefulWidget {
  const AddTrainer({Key? key}) : super(key: key);

  @override
  State<AddTrainer> createState() => _AddTrainerState();
}

class _AddTrainerState extends State<AddTrainer> {
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  bool loading = false;

  void submit() async {
    final id = idCtrl.text.trim();
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (id.isEmpty || name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);
    final res = await ApiService.addTrainer(id, name, phone);
    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "No response")));

    if (res["status"] == "success") {
      idCtrl.clear();
      nameCtrl.clear();
      phoneCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ ONLY CHANGE
      appBar: AppBar(
        title: const Text("Add Trainer"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: idCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Trainer ID",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 30),

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
                    : const Text("Add Trainer"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
