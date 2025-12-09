import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: BhejduColors.primaryBlue, size: 32),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BhejduColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
