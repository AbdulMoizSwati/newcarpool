import 'package:shared_preferences/shared_preferences.dart';

/// 🔹 Checks if all required SharedPreferences values are set and valid.
Future<bool> checkSharedPreferencesValid() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("token");
  final role = prefs.getString("role");
  final name = prefs.getString("name");
  final id = prefs.getString("id");

  // ✅ Check if all values are non-null and non-empty
  if (token != null &&
      token.isNotEmpty &&
      role != null &&
      role.isNotEmpty &&
      name != null &&
      name.isNotEmpty &&
      id != null &&
      id.isNotEmpty) {
    return true; // ✅ Everything is valid
  } else {
    return false; // ❌ Something is missing
  }
}
