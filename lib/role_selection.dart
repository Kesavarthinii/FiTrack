import 'package:flutter/material.dart';
import 'login_page.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ Premium Gradient C2
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF151515),
              Color(0xFF1E1E1E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // ⭐ HEADER A STYLE
              const Text(
                "Choose Login Type",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: 20),

              // small subtitle
              Text(
                "Select who you are",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 60),

              // ⭐ Role Buttons (Card-B style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    buildRoleButton(context, "Admin", Icons.admin_panel_settings),
                    const SizedBox(height: 22),

                    buildRoleButton(context, "Trainer", Icons.fitness_center),
                    const SizedBox(height: 22),

                    buildRoleButton(context, "Member", Icons.person),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ PREMIUM ROLE BUTTON (Card-B Style)
  Widget buildRoleButton(BuildContext context, String role, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.20),
            blurRadius: 22,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginPage(role: role.toLowerCase()),
            ),
          );
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.redAccent, size: 26),
            const SizedBox(width: 12),
            Text(
              role,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
