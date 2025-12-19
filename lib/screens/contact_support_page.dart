import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  Map data = {};
  bool loading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchSupport();
  }

  Future fetchSupport() async {
    final res = await http.get(
      Uri.parse("$baseUrl/get_contact_support.php"),
    );

    final json = jsonDecode(res.body);

    if (json["status"] == "success") {
      setState(() {
        data = json;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Contact & Support",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _tile(Icons.email, "Email", data["email"]),
                  _tile(Icons.phone, "Phone", data["phone"]),
                  _tile(Icons.message, "WhatsApp", data["whatsapp"]),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 NULL-SAFE TILE (FIXED)
  Widget _tile(IconData icon, String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: BhejduColors.primaryBlueLight,
            child: Icon(icon, color: BhejduColors.primaryBlue),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                value ?? "-", // ✅ FIXED WHATSAPP ERROR
                style: const TextStyle(
                  color: BhejduColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
