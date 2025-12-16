import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// CART LIST (dynamic)
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Fresh Tomatoes",
      "price": 40,
      "qty": 1,
    },
    {
      "name": "Premium Rice",
      "price": 60,
      "qty": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          BhejduAppBar(
            title: "My Cart",
            showBack: true,
            onBackTap: () => Navigator.pop(context),

          ),

          Expanded(
            child: cartItems.isEmpty
                ? _emptyCart()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (int i = 0; i < cartItems.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _cartItem(
                        name: cartItems[i]["name"],
                        price: cartItems[i]["price"],
                        qty: cartItems[i]["qty"],
                        onAdd: () {
                          setState(() => cartItems[i]["qty"]++);
                        },
                        onRemove: () {
                          if (cartItems[i]["qty"] > 1) {
                            setState(() => cartItems[i]["qty"]--);
                          } else {
                            setState(() => cartItems.removeAt(i));
                          }
                        },
                      ),
                    ),

                  const SizedBox(height: 20),
                  _priceDetails(),
                  const SizedBox(height: 30),

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

  /// EMPTY CART UI
  Widget _emptyCart() {
    return const Center(
      child: Text(
        "Your cart is empty",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// CART ITEM UI
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

  /// PRICE DETAILS
  Widget _priceDetails() {
    int subtotal = 0;

    for (var item in cartItems) {
      subtotal += (item["qty"] as int) * (item["price"] as int);
    }


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
          _priceRow("Delivery Fee",
              delivery == 0 ? "FREE" : "₹$delivery",
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
            color:
            isGreen ? BhejduColors.successGreen : BhejduColors.textDark,
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
