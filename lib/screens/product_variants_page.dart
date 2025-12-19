import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/cart_manager.dart';

class ProductVariantsPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductVariantsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductVariantsPage> createState() =>
      _ProductVariantsPageState();
}

class _ProductVariantsPageState
    extends State<ProductVariantsPage> {
  List<Map<String, dynamic>> variants = [];
  bool loading = true;

  String productImage = "";

  @override
  void initState() {
    super.initState();
    fetchVariants();
  }

  /// FETCH VARIANTS FROM API
  Future<void> fetchVariants() async {
    const url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_variants.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_id": widget.productId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        variants =
        List<Map<String, dynamic>>.from(data["variants"]);

        if (variants.isNotEmpty) {
          productImage = variants[0]["image"]?.toString() ?? "";
        }
      }
    } catch (e) {
      debugPrint("Variant fetch error: $e");
    }

    if (mounted) {
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
            title: widget.productName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : variants.isEmpty
                ? const Center(
              child: Text(
                "No variants found for this product.",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  /// 🔹 BIG PRODUCT IMAGE
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(16),
                    child: Image.network(
                      productImage,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 PRODUCT NAME
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// 🔹 VARIANT COUNT
                  Text(
                    "Available Variants: ${variants.length}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                      BhejduColors.primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔽 VARIANTS LIST
                  ListView.separated(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: variants.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = variants[index];

                      return Container(
                        padding:
                        const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BhejduColors.white,
                          borderRadius:
                          BorderRadius.circular(
                              16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            /// IMAGE
                            Container(
                              height: 60,
                              width: 60,
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(12),
                                color: BhejduColors
                                    .primaryBlueLight,
                                image: item["image"] !=
                                    null &&
                                    item["image"]
                                        .toString()
                                        .isNotEmpty
                                    ? DecorationImage(
                                  image:
                                  NetworkImage(
                                    item["image"]
                                        .toString(),
                                  ),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: item["image"] ==
                                  null ||
                                  item["image"]
                                      .toString()
                                      .isEmpty
                                  ? const Icon(
                                Icons
                                    .shopping_basket,
                                color: BhejduColors
                                    .primaryBlue,
                              )
                                  : null,
                            ),

                            const SizedBox(width: 14),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    item["size"]
                                        .toString(),
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 4),
                                  Text(
                                    "₹${item["price"]}",
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                      color:
                                      BhejduColors
                                          .primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// ADD TO CART
                            ElevatedButton(
                              onPressed: () async {
                                await CartManager
                                    .addToCart({
                                  "product_id":
                                  widget.productId,
                                  "variant_id": int.parse(
                                      item["id"]
                                          .toString()),
                                  "name":
                                  "${widget.productName} (${item["size"]})",
                                  "price": int.parse(
                                    double.parse(
                                        item["price"]
                                            .toString())
                                        .round()
                                        .toString(),
                                  ),
                                  "qty": 1,
                                  "image": productImage,
                                });

                                if (context.mounted) {
                                  Navigator.pushNamed(
                                      context,
                                      "/cart");
                                }
                              },
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                BhejduColors
                                    .primaryBlue,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(10),
                                ),
                              ),
                              child: const Text(
                                "ADD",
                                style: TextStyle(
                                    color:
                                    Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
