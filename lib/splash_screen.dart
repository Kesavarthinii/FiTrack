// lib/splash_screen.dart

import 'package:flutter/material.dart';
import 'role_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToStart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleSelection()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 💎 Premium Gradient Background (C2 palette)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0A0A0A), 
              Color(0xff141414), 
              Color(0xff1A1A1A)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              // 🔥 Soft Red Glow (Background Accent)
              Positioned(
                top: -140,
                right: -90,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withOpacity(0.12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.35),
                        blurRadius: 60,
                        spreadRadius: 25,
                      ),
                    ],
                  ),
                ),
              ),

              // 🔥 Additional Dim Glow Left
              Positioned(
                bottom: -150,
                left: -100,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withOpacity(0.10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.25),
                        blurRadius: 70,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),

              // ⭐ Center Branding + Animation
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 💠 Glassmorphic Card
                        Container(
                          padding: const EdgeInsets.all(34),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.25),
                                blurRadius: 35,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.redAccent,
                            size: 90,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // BRAND TITLE
                        const Text(
                          "FitRack",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Your Fitness. Your Track.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.5,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ⭐ Bottom CTA Button
              Positioned(
                bottom: 50,
                left: 40,
                right: 40,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ElevatedButton(
                    onPressed: goToStart,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.redAccent,
                      elevation: 12,
                      shadowColor: Colors.redAccent.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
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
