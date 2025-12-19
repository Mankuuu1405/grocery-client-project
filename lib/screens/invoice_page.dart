import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class InvoicePage extends StatefulWidget {
  final int orderId;

  const InvoicePage({super.key, required this.orderId});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Map order = {};
  List items = [];
  bool loading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchInvoice();
  }

  Future fetchInvoice() async {
    final response = await http.post(
      Uri.parse("$baseUrl/get_invoice.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"order_id": widget.orderId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        order = data["order"];
        items = data["items"];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          BhejduAppBar(
            title: "Invoice",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🔹 ORDER INFO
                Text(
                  "Order #${order["id"]}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),
                Text("Date: ${order["created_at"]}"),
                Text("Payment: ${order["payment_method"]}"),

                const Divider(height: 30),

                /// 🔹 DELIVERY ADDRESS
                const Text(
                  "Delivery Address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(order["address"]),

                const Divider(height: 30),

                /// 🔹 ITEMS
                const Text(
                  "Items",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 10),

                ...items.map((i) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${i["product_name"]} x${i["qty"]}",
                          ),
                        ),
                        Text("₹${i["price"]}"),
                      ],
                    ),
                  );
                }).toList(),

                const Divider(height: 30),

                /// 🔹 TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Grand Total",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹${order["total_amount"]}",
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: BhejduColors.primaryBlue),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
