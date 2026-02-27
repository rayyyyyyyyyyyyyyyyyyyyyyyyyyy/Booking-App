import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constant/my_constant.dart';
import '../data/product.dart';
import 'profile_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Product> products = []; 
  bool isLoading = true; 
  final List<String> categories = ["All", "Luxury", "Beachfront", "Villa", "City Center"];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Future<void> fetchProducts() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   final List<Product> mockData = [
  //     Product(name: 'Grand Royal Hotel', location: 'Bangkok, Thailand', price: 120, rating: 4.5, image: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&q=80", category: 'Luxury', inStock: true),
  //     Product(name: 'Sunset Beach Resort', location: 'Phuket, Thailand', price: 250, rating: 4.8, image: "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80", category: 'Beachfront', inStock: true),
  //     Product(name: 'Cozy Mountain Cabin', location: 'Chiang Mai, Thailand', price: 80, rating: 4.3, image: "https://cf.bstatic.com/xdata/images/hotel/max1024x768/404275172.jpg?k=51874ade57016fa574be23261076cf71ceaff23ff63ebca5b6b861d5ff50339b&o=", category: 'Villa', inStock: true),
  //     Product(name: 'Urban City Loft', location: 'Singapore', price: 180, rating: 4.7, image: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500&q=80", category: 'City Center', inStock: true),
  //     Product(name: 'The Azure Villa', location: 'Maldives', price: 450, rating: 4.9, image: "https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500&q=80", category: 'Beachfront', inStock: true),
  //     Product(name: 'Modern Studio', location: 'Tokyo, Japan', price: 100, rating: 4.2, image: "https://images.unsplash.com/photo-1554995207-c18c203602cb?w=500&q=80", category: 'City Center', inStock: true),
  //   ];
  //   if (mounted) {
  //     setState(() {
  //       products = mockData;
  //       isLoading = false;
  //     });
  //   }
  // }


  Future<void> fetchProducts() async {
    // กำหนด URL ตาม Platform อัตโนมัติ
    String baseUrl;
    if (kIsWeb) {
      // ถ้าเป็น Web (Edge/Chrome) ใช้ localhost ได้เลย
      baseUrl = 'http://localhost:3000/api/products';
    } else {
      // ถ้าเป็น Android Emulator ใช้ 10.0.2.2
      baseUrl = 'http://10.0.2.2:3000/api/products';
    }

    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // แปลงข้อมูล JSON
        // ใช้ utf8.decode เพื่อรองรับภาษาไทย
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        final List<Product> apiProducts = data.map((json) => Product.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            products = apiProducts;
            isLoading = false;
          });
        }
      } else {
        print('Server Error: ${response.statusCode}');
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching data: $e');
      // กรณีเชื่อมต่อไม่ได้ (เช่น ลืมเปิด Server)
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.background,
      body: _buildBodyContent(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0: return _buildHomeContent();
      case 1: return const Center(child: Text("Saved Hotels Page"));
      case 2: return const Center(child: Text("My Bookings Page"));
      case 3: return const ProfileScreen();
      default: return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() => isLoading = true);
          await fetchProducts();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 25),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Explore Categories", style: MyConstant.h2Style()), // ใช้ h2
                  TextButton(onPressed: (){}, child: const Text("See All", style: TextStyle(color: MyConstant.primary)))
                ],
              ),
              const SizedBox(height: 10),
              _buildCategorySelector(),
              
              const SizedBox(height: 25),
              Text("Popular Stays", style: MyConstant.h2Style()), // ใช้ h2
              const SizedBox(height: 15),

              isLoading 
                ? SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: MyConstant.primary)))
                : _buildHotelGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style: MyConstant.bodyStyle().copyWith(color: MyConstant.grey)), // ใช้ body
            Text(user?.displayName ?? "Traveler", style: MyConstant.h1Style()), // ใช้ h1 ใหญ่ชัด
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: MyConstant.primary, width: 2)),
          child: const CircleAvatar(radius: 24, backgroundImage: AssetImage('lib/images/head_rabbit.jpg')),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
      child: TextField(
        style: MyConstant.bodyStyle(), // ใช้ body
        decoration: InputDecoration(
          hintText: "Where do you want to go?",
          hintStyle: MyConstant.bodyStyle().copyWith(color: MyConstant.grey), // ใช้ body
          border: InputBorder.none,
          icon: Icon(Icons.search, color: MyConstant.primary),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 45, // เพิ่มความสูงนิดหน่อย
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? MyConstant.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected ? [BoxShadow(color: MyConstant.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                border: isSelected ? null : Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: isSelected 
                    ? MyConstant.bodyStyle().copyWith(color: Colors.white, fontWeight: FontWeight.bold) 
                    : MyConstant.bodyStyle(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHotelGrid() {
    List<Product> filteredHotels = selectedCategoryIndex == 0 ? products : products.where((p) => p.category == categories[selectedCategoryIndex]).toList();
    if (filteredHotels.isEmpty) return const SizedBox(height: 200, child: Center(child: Text("No hotels found")));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // ปรับสัดส่วนให้เหมาะสมกับ Text ใหญ่ขึ้น
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: filteredHotels.length,
      itemBuilder: (context, index) => _buildHotelCard(filteredHotels[index]),
    );
  }

  Widget _buildHotelCard(Product hotel) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(hotel.image, width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200])),
                  ),
                  Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle), child: const Icon(Icons.favorite_border, size: 18, color: MyConstant.danger))),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(hotel.name, style: MyConstant.h2Style().copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), // ใช้ h2 แต่ลดขนาดนิดหน่อยเพื่อให้เข้ากับการ์ด
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: MyConstant.grey),
                        const SizedBox(width: 4),
                        Expanded(child: Text(hotel.location, style: MyConstant.smallStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(text: TextSpan(children: [TextSpan(text: "\$${hotel.price.toInt()}", style: MyConstant.priceStyle().copyWith(fontSize: 18)), TextSpan(text: "/night", style: MyConstant.smallStyle())])),
                        Row(children: [const Icon(Icons.star, size: 14, color: MyConstant.warning), const SizedBox(width: 2), Text("${hotel.rating}", style: MyConstant.smallStyle().copyWith(fontWeight: FontWeight.bold, color: MyConstant.textDark))]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: MyConstant.primary,
        unselectedItemColor: MyConstant.grey,
        selectedLabelStyle: MyConstant.smallStyle().copyWith(fontWeight: FontWeight.bold), // ใช้ small
        unselectedLabelStyle: MyConstant.smallStyle(), // ใช้ small
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket_outlined), activeIcon: Icon(Icons.airplane_ticket), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}