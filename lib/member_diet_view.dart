import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberDietView extends StatefulWidget {
  final String memberId;

  const MemberDietView({Key? key, required this.memberId}) : super(key: key);

  @override
  State<MemberDietView> createState() => _MemberDietViewState();
}

class _MemberDietViewState extends State<MemberDietView> {
  bool loading = true;
  Map diet = {};
  String message = "";

  @override
  void initState() {
    super.initState();
    loadDiet();
  }

  Future<void> loadDiet() async {
    final res = await ApiService.getDietPlan(widget.memberId);

    if (res["status"] == "success") {
      diet = res["diet"];
    } else {
      message = res["message"] ?? "No diet plan found";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ⭐ Premium Gradient Background (C2)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF151515), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ Header A (same for all pages)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "My Diet Plan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent))
                    : diet.isEmpty
                        ? Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemCount: diet.length,
                            itemBuilder: (_, i) {
                              final key = diet.keys.elementAt(i);
                              final val = diet[key] ?? "";

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.25),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      key.toString().toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      val,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
