import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class ProductVariantsPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductVariantsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductVariantsPage> createState() => _ProductVariantsPageState();
}

class _ProductVariantsPageState extends State<ProductVariantsPage> {
  List variants = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchVariants();
  }

  Future fetchVariants() async {
    final response = await http.post(
      Uri.parse("https://YOUR_DOMAIN.com/get_variants.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"product_id": widget.productId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        variants = data["variants"];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: widget.productName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = variants[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BhejduColors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black12.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["size"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          Text(
                            "₹${item["price"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              BhejduColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          BhejduColors.primaryBlue,
                        ),
                        child: const Text(
                          "ADD",
                          style:
                          TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
