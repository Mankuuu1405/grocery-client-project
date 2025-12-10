import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_tile.dart';
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
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    final response = await http.post(
      Uri.parse("https://YOUR_DOMAIN.com/get_products.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"category_id": widget.categoryId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        products = data["products"];
        loading = false;
      });
    }
  }

  IconData getIcon() => Icons.shopping_bag;

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
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductVariantsPage(
                            productId: item["id"],
                            productName: item["name"],
                          ),
                        ),
                      );
                    },
                    child: ProductTile(
                      title: item["name"],
                      subtitle: "Best Quality",
                      price: "₹${item["price"]}",
                      icon: getIcon(),
                      onTap: () {},
                    ),
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
