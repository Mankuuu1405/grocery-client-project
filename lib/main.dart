import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SCREENS
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/categories_page.dart';
import 'screens/product_listing_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart';
import 'screens/address_page.dart';
import 'screens/orders_page.dart';
import 'screens/profile_page.dart';
import 'screens/order_placed_page.dart';
import 'screens/edit_profile_page.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  runApp(const BhejduApp());
}

class BhejduApp extends StatelessWidget {
  const BhejduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bhejdu Grocery",
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: "/",

      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignupPage(),
        "/home": (context) => const HomePage(),
        "/categories": (context) => const CategoriesPage(),
        "/cart": (context) => const CartPage(),
        "/checkout": (context) => const CheckoutPage(),
        "/address": (context) => const AddressManagementPage(),
        "/orders": (context) => const OrdersPage(),
        "/profile": (context) => const ProfilePage(),
        "/order-placed": (context) => const OrderPlacedPage(),

        /// ⭐ EDIT PROFILE ROUTE WITH ARGUMENTS
        "/edit-profile": (context) {
          final Map userData =
          ModalRoute.of(context)!.settings.arguments as Map;
          return EditProfilePage(userData: userData);
        },

        /// ⭐ UPDATED PRODUCT LIST ROUTE (NOW ACCEPTS CATEGORY ID + NAME)
        "/product-list": (context) {
          final Map args =
          ModalRoute.of(context)!.settings.arguments as Map;

          return ProductListingPage(
            categoryId: args["id"],
            categoryName: args["name"],
          );
        },
      },
    );
  }
}
