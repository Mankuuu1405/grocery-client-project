import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_horizontal_card.dart';
import 'product_variants_page.dart';

class ProductListingPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductListingPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListingPage> createState() =>
      _ProductListingPageState();
}

class _ProductListingPageState
    extends State<ProductListingPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    const String url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_products.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category_id": widget.categoryId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          products = data["products"];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: widget.categoryName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(
              child: Text(
                "No products found in this category.",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 14),
                  child: ProductHorizontalCard(
                    title: item["name"],
                    price: "₹${item["price"]}",
                    image: item["image"],

                    /// OPEN VARIANTS
                    onTapProduct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductVariantsPage(
                                productId: int.parse(
                                    item["id"].toString()),
                                productName: item["name"],
                              ),
                        ),
                      );
                    },

                    /// VIEW (UPDATED)
                    onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductVariantsPage(
                                productId: int.parse(
                                    item["id"].toString()),
                                productName: item["name"],
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
