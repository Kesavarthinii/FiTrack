// lib/signup_page.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class SignupPage extends StatefulWidget {
  final String role; // "trainer" or "member"

  const SignupPage({Key? key, required this.role}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool loading = false;

  void doSignup() async {
    if (idCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    setState(() => loading = true);

    final res = await ApiService.register(
      role: widget.role,
      id: idCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "")));

    if (res["status"] == "success") {
      Navigator.pop(context); // Go back to login
    }
  }

  @override
  Widget build(BuildContext context) {
    final String idLabel =
        widget.role == "trainer" ? "Trainer ID" : "Member ID";

    return Scaffold(
      // 🔥 Modern Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0A0A0A), Color(0xff1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // 🔥 Header – NO back arrow
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "${widget.role.toUpperCase()} SIGNUP",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔥 Glassmorphic Form Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.25),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      TextField(
                        controller: idCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _input("Enter $idLabel"),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: _input("Phone Number"),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: passCtrl,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _input("Password"),
                      ),

                      const SizedBox(height: 30),

                      // 🔥 SIGNUP Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : doSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 10,
                            shadowColor:
                                Colors.redAccent.withOpacity(0.6),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Register",
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
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Shared Neon Input Style
  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    );
  }
}
