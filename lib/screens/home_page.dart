import 'package:flutter/material.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_card.dart';
import '../widgets/product_horizontal_card.dart';
import '../widgets/review_card.dart';
import '../widgets/app_drawer.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/offer_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController fadeCtrl;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeCtrl,
      curve: Curves.easeIn,
    );

    fadeCtrl.forward();
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: BhejduColors.bgLight,

      body: FadeTransition(
        opacity: fadeAnim,
        child: Column(
          children: [
            BhejduAppBar(
              title: "Home",
              onMenuTap: () => _scaffoldKey.currentState!.openDrawer(),
              onLoginTap: () => Navigator.pushNamed(context, "/profile"),
              showBack: false,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BannerSlider(),
                    const SizedBox(height: 20),

                    // OFFERS
                    const Text(
                      "Special Offers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: BhejduColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OfferCard(
                          title: "Flat 20% OFF\nOn First Order",
                          bgColor: BhejduColors.offerOrange,
                          onTap: () {},
                        ),
                        OfferCard(
                          title: "Free Delivery\nAbove ₹500",
                          bgColor: BhejduColors.successGreen,
                          onTap: () {},
                        ),
                        OfferCard(
                          title: "Buy 1 Get 1\nSelected Items",
                          bgColor: BhejduColors.offerBlue,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // CATEGORIES
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: BhejduColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryCard(
                            title: "Vegetables",
                            icon: Icons.eco,
                            bgColor: Colors.white,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          CategoryCard(
                            title: "Fruits",
                            icon: Icons.apple,
                            bgColor: Colors.white,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          CategoryCard(
                            title: "Snacks",
                            icon: Icons.fastfood,
                            bgColor: Colors.white,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          CategoryCard(
                            title: "Beverages",
                            icon: Icons.local_cafe,
                            bgColor: Colors.white,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // FEATURED PRODUCTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Featured Products",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: BhejduColors.textDark,
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: BhejduColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const ProductHorizontalCard(
                      title: "Fresh Tomatoes",
                      price: "₹40/kg",
                      image:
                      "https://images.unsplash.com/photo-1582515073490-dc88d9f99a9b",
                    ),
                    const SizedBox(height: 12),

                    const ProductHorizontalCard(
                      title: "Premium Rice",
                      price: "₹60/kg",
                      image:
                      "https://images.unsplash.com/photo-1592928302636-ea7c9936bd0d",
                    ),

                    const SizedBox(height: 25),

                    // REVIEWS
                    const Text(
                      "Customer Reviews",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: BhejduColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const ReviewCard(
                      name: "Priya Sharma",
                      review:
                      "Fresh products and timely delivery. Highly recommended!",
                    ),
                    const SizedBox(height: 12),

                    const ReviewCard(
                      name: "Rahul Kumar",
                      review:
                      "Best grocery app! Quality is always top-notch.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
