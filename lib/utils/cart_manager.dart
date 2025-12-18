import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static const String _cartKey = "cart_items";

  /// GET CART
  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_cartKey);

    if (data == null || data.isEmpty) return [];

    final List decoded = jsonDecode(data);

    return decoded.map<Map<String, dynamic>>((e) {
      return {
        "product_id": int.parse(e["product_id"].toString()),
        "variant_id": int.parse(e["variant_id"].toString()),
        "name": e["name"].toString(),
        "price": int.parse(
          double.parse(e["price"].toString()).round().toString(),
        ), // ✅ handles DECIMAL
        "qty": int.parse(e["qty"].toString()),
        "image": e["image"]?.toString() ?? "",
      };
    }).toList();
  }

  /// ADD TO CART
  static Future<void> addToCart(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final int productId =
    int.parse(item["product_id"].toString());
    final int variantId =
    int.parse(item["variant_id"].toString());

    final int price = int.parse(
      double.parse(item["price"].toString()).round().toString(),
    );

    final index = cart.indexWhere(
          (e) =>
      e["product_id"] == productId &&
          e["variant_id"] == variantId,
    );

    if (index >= 0) {
      cart[index]["qty"] =
          int.parse(cart[index]["qty"].toString()) + 1;
    } else {
      cart.add({
        "product_id": productId,
        "variant_id": variantId,
        "name": item["name"].toString(),
        "price": price,
        "qty": 1,
        "image": item["image"]?.toString() ?? "",
      });
    }

    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  /// UPDATE QTY (PRODUCT + VARIANT)
  static Future<void> updateQty(
      int productId, int variantId, int qty) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final index = cart.indexWhere(
          (e) =>
      e["product_id"] == productId &&
          e["variant_id"] == variantId,
    );

    if (index >= 0) {
      if (qty <= 0) {
        cart.removeAt(index);
      } else {
        cart[index]["qty"] = qty;
      }
    }

    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  /// CLEAR CART
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
