import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';  // ⭐ ADDED

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;

  int? userId; // ⭐ ADDED

  @override
  void initState() {
    super.initState();
    loadUserId(); // ⭐ ADDED
  }

  /// ⭐ ADDED — FETCH USER ID FROM SHARED PREFERENCES
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("user_id"); // stored at login
    fetchUser(); // now call your existing fetch function
  }

  /// 🔵 FETCH USER DATA
  Future<void> fetchUser() async {
    if (userId == null) return; // ⭐ ADDED safety

    setState(() => loading = true);

    final res = await http.post(
      Uri.parse("https://darkslategrey-chicken-274271.hostingersite.com/api/get_profile.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId}),     // ⭐ UPDATED (NO HARD CODE)
    );

    final data = jsonDecode(res.body);

    if (data["status"] == "success") {
      setState(() {
        user = data["user"];
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "My Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : user == null
                ? const Center(child: Text("Error loading profile"))
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PROFILE CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: BhejduColors.primaryBlueLight,
                          backgroundImage: user!["profile_image"] != null &&
                              user!["profile_image"] != ""
                              ? NetworkImage(
                              "https://darkslategrey-chicken-274271.hostingersite.com/uploads/${user!["profile_image"]}")
                              : null,
                          child: (user!["profile_image"] == null ||
                              user!["profile_image"] == "")
                              ? const Icon(
                            Icons.person,
                            size: 40,
                            color: BhejduColors.primaryBlue,
                          )
                              : null,
                        ),

                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!["name"] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: BhejduColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user!["email"] ?? "",
                              style: const TextStyle(
                                color: BhejduColors.textGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// EDIT PROFILE
                  _profileTile(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(userData: user!),
                        ),
                      );
                      fetchUser(); // refresh after update
                    },
                  ),

                  const SizedBox(height: 12),

                  _profileTile(
                    icon: Icons.location_on,
                    title: "My Addresses",
                    onTap: () => Navigator.pushNamed(context, "/address"),
                  ),

                  const SizedBox(height: 12),

                  _profileTile(
                    icon: Icons.shopping_bag,
                    title: "My Orders",
                    onTap: () => Navigator.pushNamed(context, "/orders"),
                  ),

                  const SizedBox(height: 12),

                  _profileTile(
                    icon: Icons.favorite,
                    title: "Wishlist",
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _profileTile(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _profileTile(
                    icon: Icons.help_center,
                    title: "Help & Support",
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  /// LOGOUT
                  _profileTile(
                    icon: Icons.logout,
                    title: "Logout",
                    isLogout: true,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance(); // ⭐ ADDED
                      await prefs.clear(); // remove user_id ⭐

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                            (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 26,
          color: isLogout ? Colors.red : BhejduColors.primaryBlue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : BhejduColors.textDark,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
