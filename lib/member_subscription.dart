import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberSubscription extends StatefulWidget {
  final String memberId;

  const MemberSubscription({Key? key, required this.memberId})
      : super(key: key);

  @override
  State<MemberSubscription> createState() => _MemberSubscriptionState();
}

class _MemberSubscriptionState extends State<MemberSubscription> {
  bool loading = true;
  Map sub = {};
  String message = "";

  @override
  void initState() {
    super.initState();
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    final res = await ApiService.getSubscription(widget.memberId);

    if (res["status"] == "success") {
      sub = res;
    } else {
      message = res["message"] ?? "No subscription found.";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ C2 Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF141414),
              Color(0xFF1D1D1D),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ Header A
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "My Subscription",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.redAccent),
                      )
                    : sub.isEmpty
                        ? Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.white12, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.22),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // ⭐ Icon Bubble
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent
                                              .withOpacity(0.35),
                                          blurRadius: 15,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  // ⭐ Subscription Details
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        sub["package"] ?? "Unknown Package",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Start: ${sub['start']}",
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "End: ${sub['end']}",
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )
                                ],
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
