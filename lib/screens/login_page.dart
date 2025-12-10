import 'package:flutter/material.dart';
import 'dart:convert';                           // ✅ Added
import 'package:http/http.dart' as http;         // ✅ Added
import 'package:shared_preferences/shared_preferences.dart';  // ⭐ ADDED

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool isLoading = false; // ✅ Added loader

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// TOP APP BAR
          BhejduAppBar(
            title: "Login",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: BhejduColors.textGrey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// EMAIL FIELD
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email or Mobile",
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PASSWORD FIELD
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,   // ✅ Updated
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white) // ✅ Loader
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// GO TO SIGNUP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: BhejduColors.textGrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: BhejduColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // ✅ LOGIN FUNCTION (PHP + MySQL)
  // --------------------------------------------------------
  Future<void> loginUser() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse(
      "https://darkslategrey-chicken-274271.hostingersite.com/api/login.php",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final result = jsonDecode(response.body);

      setState(() => isLoading = false);

      if (result["status"] == "success") {

        // ⭐⭐⭐ SAVE USER ID LOCALLY — ADDED ⭐⭐⭐
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id", result["user_id"]);

        // ⭐ REDIRECT TO HOME PAGE
        Navigator.pushNamed(context, "/home");

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error")),
      );
    }
  }
}
