import 'package:flutter/material.dart';
import '../widgets/top_app_bar.dart';
import '../theme/bhejdu_colors.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          const BhejduAppBar(
            title: "Terms & Conditions",
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '''
Welcome to our Grocery Shopping Application.

By using this app, you agree to the following terms:

• Users must provide accurate account information
• Orders once placed cannot be cancelled after dispatch
• Prices and availability are subject to change
• Delivery slots are allocated based on availability
• Cash on Delivery and online payments are supported
• Misuse of the platform may result in account suspension

The company reserves the right to modify services, pricing, or policies at any time.

Continued use of the app implies acceptance of these terms.
''',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: BhejduColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
