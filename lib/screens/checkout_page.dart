import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';
import '../screens/invoice_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
 {
  List addresses = [];
  Map? selectedAddress;
  int? selectedAddressId;
  bool loadingAddress = true;

  String paymentMethod = "cod";

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  late Razorpay _razorpay;
  int? _orderId;

  @override
  void initState() {
    super.initState();
    fetchAddresses();

    _razorpay = Razorpay();
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future fetchAddresses() async {
    final userId = await PreferenceManager.getUserId();

    final response = await http.post(
      Uri.parse("$baseUrl/get_addresses.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success" && data["addresses"].isNotEmpty) {
      setState(() {
        addresses = data["addresses"];
        selectedAddress = addresses.first;
        selectedAddressId = selectedAddress!["id"];
        loadingAddress = false;
      });
    } else {
      setState(() => loadingAddress = false);
    }
  }

  Future<int?> createOrder(int total) async {
    final userId = await PreferenceManager.getUserId();

    final response = await http.post(
      Uri.parse("$baseUrl/create_order.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "total_amount": total,
        "payment_method": paymentMethod,
        "address": selectedAddress?["address"],
        "cart_items": [],
      }),
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success" ? data["order_id"] : null;
  }

  Future<String?> createRazorpayOrder(int amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create_razorpay_order.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"amount": amount}),
    );

    final data = jsonDecode(response.body);
    return data["id"];
  }

  void openRazorpay(int amount, String razorpayOrderId) {
    var options = {
      'key': 'rzp_test_R616iaJnVZkuNY',
      'amount': amount * 100,
      'currency': 'INR',
      'order_id': razorpayOrderId,
      'name': 'Bhejdu',
      'description': 'Grocery Order',
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await http.post(
      Uri.parse("$baseUrl/verify_payment.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": _orderId,
        "razorpay_order_id": response.orderId,
        "razorpay_payment_id": response.paymentId,
        "razorpay_signature": response.signature,
      }),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicePage(orderId: _orderId!),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment failed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final int total = args?["total"] ?? 0;

    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Checkout",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  loadingAddress
                      ? const Center(child: CircularProgressIndicator())
                      : addresses.isEmpty
                      ? const Text(
                    "No address found. Please add one.",
                    style: TextStyle(
                        color: BhejduColors.textGrey),
                  )
                      : Column(
                    children: addresses.map<Widget>((a) {
                      return RadioListTile<int>(
                        value: a["id"],
                        groupValue: selectedAddressId,
                        onChanged: (v) {
                          setState(() {
                            selectedAddressId = v;
                            selectedAddress = a;
                          });
                        },
                        title: Text(
                          a["address"],
                          style:
                          const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),

                  RadioListTile(
                    value: "cod",
                    groupValue: paymentMethod,
                    onChanged: (v) =>
                        setState(() => paymentMethod = v.toString()),
                    title: const Text("Cash on Delivery"),
                  ),

                  RadioListTile(
                    value: "online",
                    groupValue: paymentMethod,
                    onChanged: (v) =>
                        setState(() => paymentMethod = v.toString()),
                    title: const Text("Pay Online"),
                  ),

                  const SizedBox(height: 25),

                  summaryRow("Grand Total", "₹$total", isBold: true),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedAddressId == null
                          ? null
                          : () async {

                        if (paymentMethod == "online") {
                          _orderId = await createOrder(total);
                          if (_orderId == null) return;

                          final razorpayOrderId =
                          await createRazorpayOrder(total);
                          if (razorpayOrderId == null) return;

                          openRazorpay(total, razorpayOrderId);
                        } else {
                          _orderId = await createOrder(total);
                          if (_orderId == null) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  InvoicePage(orderId: _orderId!),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 17 : 15,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w500,
              color: BhejduColors.textDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 17 : 15,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w600,
              color: BhejduColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
