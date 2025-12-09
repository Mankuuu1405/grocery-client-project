import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class BhejduAppBar extends StatelessWidget {
  final String title;

  /// if true → show back arrow
  /// if false → show menu icon
  final bool showBack;

  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLoginTap;

  const BhejduAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 16, right: 16, bottom: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: BhejduColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT ICON (BACK or MENU)
          GestureDetector(
            onTap: () {
              if (showBack) {
                if (onBackTap != null) onBackTap!();
                else Navigator.pop(context);
              } else {
                if (onMenuTap != null) {
                  onMenuTap!();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              }
            },
            child: Icon(
              showBack ? Icons.arrow_back : Icons.menu,
              size: 26,
              color: Colors.white,
            ),
          ),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          /// RIGHT ACTION (LOGIN / PROFILE)
          GestureDetector(
            onTap: onLoginTap,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
