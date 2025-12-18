import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() =>
      _AddressManagementPageState();
}

class _AddressManagementPageState
    extends State<AddressManagementPage> {
  List addresses = [];
  bool isLoading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future fetchAddresses() async {
    final userId = await PreferenceManager.getUserId();

    final response = await http.post(
      Uri.parse("$baseUrl/get_addresses.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);

    setState(() {
      addresses = data["addresses"] ?? [];
      isLoading = false;
    });
  }

  Future addAddress(String type, String address) async {
    final userId = await PreferenceManager.getUserId();

    await http.post(
      Uri.parse("$baseUrl/add_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "title": type,
        "address": address,
      }),
    );

    fetchAddresses();
  }

  Future updateAddress(int id, String type, String address) async {
    await http.post(
      Uri.parse("$baseUrl/update_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "title": type,
        "address": address,
      }),
    );

    fetchAddresses();
  }

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
          BhejduAppBar(
            title: "My Addresses",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: BhejduColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add_location_alt,
                  color: Colors.white),
              label: const Text(
                "Add New Address",
                style:
                TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => _addressBottomSheet(),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];

                /// ✅ TAP TO SELECT ADDRESS
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 14),
                    padding:
                    const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                item["title"],
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              backgroundColor:
                              BhejduColors.primaryBlue,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.edit,
                                      color:
                                      BhejduColors
                                          .primaryBlue),
                                  onPressed: () =>
                                      _addressBottomSheet(
                                          item: item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      deleteAddress(
                                          item["id"]),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["address"],
                          style: const TextStyle(
                            color:
                            BhejduColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ADDRESS ADD / EDIT ----------------

  void _addressBottomSheet({dynamic item}) {
    String selectedType = item?["title"] ?? "Home";

    final houseCtrl = TextEditingController();
    final buildingCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final pincodeCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom:
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _input("Flat / House No.", houseCtrl),
                _input("Building / Apartment", buildingCtrl),
                _input("Street / Locality", streetCtrl),
                _input("Landmark", landmarkCtrl),
                _input("City", cityCtrl),
                _input("Pincode", pincodeCtrl,
                    keyboard: TextInputType.number),
                _input("Phone", phoneCtrl,
                    keyboard: TextInputType.phone),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final fullAddress = """
${houseCtrl.text}, ${buildingCtrl.text}
${streetCtrl.text}
${landmarkCtrl.text}
${cityCtrl.text} - ${pincodeCtrl.text}
Phone: ${phoneCtrl.text}
""";

                    if (item == null) {
                      addAddress(selectedType,
                          fullAddress.trim());
                    } else {
                      updateAddress(item["id"],
                          selectedType, fullAddress.trim());
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Save Address"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: BhejduColors.bgLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
