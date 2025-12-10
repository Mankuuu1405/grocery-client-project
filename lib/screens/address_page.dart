import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  List addresses = [];
  bool isLoading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  /// FETCH USER ADDRESSES FROM BACKEND
  Future fetchAddresses() async {
    final userId = await PreferenceManager.getUserId();

    final response = await http.post(
      Uri.parse("$baseUrl/get_addresses.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        addresses = data["addresses"];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  /// ADD NEW ADDRESS
  Future addAddress(String type, String details) async {
    final userId = await PreferenceManager.getUserId();

    await http.post(
      Uri.parse("$baseUrl/add_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "title": type,
        "address": details,
      }),
    );

    fetchAddresses(); // refresh list
  }

  /// UPDATE EXISTING ADDRESS
  Future updateAddress(int id, String type, String details) async {
    await http.post(
      Uri.parse("$baseUrl/update_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "title": type,
        "address": details,
      }),
    );

    fetchAddresses();
  }

  /// DELETE ADDRESS
  Future deleteAddress(int id) async {
    final userId = await PreferenceManager.getUserId();

    await http.post(
      Uri.parse("$baseUrl/delete_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "user_id": userId,
      }),
    );

    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// TOP APP BAR
          BhejduAppBar(
            title: "My Addresses",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
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

          /// ADDRESS LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
                      /// TITLE + BUTTONS (EDIT + DELETE)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: BhejduColors.textDark,
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: BhejduColors.primaryBlue,
                                ),
                                onPressed: () {
                                  _editAddress(item);
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteAddress(item["id"]);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// ADDRESS DETAILS
                      Text(
                        item["address"],
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

  // ------------------------- ADD ADDRESS BOTTOMSHEET -------------------------
  void _showNewAddressBottomSheet() {
    TextEditingController typeCtrl = TextEditingController();
    TextEditingController detailsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  addAddress(typeCtrl.text, detailsCtrl.text);
                  Navigator.pop(context);
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

  // ------------------------- EDIT ADDRESS BOTTOMSHEET -------------------------
  void _editAddress(dynamic item) {
    TextEditingController typeCtrl =
    TextEditingController(text: item["title"]);
    TextEditingController detailsCtrl =
    TextEditingController(text: item["address"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  updateAddress(item["id"], typeCtrl.text, detailsCtrl.text);
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
