import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme/bhejdu_colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = "Guest User";
  String userEmail = "guest@example.com";
  String userImage = ""; // empty in signup

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("user_id");

    // Load from local first
    userName = prefs.getString("user_name") ?? "Guest User";
    userEmail = prefs.getString("user_email") ?? "guest@example.com";
    userImage = prefs.getString("user_image") ?? "";

    // ---- FETCH FROM DATABASE (LIVE USER DATA) ----
    if (userId != null) {
      final response = await http.get(
        Uri.parse("https://darkslategrey-chicken-274271.hostingersite.com/api/get_user.php?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          userName = data["name"] ?? userName;
          userEmail = data["email"] ?? userEmail;

          /// If profile_image is NULL → keep blank
          userImage = (data["profile_image"] != null &&
              data["profile_image"].toString().isNotEmpty)
              ? "https://darkslategrey-chicken-274271.hostingersite.com/uploads/${data["profile_image"]}"
              : "";
        });

        // Save updated values locally
        prefs.setString("user_name", userName);
        prefs.setString("user_email", userEmail);
        prefs.setString("user_image", userImage);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BhejduColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // -------------------- HEADER --------------------
          DrawerHeader(
            decoration: const BoxDecoration(
              color: BhejduColors.primaryBlue,
            ),
            child: Row(
              children: [
                // PROFILE IMAGE
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage:
                  (userImage.isNotEmpty) ? NetworkImage(userImage) : null,
                  child: userImage.isEmpty
                      ? const Icon(
                    Icons.person,
                    color: BhejduColors.primaryBlue,
                    size: 34,
                  )
                      : null,
                ),

                const SizedBox(width: 16),

                // USER DETAILS
                Expanded(
                  child: Text(
                    "$userName\n$userEmail",
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------------------- MENU ITEMS --------------------
          _drawerItem(context,
              icon: Icons.home, label: "Home", route: "/home"),
          _drawerItem(context,
              icon: Icons.grid_view, label: "Categories", route: "/categories"),
          _drawerItem(context,
              icon: Icons.shopping_bag, label: "My Orders", route: "/orders"),
          _drawerItem(context,
              icon: Icons.shopping_cart, label: "My Cart", route: "/cart"),
          _drawerItem(context,
              icon: Icons.location_on,
              label: "Delivery Address",
              route: "/address"),
          _drawerItem(context,
              icon: Icons.person, label: "My Profile", route: "/profile"),
          _drawerItem(context,
              icon: Icons.notifications,
              label: "Notifications",
              route: "/notifications"),
          _drawerItem(context,
              icon: Icons.account_balance_wallet,
              label: "Wallet",
              route: "/wallet"),

          const Divider(height: 36),

          // -------------------- PRIVACY POLICY --------------------
          ListTile(
            leading:
            const Icon(Icons.privacy_tip, color: BhejduColors.primaryBlue),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/privacy");
            },
          ),

          // -------------------- TERMS & CONDITIONS --------------------
          ListTile(
            leading:
            const Icon(Icons.description, color: BhejduColors.primaryBlue),
            title: const Text("Terms & Conditions"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/terms");
            },
          ),

          const Divider(height: 36),

          // -------------------- LOGOUT --------------------
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // -------------------- ITEM BUILDER --------------------
  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon, color: BhejduColors.primaryBlue),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
