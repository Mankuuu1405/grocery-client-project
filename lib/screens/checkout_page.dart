import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Custom App Bar
          BhejduAppBar(
            title: "Checkout",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
                // You can add login logic
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ---------------------- ADDRESS SECTION ----------------------
                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: BhejduColors.primaryBlue, size: 28),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Home Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: BhejduColors.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "123, Green Valley, Near Central Park,\nDelhi - 110001",
                                style: TextStyle(
                                  color: BhejduColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ---------------------- PAYMENT SECTION ----------------------
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      paymentTile("Cash on Delivery", Icons.money),
                      paymentTile("UPI / Wallet", Icons.account_balance_wallet),
                      paymentTile("Credit / Debit Card", Icons.credit_card),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ---------------------- ORDER SUMMARY ----------------------
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  summaryRow("Items Total", "₹450"),
                  summaryRow("Delivery Charges", "₹40"),
                  summaryRow("Discount", "-₹50"),

                  const Divider(height: 30, thickness: 1),

                  summaryRow(
                    "Grand Total",
                    "₹440",
                    isBold: true,
                  ),

                  const SizedBox(height: 40),

                  // ---------------------- PLACE ORDER BUTTON ----------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/orderConfirmation");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Payment Option Widget
  Widget paymentTile(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BhejduColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: BhejduColors.primaryBlue, size: 26),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: BhejduColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  /// Summary Row Widget
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
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: BhejduColors.textDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 17 : 15,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: BhejduColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
