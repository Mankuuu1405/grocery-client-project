import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 TOP APP BAR
          BhejduAppBar(
            title: "My Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
            onLoginTap: () {}, // Profile already opened
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 👤 PROFILE CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BhejduColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: BhejduColors.primaryBlueLight,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: BhejduColors.primaryBlue,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: BhejduColors.textDark,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "johndoe@gmail.com",
                              style: TextStyle(
                                color: BhejduColors.textGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ⚙ PROFILE SETTINGS MENU
                  _profileOption(
                    icon: Icons.location_on,
                    title: "My Addresses",
                    onTap: () => Navigator.pushNamed(context, "/address"),
                  ),
                  const SizedBox(height: 12),

                  _profileOption(
                    icon: Icons.shopping_bag,
                    title: "My Orders",
                    onTap: () => Navigator.pushNamed(context, "/orders"),
                  ),
                  const SizedBox(height: 12),

                  _profileOption(
                    icon: Icons.favorite,
                    title: "Wishlist",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  _profileOption(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  _profileOption(
                    icon: Icons.help_center,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  /// 🚪 LOGOUT BUTTON
                  _profileOption(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false,
                    ),
                    isLogout: true,
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ---- REUSABLE PROFILE MENU TILE ----
  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : BhejduColors.primaryBlue,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isLogout ? Colors.red : BhejduColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
