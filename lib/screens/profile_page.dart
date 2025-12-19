import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import 'edit_profile_page.dart';
import 'notifications_page.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import 'contact_support_page.dart'; // ⭐ ADDED

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("user_id");
    fetchUser();
  }

  Future<void> fetchUser() async {
    if (userId == null) return;

    final res = await http.post(
      Uri.parse(
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_profile.php",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId}),
    );

    final data = jsonDecode(res.body);

    setState(() {
      user = data["status"] == "success" ? data["user"] : null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// PROFILE HEADER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          BhejduColors.primaryBlue,
                          BhejduColors.primaryBlueLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              size: 36,
                              color: BhejduColors.primaryBlue),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?["name"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?["email"] ?? "",
                              style:
                              const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?["mobile"] ?? "",
                              style:
                              const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// ACCOUNT SECTION
                  _sectionCard(
                    title: "Account",
                    children: [
                      _tile(
                        Icons.person_outline,
                        "Edit Profile",
                            () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditProfilePage(userData: user!),
                            ),
                          );
                          fetchUser();
                        },
                      ),

                      _tile(
                        Icons.location_on_outlined,
                        "Manage Addresses",
                            () => Navigator.pushNamed(context, "/address"),
                      ),

                      _tile(
                        Icons.notifications_none,
                        "Notifications",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const NotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// SUPPORT SECTION (UPDATED)
                  _sectionCard(
                    title: "Support",
                    children: [

                      _tile(
                        Icons.headset_mic_outlined,
                        "Contact & Support",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const ContactSupportPage(),
                            ),
                          );
                        },
                      ),

                      _tile(
                        Icons.description_outlined,
                        "Terms & Conditions",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const TermsConditionsPage(),
                            ),
                          );
                        },
                      ),

                      _tile(
                        Icons.privacy_tip_outlined,
                        "Privacy Policy",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const PrivacyPolicyPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// LOGOUT
                  InkWell(
                    onTap: () async {
                      final prefs =
                      await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                            (_) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Bhejdu v1.0.0\n© 2025 All rights reserved",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: BhejduColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION CARD
  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  /// TILE
  Widget _tile(
      IconData icon,
      String title,
      VoidCallback onTap, {
        String? subtitle,
      }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: BhejduColors.primaryBlueLight,
        child: Icon(icon, color: BhejduColors.primaryBlue),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
