import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberRegisterPage extends StatefulWidget {
  @override
  State<MemberRegisterPage> createState() => _MemberRegisterPageState();
}

class _MemberRegisterPageState extends State<MemberRegisterPage>
    with SingleTickerProviderStateMixin {
  final idCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  bool _obscurePassword = true;

  late AnimationController anim;
  late Animation<double> fade;
  late Animation<double> slide;

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fade = CurvedAnimation(parent: anim, curve: Curves.easeInOut);
    slide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: anim, curve: Curves.easeOut),
    );

    anim.forward();
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  void doRegister() async {
    if (idCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    setState(() => loading = true);

    final res = await ApiService.register(
      role: "member",
      id: idCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "")));

    if (res["status"] == "success") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF151515), Color(0xFF1F1F1F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: fade,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  const Text(
                    "Member Registration",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your FitRack account",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 45),
                  AnimatedBuilder(
                    animation: anim,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, slide.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.25),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: idCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputField("Member ID"),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputField("Phone Number"),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: passCtrl,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputField("Set Password").copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loading ? null : doRegister,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15),
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 9,
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "Register",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔧 ONLY FIX APPLIED HERE
  InputDecoration inputField(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),

      // ✅ prevents yellow overflow box
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.18)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }
}
