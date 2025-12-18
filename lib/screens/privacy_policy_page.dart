import 'package:flutter/material.dart';
import '../widgets/top_app_bar.dart';
import '../theme/bhejdu_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          const BhejduAppBar(
            title: "Privacy Policy",
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '''
We respect your privacy and are committed to protecting your personal data.

Information We Collect:
• Name, email address, mobile number
• Delivery address details
• Order and payment information

How We Use Your Information:
• To process grocery orders
• To provide delivery services
• To send order updates and notifications
• To improve our app experience

Data Security:
We ensure secure storage and handling of your personal data. Payment information is processed securely through trusted payment gateways.

Third-Party Services:
We may share limited data with delivery partners and payment providers only for order fulfillment purposes.

By using this app, you agree to this Privacy Policy.
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
