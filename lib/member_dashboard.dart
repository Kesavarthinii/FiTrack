import 'package:flutter/material.dart';
import 'role_selection.dart';
import 'member_checkin.dart';
import 'member_trainer.dart';
import 'member_diet_view.dart';
import 'member_subscription.dart';
import 'member_goal.dart';

class MemberDashboard extends StatelessWidget {
  final String memberId;

  const MemberDashboard({Key? key, required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ C2 Premium Gradient
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
              const SizedBox(height: 10),

              // ⭐ Header A — premium centered header + logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Spacer(),
                    // Title centered using Spacer trick
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text(
                            "Member Dashboard",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            memberId,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ⭐ Logout Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const RoleSelection()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ⭐ Dashboard Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 22,
                  childAspectRatio: 0.92,
                  children: [
                    dashboardCard(
                      context,
                      icon: Icons.timer_rounded,
                      title: "Check-In / Out",
                      page: MemberCheckin(memberId: memberId),
                    ),
                    dashboardCard(
                      context,
                      icon: Icons.fitness_center_rounded,
                      title: "My Trainer",
                      page: MemberTrainer(memberId: memberId),
                    ),
                    dashboardCard(
                      context,
                      icon: Icons.restaurant_menu_rounded,
                      title: "Diet Plan",
                      page: MemberDietView(memberId: memberId),
                    ),
                    dashboardCard(
                      context,
                      icon: Icons.calendar_month_rounded,
                      title: "Subscription",
                      page: MemberSubscription(memberId: memberId),
                    ),
                    dashboardCard(
                      context,
                      icon: Icons.flag_rounded,
                      title: "My Goal",
                      page: MemberGoal(memberId: memberId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Card B — upgraded dashboard card
  Widget dashboardCard(
    BuildContext ctx, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.25),
              blurRadius: 26,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 50),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
