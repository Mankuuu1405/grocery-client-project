import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameCtrl = TextEditingController(text: "Naitik Gupta");
  final TextEditingController emailCtrl = TextEditingController(text: "naitik@example.com");
  final TextEditingController phoneCtrl = TextEditingController(text: "+91 9876543210");
  final TextEditingController addressCtrl =
  TextEditingController(text: "123, Model Town, New Delhi");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// CUSTOM APP BAR
          BhejduAppBar(
            title: "Edit Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// USER AVATAR
                  Center(
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: BhejduColors.primaryBlueLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          size: 55, color: BhejduColors.primaryBlue),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// --- TEXT INPUT FIELDS ---
                  buildInput("Full Name", nameCtrl, Icons.person),
                  const SizedBox(height: 15),

                  buildInput("Email Address", emailCtrl, Icons.email),
                  const SizedBox(height: 15),

                  buildInput("Phone Number", phoneCtrl, Icons.phone),
                  const SizedBox(height: 15),

                  buildInput("Address", addressCtrl, Icons.location_on, maxLines: 2),

                  const SizedBox(height: 30),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully!"),
                            backgroundColor: BhejduColors.primaryBlue,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CUSTOM INPUT FIELD WIDGET
  Widget buildInput(String label, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: BhejduColors.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BhejduColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: BhejduColors.primaryBlue, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
