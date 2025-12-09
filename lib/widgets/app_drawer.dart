import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BhejduColors.white,
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          // -------------------- HEADER --------------------
          DrawerHeader(
            decoration: const BoxDecoration(
              color: BhejduColors.primaryBlue,
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: BhejduColors.primaryBlue,
                    size: 34,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "John Doe\njohn@example.com",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------------------- MENU ITEMS --------------------
          _drawerItem(
            context,
            icon: Icons.home,
            label: "Home",
            route: "/home",
          ),

          _drawerItem(
            context,
            icon: Icons.grid_view,
            label: "Categories",
            route: "/categories",
          ),

          _drawerItem(
            context,
            icon: Icons.shopping_bag,
            label: "My Orders",
            route: "/orders",
          ),

          _drawerItem(
            context,
            icon: Icons.shopping_cart,
            label: "My Cart",
            route: "/cart",
          ),

          _drawerItem(
            context,
            icon: Icons.location_on,
            label: "Delivery Address",
            route: "/address",
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            label: "My Profile",
            route: "/profile",
          ),

          _drawerItem(
            context,
            icon: Icons.notifications,
            label: "Notifications",
            route: "/notifications",
          ),

          _drawerItem(
            context,
            icon: Icons.account_balance_wallet,
            label: "Wallet",
            route: "/wallet",
          ),

          const Divider(height: 36),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // -------------------- ITEM BUILDER --------------------
  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon, color: BhejduColors.primaryBlue),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
