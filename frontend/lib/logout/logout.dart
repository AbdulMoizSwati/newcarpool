import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpool_frontend/Authentication/loginscreen.dart';

Future<void> logoutFunction(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // ✅ Remove all saved data
  await prefs.clear();

  // ✅ Navigate back to Login screen and remove all previous routes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
}
