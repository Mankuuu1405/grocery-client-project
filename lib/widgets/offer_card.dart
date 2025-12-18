import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 120, // ✅ slightly increased for better text fit
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 3, // ✅ prevent overflow
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}
