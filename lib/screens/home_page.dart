import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/banner_slider.dart';
import '../widgets/category_card.dart';
import '../widgets/offer_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_app_bar.dart';


import '../theme/bhejdu_colors.dart';
import '../screens/product_variants_page.dart';
import '../screens/all_products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  late AnimationController fadeCtrl;
  late Animation<double> fadeAnim;

  bool loading = true;
  List categories = [];
  List featured = [];
  List<String> banners = [];
  List offers = [];
  List reviews = [];

  /// ⭐ SEARCH (ADDED)
  final TextEditingController _searchCtrl = TextEditingController();
  List searchResults = [];
  bool searching = false;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeCtrl,
      curve: Curves.easeIn,
    );

    fadeCtrl.forward();
    fetchAllData();
  }

  Future fetchAllData() async {
    setState(() => loading = true);

    try {
      final bannerRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_banners.php"));
      final catRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_categories.php"));
      final featRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_featured_products.php"));
      final offerRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_offers.php"));
      final reviewRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_latest_reviews.php"));

      final bData = jsonDecode(bannerRes.body);
      final cData = jsonDecode(catRes.body);
      final fData = jsonDecode(featRes.body);
      final oData = jsonDecode(offerRes.body);
      final rData = jsonDecode(reviewRes.body);

      if (bData["status"] == "success") {
        banners = (bData["banners"] as List)
            .map<String>((e) => e["image"].toString())
            .toList();
      }
      if (cData["status"] == "success") {
        categories = cData["categories"];
      }
      if (fData["status"] == "success") {
        featured = fData["products"];
      }
      if (oData["status"] == "success") {
        offers = oData["offers"];
      }
      if (rData["status"] == "success") {
        reviews = rData["reviews"];
      }
    } catch (e) {
      debugPrint("Home error: $e");
    }

    setState(() => loading = false);
  }

  /// ⭐ SEARCH API (ADDED)
  Future searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        searching = false;
        searchResults.clear();
      });
      return;
    }

    setState(() => searching = true);

    try {
      final res = await http.post(
        Uri.parse(
            "https://darkslategrey-chicken-274271.hostingersite.com/api/search_products.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"keyword": keyword}),
      );

      final data = jsonDecode(res.body);
      if (data["status"] == "success") {
        setState(() {
          searchResults = data["products"];
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }
  }

  IconData getIcon(String? name) {
    switch (name) {
      case "eco":
        return Icons.eco;
      case "apple":
        return Icons.apple;
      case "fastfood":
        return Icons.fastfood;
      case "local_cafe":
        return Icons.local_cafe;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: BhejduColors.bgLight,

      body: FadeTransition(
        opacity: fadeAnim,
        child: Column(
          children: [
            BhejduAppBar(
              title: "Home",
              onMenuTap: () =>
                  _scaffoldKey.currentState?.openDrawer(),
            ),

            /// ⭐ SEARCH BAR (ADDED ONLY)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: searchProducts,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : searching
                  ? _buildSearchResults()
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    banners.isEmpty
                        ? const BannerSlider()
                        : _ServerBannerSlider(
                        banners: banners),

                    const SizedBox(height: 24),

                    if (offers.isNotEmpty) ...[
                      const Text(
                        "Special Offers",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                          BhejduColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection:
                        Axis.horizontal,
                        child: Row(
                          children:
                          offers.map((o) {
                            return Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  right: 12),
                              child: OfferCard(
                                title:
                                "${o["title"]}\n${o["subtitle"]}",
                                bgColor: Color(
                                  int.parse(o[
                                  "bg_color"]
                                      .replaceFirst(
                                      "#",
                                      "0xff")),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        BhejduColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 14),

                    SingleChildScrollView(
                      scrollDirection:
                      Axis.horizontal,
                      child: Row(
                        children:
                        categories.map((cat) {
                          return Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                right: 14,
                                bottom: 12),
                            child: CategoryCard(
                              title:
                              cat["name"],
                              icon: getIcon(
                                  cat["icon"]),
                              bgColor:
                              Colors.white,
                              onTap: () {
                                Navigator
                                    .pushNamed(
                                  context,
                                  "/product-list",
                                  arguments: {
                                    "id": int.parse(
                                        cat["id"]
                                            .toString()),
                                    "name":
                                    cat["name"],
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// FEATURED PRODUCTS (UNCHANGED)
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        const Text(
                          "Featured Products",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            BhejduColors
                                .textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const AllProductsPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color:
                              BhejduColors
                                  .primaryBlue,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: featured.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder:
                          (context, i) {
                        final p = featured[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductVariantsPage(
                                      productId:
                                      int.parse(p[
                                      "id"]
                                          .toString()),
                                      productName:
                                      p["name"],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            decoration:
                            BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors
                                        .black12,
                                    blurRadius:
                                    5)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(
                                      top: Radius.circular(
                                          16)),
                                  child:
                                  Image.network(
                                    p["image"],
                                    height: 120,
                                    width: double
                                        .infinity,
                                    fit: BoxFit
                                        .cover,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(
                                      10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        p["name"],
                                        maxLines:
                                        1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                      ),
                                      const SizedBox(
                                          height:
                                          6),
                                      Text(
                                        "₹${p["price"]}",
                                        style: const TextStyle(
                                            color:
                                            BhejduColors
                                                .successGreen,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    if (reviews.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text(
                        "Customer Reviews",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          BhejduColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...reviews.map((r) {
                        return _buildReviewCard(
                            r["name"],
                            r["review"]);
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1)
            Navigator.pushNamed(context, "/categories");
          if (i == 2)
            Navigator.pushNamed(context, "/orders");
          if (i == 3)
            Navigator.pushNamed(context, "/profile");
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// ⭐ SEARCH RESULT UI (ADDED)
  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, i) {
        final p = searchResults[i];
        return ListTile(
          leading: Image.network(p["image"], width: 50),
          title: Text(p["name"]),
          subtitle: Text("₹${p["price"]}"),
          onTap: () {
            setState(() => searching = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductVariantsPage(
                  productId:
                  int.parse(p["id"].toString()),
                  productName: p["name"],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewCard(String name, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: BhejduColors.primaryBlue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(review,
                    style: const TextStyle(
                        color:
                        BhejduColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// SERVER BANNER SLIDER (UNCHANGED)
class _ServerBannerSlider extends StatefulWidget {
  final List<String> banners;
  const _ServerBannerSlider({required this.banners});

  @override
  State<_ServerBannerSlider> createState() =>
      _ServerBannerSliderState();
}

class _ServerBannerSliderState extends State<_ServerBannerSlider> {
  late PageController controller;
  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!controller.hasClients) return;
      index = (index + 1) % widget.banners.length;
      controller.animateToPage(
        index,
        duration:
        const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: controller,
        itemCount: widget.banners.length,
        itemBuilder: (_, i) => ClipRRect(
          borderRadius:
          BorderRadius.circular(16),
          child: Image.network(
              widget.banners[i],
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
