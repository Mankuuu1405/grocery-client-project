import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_notifications.php",
        ),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          notifications = data["notifications"];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      debugPrint("Notification error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          const BhejduAppBar(
            title: "Notifications",
            showBack: true,
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                ? const Center(
              child: Text(
                "No notifications available",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _NotificationTile(
                  title: item["title"],
                  message: item["message"],
                  time: item["created_at"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------
/// 🔔 NOTIFICATION TILE
/// ------------------------------------------------------

class _NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const _NotificationTile({
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications,
            color: BhejduColors.primaryBlue,
            size: 28,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: BhejduColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BhejduColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BhejduColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
