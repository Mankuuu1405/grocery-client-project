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
          /// 🔵 TOP ROW: MENU - LOGO - CART/PROFILE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// LEFT MENU
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

              /// CENTER LOGO
              Image.asset(
                "assets/images/logo.png",
                height: 40,
              ),

              /// RIGHT ICONS
              Row(
                children: [
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

          const SizedBox(height: 6),

          /// 🔵 HOME (CENTERED UNDER LOGO)
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: BhejduColors.textDark,
            ),
          ),
        ],
      ),



    );
  }
}
