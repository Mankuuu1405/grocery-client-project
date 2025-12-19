import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/bhejdu_colors.dart';

class BhejduAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final bool showAccountIcon;

  const BhejduAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.showAccountIcon = true,
  });

  Future<void> _handleAccountTap(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    if (userId != null) {
      Navigator.pushNamed(context, "/profile");
    } else {
      Navigator.pushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50, // 🔹 extra space for status bar + logo
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔵 ROW 1 — LOGO
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 38, // adjust if needed
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 ROW 2 — HEADER BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT (MENU / BACK)
              GestureDetector(
                onTap: () {
                  if (showBack) {
                    onBackTap != null
                        ? onBackTap!()
                        : Navigator.pop(context);
                  } else {
                    onMenuTap?.call();
                  }
                },
                child: Icon(
                  showBack ? Icons.arrow_back : Icons.menu,
                  color: BhejduColors.textDark,
                  size: 26,
                ),
              ),

              /// CENTER TITLE
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: BhejduColors.textDark,
                ),
              ),

              /// RIGHT ICONS
              Row(
                children: [
                  /// 🛒 CART
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/cart");
                    },
                    child: const Icon(
                      Icons.shopping_cart,
                      color: BhejduColors.textDark,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// 👤 ACCOUNT
                  showAccountIcon
                      ? GestureDetector(
                    onTap: () => _handleAccountTap(context),
                    child: const Icon(
                      Icons.person,
                      color: BhejduColors.textDark,
                      size: 26,
                    ),
                  )
                      : const SizedBox(width: 26),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
