// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.152.3.50/gymapi";

  // -------------------------------------------------------
  // Unified POST helper
  // -------------------------------------------------------
  static Future<Map<String, dynamic>> _post(
      String file, Map<String, String> body) async {
    final res = await http.post(
      Uri.parse("$baseUrl/$file"),
      body: body,
    );
    return jsonDecode(res.body);
  }

  // -------------------------------------------------------
  // LOGIN / REGISTER (ADMIN / TRAINER / MEMBER)
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> loginRole({
    required String role,
    required String id,
    required String password,
  }) async {
    if (role == "admin") {
      return _post("admin_login.php", {
        "admin_id": id,
        "password": password,
      });
    }
    if (role == "trainer") {
      return _post("trainer_login.php", {
        "trainer_id": id,
        "password": password,
      });
    }
    return _post("member_login.php", {
      "member_id": id,
      "password": password,
    });
  }

  static Future<Map<String, dynamic>> register({
    required String role,
    required String id,
    required String phone,
    required String password,
  }) async {
    return _post(
      role == "trainer"
          ? "trainer_register.php"
          : "member_register.php",
      {
        role == "trainer" ? "trainer_id" : "member_id": id,
        "phone": phone,
        "password": password,
      },
    );
  }

  // -------------------------------------------------------
  // ADMIN APIS
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> addMember(
      String id, String name, String phone) {
    return _post("add_member.php", {
      "member_id": id,
      "name": name,
      "phone": phone,
    });
  }

  static Future<Map<String, dynamic>> addTrainer(
      String id, String name, String phone) {
    return _post("add_trainer.php", {
      "trainer_id": id,
      "name": name,
      "phone": phone,
    });
  }

  static Future<Map<String, dynamic>> assignSubscription(
      String memberId, String package) {
    return _post("assign_subscription.php", {
      "member_id": memberId,
      "package": package,
    });
  }

  static Future<Map<String, dynamic>> assignTrainer(
      String memberId, String trainerId) {
    return _post("assign_trainer.php", {
      "member_id": memberId,
      "trainer_id": trainerId,
    });
  }

  // -------------------------------------------------------
  // 🔥 ADMIN DROPDOWN HELPERS
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> getAllMembers() {
    return _post("get_members.php", {});
  }

  static Future<Map<String, dynamic>> getAllTrainers() {
    return _post("get_trainers.php", {});
  }

  // -------------------------------------------------------
  // ⭐ ADMIN RESET PASSWORD (ONLY NEW ADDITION)
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> adminResetPassword({
    required String role, // "trainer" or "member"
    required String id,
    required String newPassword,
  }) {
    return _post("admin_reset_password.php", {
      "role": role,
      "id": id,
      "new_password": newPassword,
    });
  }

  // -------------------------------------------------------
  // TRAINER APIS
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> getAssignedMembers(String trainerId) {
    return _post("trainer_get_members.php", {
      "trainer_id": trainerId,
    });
  }

  static Future<Map<String, dynamic>> getMemberGoal(String memberId) {
    return _post("trainer_get_member_goal.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> getDiet(String memberId) {
    return _post("trainer_get_diet.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> saveDietPlan(
      String memberId,
      String trainerId,
      Map<String, String> dietMap) {
    return _post("trainer_save_diet.php", {
      "member_id": memberId,
      "trainer_id": trainerId,
      ...dietMap,
    });
  }

  static Future<Map<String, dynamic>> trainerViewAttendance(
      String memberId) {
    return _post("trainer_view_attendance.php", {
      "member_id": memberId,
    });
  }

  // -------------------------------------------------------
  // MEMBER APIS
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> memberCheckIn(String memberId) {
    return _post("member_checkin.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> memberCheckOut(String memberId) {
    return _post("member_checkout.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> saveGoal(
      String memberId, String goal, String note) {
    return _post("member_save_goal.php", {
      "member_id": memberId,
      "goal": goal,
      "note": note,
    });
  }

  static Future<Map<String, dynamic>> getGoal(String memberId) {
    return _post("member_get_goal.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> getTrainer(String memberId) {
    return _post("member_get_trainer.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> getSubscription(String memberId) {
    return _post("member_get_subscription.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> getDietPlan(String memberId) {
    return _post("member_get_diet_plan.php", {
      "member_id": memberId,
    });
  }

  static Future<Map<String, dynamic>> getMemberAttendance(String memberId) {
    return _post("member_get_attendance.php", {
      "member_id": memberId,
    });
  }

  // -------------------------------------------------------
  // ⭐ DELETE DIET PLAN
  // -------------------------------------------------------

  static Future<Map<String, dynamic>> deleteDiet(String memberId) {
    return _post("trainer_delete_diet.php", {
      "member_id": memberId,
    });
  }
}
