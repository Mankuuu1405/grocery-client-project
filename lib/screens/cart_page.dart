import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int qty1 = 1;
  int qty2 = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Custom AppBar
          BhejduAppBar(
            title: "My Cart",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
            onLoginTap: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _cartItem(
                    name: "Fresh Tomatoes",
                    price: 40,
                    qty: qty1,
                    onAdd: () => setState(() => qty1++),
                    onRemove: () {
                      if (qty1 > 1) setState(() => qty1--);
                    },
                  ),

                  const SizedBox(height: 14),

                  _cartItem(
                    name: "Premium Rice",
                    price: 60,
                    qty: qty2,
                    onAdd: () => setState(() => qty2++),
                    onRemove: () {
                      if (qty2 > 1) setState(() => qty2--);
                    },
                  ),

                  const SizedBox(height: 25),

                  _priceDetails(),

                  const SizedBox(height: 30),

                  /// 🟦 Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/checkout");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Proceed to Checkout",
                        style: TextStyle(
                          fontSize: 16,
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

  /// ---------------- CART ITEM WIDGET ----------------
  Widget _cartItem({
    required String name,
    required int price,
    required int qty,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          )
        ],
      ),
      child: Row(
        children: [
          /// Product thumbnail
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: BhejduColors.primaryBlueLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_basket,
                color: BhejduColors.primaryBlue),
          ),

          const SizedBox(width: 14),

          /// Name + Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: BhejduColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹$price",
                  style: const TextStyle(
                    color: BhejduColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// Quantity selector
          Row(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: BhejduColors.primaryBlueLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.remove, size: 18),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  qty.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: BhejduColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                  const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ---------------- PRICE DETAILS BOX ----------------
  Widget _priceDetails() {
    int subtotal = (qty1 * 40) + (qty2 * 60);
    int delivery = subtotal > 500 ? 0 : 40;
    int total = subtotal + delivery;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          )
        ],
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "₹$subtotal"),
          const SizedBox(height: 8),
          _priceRow(
              "Delivery Fee", delivery == 0 ? "FREE" : "₹$delivery",
              isGreen: delivery == 0),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _priceRow("Total", "₹$total", bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool bold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: BhejduColors.textGrey,
            fontSize: 15,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isGreen ? BhejduColors.successGreen : BhejduColors.textDark,
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
