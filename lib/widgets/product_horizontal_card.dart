import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class ProductHorizontalCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;

  final VoidCallback onTapProduct;
  final VoidCallback onAdd;

  /// 🔹 NEW (OPTIONAL)
  final String addText;

  const ProductHorizontalCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.onTapProduct,
    required this.onAdd,
    this.addText = "ADD", // ✅ DEFAULT
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 🔥 PRODUCT TAP AREA
          Expanded(
            child: InkWell(
              onTap: onTapProduct,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: BhejduColors.primaryBlueLight,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: BhejduColors.primaryBlue,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: BhejduColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: BhejduColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ✅ BUTTON (TEXT IS NOW DYNAMIC)
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: BhejduColors.primaryBlue,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              addText, // 🔹 UPDATED
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
