import 'package:flutter/material.dart';
import 'api_service.dart';

class AdminResetPassword extends StatefulWidget {
  const AdminResetPassword({Key? key}) : super(key: key);

  @override
  State<AdminResetPassword> createState() => _AdminResetPasswordState();
}

class _AdminResetPasswordState extends State<AdminResetPassword> {
  final TextEditingController userIdCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  String selectedRole = "trainer";
  bool loading = false;

  Future<void> resetPassword() async {
    if (userIdCtrl.text.trim().isEmpty ||
        passwordCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.adminResetPassword(
        role: selectedRole,
        id: userIdCtrl.text.trim(),
        newPassword: passwordCtrl.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"] ?? "No response")),
      );

      if (res["status"] == "success") {
        userIdCtrl.clear();
        passwordCtrl.clear();
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Try again")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ ONLY BACKGROUND CHANGE
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Reset User Password"),
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ROLE
              const Text(
                "Select Role",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                ),
                items: const [
                  DropdownMenuItem(value: "trainer", child: Text("Trainer")),
                  DropdownMenuItem(value: "member", child: Text("Member")),
                ],
                onChanged: (v) => setState(() => selectedRole = v!),
              ),

              const SizedBox(height: 20),

              // ID
              Text(
                selectedRole == "trainer" ? "Trainer ID" : "Member ID",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: userIdCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter ID",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              const Text(
                "New Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                ),
              ),

              const SizedBox(height: 40),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
