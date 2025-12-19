import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../screens/order_tracking_page.dart'; // ⭐ ADDED

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List orders = [];
  bool loading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  /// 🔹 FETCH USER ORDERS
  Future fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    final response = await http.post(
      Uri.parse("$baseUrl/get_orders.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        orders = data["orders"];
        loading = false;
      });
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return BhejduColors.successGreen;
      case "shipped":
        return BhejduColors.offerBlue;
      case "processing":
        return BhejduColors.offerOrange;
      default:
        return BhejduColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          /// 🔵 Custom Blue App Bar
          BhejduAppBar(
            title: "My Orders",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          /// PAGE CONTENT
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: const EdgeInsets.all(16),
              children: orders.map((o) {
                return _orderTile(
                  orderId: o["order_no"],
                  date: o["date"],
                  status: o["status"],
                  color: statusColor(o["status"]),
                  onTrack: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingPage(
                        orderStatus: o["status"], // ⭐ PASS STATUS
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ORDER TILE WIDGET ----------------
  Widget _orderTile({
    required String orderId,
    required String date,
    required String status,
    required Color color,
    required VoidCallback onTrack,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order ID + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: BhejduColors.textDark,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Status Badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Track Order Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onTrack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: BhejduColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
