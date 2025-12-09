import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  List<Map<String, String>> addresses = [
    {
      "type": "Home",
      "details": "123, Green Avenue, Near City Mall, Lucknow",
    },
    {
      "type": "Office",
      "details": "B-42 Tech Park Tower, 3rd Floor",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// TOP CUSTOM APP BAR
          BhejduAppBar(
            title: "My Addresses",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
            onLoginTap: () {},
          ),

          const SizedBox(height: 10),

          /// ADD NEW ADDRESS BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: BhejduColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add_location_alt, color: Colors.white),
              label: const Text(
                "Add New Address",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                _showNewAddressBottomSheet();
              },
            ),
          ),

          const SizedBox(height: 20),

          /// SAVED ADDRESSES LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
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

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ADDRESS TYPE & OPTIONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item["type"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: BhejduColors.textDark,
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: BhejduColors.primaryBlue),
                                onPressed: () {
                                  _editAddress(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() => addresses.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// ADDRESS DETAILS
                      Text(
                        item["details"]!,
                        style: const TextStyle(
                          color: BhejduColors.textGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------- ADD NEW ADDRESS -------------------
  void _showNewAddressBottomSheet() {
    TextEditingController typeCtrl = TextEditingController();
    TextEditingController detailsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),

      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: typeCtrl,
                decoration: InputDecoration(
                  labelText: "Address Type (Home / Office)",
                  filled: true,
                  fillColor: BhejduColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: detailsCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Full Address",
                  filled: true,
                  fillColor: BhejduColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BhejduColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (typeCtrl.text.isNotEmpty &&
                      detailsCtrl.text.isNotEmpty) {
                    setState(() {
                      addresses.add({
                        "type": typeCtrl.text,
                        "details": detailsCtrl.text,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save Address",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /// ------------------- EDIT ADDRESS -------------------
  void _editAddress(int index) {
    TextEditingController typeCtrl =
    TextEditingController(text: addresses[index]["type"]);
    TextEditingController detailsCtrl =
    TextEditingController(text: addresses[index]["details"]);

    _showEditBottomSheet(typeCtrl, detailsCtrl, index);
  }

  void _showEditBottomSheet(
      TextEditingController typeCtrl, TextEditingController detailsCtrl, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),

      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: typeCtrl,
                decoration: InputDecoration(
                  labelText: "Address Type",
                  filled: true,
                  fillColor: BhejduColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: detailsCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Full Address",
                  filled: true,
                  fillColor: BhejduColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BhejduColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    addresses[index] = {
                      "type": typeCtrl.text,
                      "details": detailsCtrl.text,
                    };
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "Update Address",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
