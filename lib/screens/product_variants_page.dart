import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class ProductVariantsPage extends StatelessWidget {
  final String productName;

  const ProductVariantsPage({
    super.key,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> variants = [
      {"size": "100g", "price": "₹20"},
      {"size": "500g", "price": "₹60"},
      {"size": "1kg", "price": "₹110"},
      {"size": "2kg", "price": "₹210"},
    ];

    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Custom App Bar with Back Button
          BhejduAppBar(
            title: productName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
            onLoginTap: () => Navigator.pushNamed(context, "/login"),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),

              itemBuilder: (context, index) {
                final item = variants[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BhejduColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Left Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["size"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: BhejduColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["price"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: BhejduColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      /// ADD Button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BhejduColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "ADD",
                          style: TextStyle(color: Colors.white),
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
