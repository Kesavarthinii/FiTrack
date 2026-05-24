import 'package:flutter/material.dart';
import 'api_service.dart';
import 'admin_dashboard.dart';
import 'trainer_dashboard.dart';
import 'member_dashboard.dart';
import 'trainer_register.dart';
import 'member_register.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final idCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  // 🔥 Password visibility
  bool _obscurePassword = true;

  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void loginNow() async {
    setState(() => loading = true);

    final res = await ApiService.loginRole(
      role: widget.role,
      id: idCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "")));

    if (res["status"] != "success") return;

    if (widget.role == "admin") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AdminDashboard()));
    } else if (widget.role == "trainer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TrainerDashboard(trainerId: idCtrl.text.trim()),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MemberDashboard(memberId: idCtrl.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final idLabel = widget.role == "admin"
        ? "Admin ID"
        : widget.role == "trainer"
            ? "Trainer ID"
            : "Member ID";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0A0A0A), Color(0xff181818), Color(0xff1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Text(
                    "${widget.role.toUpperCase()} LOGIN",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Welcome back — let’s get you in",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),

                  const SizedBox(height: 50),

                  AnimatedBuilder(
                    animation: _anim,
                    builder: (_, child) {
                      return Transform.translate(
                        offset: Offset(0, _slide.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.25),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          TextField(
                            controller: idCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputBox(idLabel),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: passCtrl,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputBox("Password").copyWith(
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

                          const SizedBox(height: 12),

                          // 🔐 FORGOT PASSWORD (TRAINER & MEMBER ONLY)
                          if (widget.role != "admin")
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordInfoPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loading ? null : loginNow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (widget.role != "admin")
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => widget.role == "trainer"
                                        ? TrainerRegisterPage()
                                        : MemberRegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Register here",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
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
        ),
      ),
    );
  }

  InputDecoration inputBox(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

// 🔐 SIMPLE INFO PAGE — NO LOGIC
class ForgotPasswordInfoPage extends StatelessWidget {
  const ForgotPasswordInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0A0A0A), Color(0xff1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.lock_reset,
                      color: Colors.redAccent, size: 64),
                  SizedBox(height: 20),
                  Text(
                    "Password Reset",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Please contact the Admin to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
