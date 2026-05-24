import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberTrainer extends StatefulWidget {
  final String memberId;

  const MemberTrainer({Key? key, required this.memberId}) : super(key: key);

  @override
  State<MemberTrainer> createState() => _MemberTrainerState();
}

class _MemberTrainerState extends State<MemberTrainer> {
  bool loading = true;
  Map trainer = {};
  String message = "";

  @override
  void initState() {
    super.initState();
    loadTrainer();
  }

  Future<void> loadTrainer() async {
    final res = await ApiService.getTrainer(widget.memberId);

    if (res["status"] == "success") {
      trainer = res["trainer"];
    } else {
      message = res["message"] ?? "No trainer assigned.";
    }

    setState(() => loading = false);
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ HEADER A
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
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),

                    const Text(
                      "My Trainer",
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

              // ⭐ CONTENT
              Expanded(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent),
                      )
                    : trainer.isEmpty
                        ? Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white12, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.25),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),

                              // ⭐ COMPACT HORIZONTAL CARD B
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
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  // ⭐ Trainer Details
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trainer["name"] ?? "Unknown Trainer",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Text(
                                        "Phone: ${trainer['phone']}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "ID: ${trainer['trainer_id']}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
