import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/category_tile.dart';
import '../widgets/top_app_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// ---------------- BLUE HEADER ----------------
          BhejduAppBar(
            title: "Categories",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          /// ---------------- BODY ----------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// ---------------- SEARCH BOX ----------------
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
                        icon: Icon(Icons.search, color: BhejduColors.primaryBlue),
                        hintText: "Search categories",
                        hintStyle: TextStyle(color: BhejduColors.textGrey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ---------------- GRID OF CATEGORIES ----------------
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,

                    children: const [
                      CategoryTile(
                        title: "Vegetables",
                        count: "20 Items",
                        icon: Icons.eco,
                      ),
                      CategoryTile(
                        title: "Fruits",
                        count: "18 Items",
                        icon: Icons.apple,
                      ),
                      CategoryTile(
                        title: "Snacks",
                        count: "32 Items",
                        icon: Icons.fastfood,
                      ),
                      CategoryTile(
                        title: "Oils",
                        count: "12 Items",
                        icon: Icons.local_mall,
                      ),
                      CategoryTile(
                        title: "Dairy",
                        count: "10 Items",
                        icon: Icons.local_drink,
                      ),
                      CategoryTile(
                          title: "Beverages",
                          count: "16 Items",
                          icon: Icons.local_cafe),
                    ],
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
