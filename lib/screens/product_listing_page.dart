import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_tile.dart';

class ProductListingPage extends StatelessWidget {
  final String categoryName;

  const ProductListingPage({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Top Blue App Bar
          BhejduAppBar(
            title: categoryName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
            onLoginTap: () => Navigator.pushNamed(context, "/login"),
          ),

          /// BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔍 Search Bar
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                        hintText: "Search products",
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PRODUCTS (EXAMPLE ITEMS)
                  ProductTile(
                    title: "Premium Basmati Rice",
                    subtitle: "1kg Pack",
                    price: "₹120",
                    icon: Icons.rice_bowl,
                    onTap: () {},
                  ),

                  const SizedBox(height: 14),

                  ProductTile(
                    title: "Wheat Flour – Aata",
                    subtitle: "5kg Bag",
                    price: "₹185",
                    icon: Icons.grain,
                    onTap: () {},
                  ),

                  const SizedBox(height: 14),

                  ProductTile(
                    title: "Refined Sugar",
                    subtitle: "1kg Pack",
                    price: "₹45",
                    icon: Icons.balance,
                    onTap: () {},
                  ),

                  const SizedBox(height: 14),

                  ProductTile(
                    title: "Groundnut Oil",
                    subtitle: "1L Bottle",
                    price: "₹140",
                    icon: Icons.local_mall,
                    onTap: () {},
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
