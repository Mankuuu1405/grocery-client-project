import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool loading = true;

  /// 🔁 Reload cart EVERY time page opens
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await CartManager.getCart();

    if (!mounted) return;

    setState(() {
      cartItems = items;
      loading = false;
    });
  }

  Future<void> _updateQty(int index, int newQty) async {
    final item = cartItems[index];

    await CartManager.updateQty(
      int.parse(item["product_id"].toString()),
      int.parse(item["variant_id"].toString()),
      newQty,
    );

    await _loadCart(); // always refresh
  }

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
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : cartItems.isEmpty
                ? _emptyCart()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (int i = 0; i < cartItems.length; i++)
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 14),
                      child: _cartItem(
                        name: cartItems[i]["name"].toString(),
                        price: int.parse(
                          double.parse(
                              cartItems[i]["price"].toString())
                              .round()
                              .toString(),
                        ),
                        qty: int.parse(
                            cartItems[i]["qty"].toString()),
                        image:
                        cartItems[i]["image"]?.toString(),
                        onAdd: () => _updateQty(
                            i,
                            int.parse(cartItems[i]["qty"]
                                .toString()) +
                                1),
                        onRemove: () => _updateQty(
                            i,
                            int.parse(cartItems[i]["qty"]
                                .toString()) -
                                1),
                      ),
                    ),

                  const SizedBox(height: 20),
                  _priceDetails(cartItems),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cartItems.isEmpty
                          ? null
                          : () {
                        int subtotal = 0;
                        for (var item in cartItems) {
                          subtotal +=
                              int.parse(item["qty"]
                                  .toString()) *
                                  int.parse(double.parse(
                                      item["price"]
                                          .toString())
                                      .round()
                                      .toString());
                        }

                        int delivery =
                        subtotal > 500 ? 0 : 40;
                        int total =
                            subtotal + delivery;

                        Navigator.pushNamed(
                          context,
                          "/checkout",
                          arguments: {"total": total},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        BhejduColors.primaryBlue,
                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCart() {
    return const Center(
      child: Text(
        "Your cart is empty",
        style:
        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _cartItem({
    required String name,
    required int price,
    required int qty,
    String? image,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
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
            child: image != null && image.isNotEmpty
                ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.shopping_basket,
                  color: BhejduColors.primaryBlue),
            )
                : const Icon(Icons.shopping_basket,
                color: BhejduColors.primaryBlue),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text("₹$price",
                    style: const TextStyle(
                        color: BhejduColors.primaryBlue,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: _qtyButton(Icons.remove, filled: false),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10),
                child: Text(qty.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
              GestureDetector(
                onTap: onAdd,
                child: _qtyButton(Icons.add, filled: true),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, {required bool filled}) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: filled
            ? BhejduColors.primaryBlue
            : BhejduColors.primaryBlueLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon,
          size: 18,
          color: filled ? Colors.white : Colors.black),
    );
  }

  Widget _priceDetails(List<Map<String, dynamic>> cartItems) {
    int subtotal = 0;
    for (var item in cartItems) {
      subtotal +=
          int.parse(item["qty"].toString()) *
              int.parse(double.parse(item["price"].toString())
                  .round()
                  .toString());
    }

    int delivery = subtotal > 500 ? 0 : 40;
    int total = subtotal + delivery;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "₹$subtotal"),
          const SizedBox(height: 8),
          _priceRow(
            "Delivery Fee",
            delivery == 0 ? "FREE" : "₹$delivery",
            isGreen: delivery == 0,
          ),
          const Divider(),
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
        Text(label,
            style: TextStyle(
                fontSize: 15,
                fontWeight:
                bold ? FontWeight.w700 : FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight:
                bold ? FontWeight.w700 : FontWeight.w600,
                color: isGreen
                    ? BhejduColors.successGreen
                    : BhejduColors.textDark)),
      ],
    );
  }
}
