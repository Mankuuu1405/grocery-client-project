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
import 'screens/otp_page.dart';                 // Signup OTP Page
import 'screens/forgot_password_page.dart';    // ⭐ Forgot Password
import 'screens/reset_otp_page.dart';          // ⭐ Reset Password OTP
import 'screens/reset_password_page.dart';     // ⭐ New Password
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

        // ⭐ SIGNUP OTP PAGE ROUTE
        "/otp": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;

          return OtpPage(
            userId: args["user_id"],
            email: args["email"],
          );
        },

        // ⭐ FORGOT PASSWORD PAGE
        "/forgot-password": (context) => const ForgotPasswordPage(),

        // ⭐ RESET PASSWORD OTP PAGE
        "/reset-otp": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;

          return ResetOtpPage(
            userId: args["user_id"],
            email: args["email"],
          );
        },

        // ⭐ RESET PASSWORD PAGE (New Password)
        "/reset-password": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;

          return ResetPasswordPage(
            userId: args["user_id"],
          );
        },

        // ⭐ EDIT PROFILE PAGE
        "/edit-profile": (context) {
          final Map userData =
          ModalRoute.of(context)!.settings.arguments as Map;
          return EditProfilePage(userData: userData);
        },

        // ⭐ PRODUCT LIST PAGE
        "/product-list": (context) {
          final Map args = ModalRoute.of(context)!.settings.arguments as Map;

          return ProductListingPage(
            categoryId: int.parse(args["id"].toString()),  // ⭐ FIXED
            categoryName: args["name"],
          );
        },

      },
    );
  }
}
