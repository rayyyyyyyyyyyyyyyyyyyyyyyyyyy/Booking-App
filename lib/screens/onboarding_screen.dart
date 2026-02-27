// import 'package:flutter/material.dart';
// import 'package:smart_home_app/constant/my_constant.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'signin_screen.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   // ดึงค่าจาก MyConstant มาใส่ใน List เพื่อใช้ PageView เลื่อนเปลี่ยนสี
//   final List<Color> _bgColors = [
//     MyConstant.onBoardBack1,
//     MyConstant.onBoardBack2,
//     MyConstant.onBoardBack3,
//   ];

//   final List<Map<String, dynamic>> _onboardingData = [
//     {
//       "title": "Control Everything",
//       "description": "Manage all your smart home devices from one place, anytime, anywhere.",
//       "icon": Icons.home_work_rounded,
//       "color": MyConstant.onBoardContent1,
//     },
//     {
//       "title": "Energy Saving",
//       "description": "Monitor your power usage and get insights to save energy and costs.",
//       "icon": Icons.bolt_rounded,
//       "color": MyConstant.onBoardContent2,
//     },
//     {
//       "title": "Total Security",
//       "description": "Keep your home safe with smart alerts and real-time monitoring.",
//       "icon": Icons.security_rounded,
//       "color": MyConstant.onBoardContent3,
//     },
//   ];

//   void _onSkip() async {
//   // บันทึกว่าผู้ใช้เคยดู Onboarding แล้ว
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('ON_BOARDING', false); // ตั้งค่าเป็น false เพื่อไม่ให้แสดงอีก 

//   // เปลี่ยนหน้าไปยังหน้า SignIn
//   if (!mounted) return;
//   Navigator.pushReplacement(
//     context, 
//     MaterialPageRoute(builder: (context) => const SignInScreen()), // [cite: 495, 496]
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     Color activeColor = _onboardingData[_currentPage]["color"];

//     return Scaffold(
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [_bgColors[_currentPage], MyConstant.white],
//           ),
//         ),
//         child: Stack(
//           children: [
//             PageView.builder(
//               controller: _pageController,
//               onPageChanged: (index) => setState(() => _currentPage = index),
//               itemCount: _onboardingData.length,
//               itemBuilder: (context, index) => _buildPageContent(index),
//             ),
            
//             // ปุ่ม Skip
//             Positioned(
//               top: 50,
//               right: 20,
//               child: TextButton(
//                 onPressed: _onSkip,
//                 child: Text("Skip", style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
//               ),
//             ),

//             // แถบควบคุมด้านล่าง
//             Positioned(
//               bottom: 60,
//               left: 30,
//               right: 30,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // ปุ่ม Back
//                   SizedBox(
//                     width: 70,
//                     child: _currentPage > 0
//                         ? TextButton(
//                             onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
//                             child: const Text("Back", style: TextStyle(color: MyConstant.grey)),
//                           )
//                         : null,
//                   ),

//                   // Dots Indicator
//                   Row(
//                     children: List.generate(_onboardingData.length, (index) => _buildDot(index, activeColor)),
//                   ),

//                   // ปุ่ม Next / Start
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_currentPage == _onboardingData.length - 1) {
//                         _onSkip();
//                       } else {
//                         _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: activeColor,
//                       foregroundColor: MyConstant.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                       elevation: 5,
//                     ),
//                     child: Text(_currentPage == _onboardingData.length - 1 ? "Start" : "Next"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPageContent(int index) {
//     Color contentColor = _onboardingData[index]["color"];
//     return Padding(
//       padding: const EdgeInsets.all(40.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: contentColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               Icon(
//                 _onboardingData[index]["icon"],
//                 size: 100,
//                 color: contentColor,
//               ),
//             ],
//           ),
//           const SizedBox(height: 50),
//           Text(
//             _onboardingData[index]["title"]!,
//             style: MyConstant.h1Style().copyWith(color: contentColor),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             _onboardingData[index]["description"]!,
//             textAlign: TextAlign.center,
//             style: MyConstant.bodyStyle().copyWith(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDot(int index, Color activeColor) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: 8,
//       width: _currentPage == index ? 24 : 8,
//       margin: const EdgeInsets.only(right: 5),
//       decoration: BoxDecoration(
//         color: _currentPage == index ? activeColor : MyConstant.grey.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/my_constant.dart';
import 'signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ใช้สีพื้นหลังโทนฟ้า (Travel Theme)
  final List<Color> _bgColors = [
    const Color(0xFFE3F2FD), // ฟ้าอ่อนมาก
    const Color(0xFFE0F7FA), // ฟ้าอมเขียวอ่อน
    const Color(0xFFE8EAF6), // ฟ้าอมม่วงอ่อน
  ];

  // เนื้อหา Onboarding เกี่ยวกับการจองที่พัก
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Explore the World",
      "description": "Discover thousands of hotels, resorts, and villas in your dream destinations.",
      "icon": Icons.public_rounded, // รูปโลก
      "color": MyConstant.primary,
    },
    {
      "title": "Book with Ease",
      "description": "Secure your stay instantly with our seamless and trusted booking system.",
      "icon": Icons.airplane_ticket_rounded, // รูปตั๋ว
      "color": const Color(0xFF00BFA5), // สีเขียวน้ำทะเล
    },
    {
      "title": "Enjoy Your Stay",
      "description": "Experience comfort and luxury. Let us handle the details while you relax.",
      "icon": Icons.beach_access_rounded, // รูปชายหาด/ร่ม
      "color": const Color(0xFFFF9800), // สีส้มอบอุ่น
    },
  ];

  void _onSkip() async {
    // บันทึกว่าผู้ใช้เคยดู Onboarding แล้ว
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);

    // เปลี่ยนหน้าไปยังหน้า SignIn
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = _onboardingData[_currentPage]["color"];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgColors[_currentPage], Colors.white],
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => _buildPageContent(index),
            ),
            
            // ปุ่ม Skip
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: _onSkip,
                child: Text(
                  "Skip",
                  style: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            // แถบควบคุมด้านล่าง
            Positioned(
              bottom: 60,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ปุ่ม Back (ซ่อนเมื่ออยู่หน้าแรก)
                  SizedBox(
                    width: 70,
                    child: _currentPage > 0
                        ? TextButton(
                            onPressed: () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                            child: const Text("Back", style: TextStyle(color: MyConstant.grey)),
                          )
                        : null,
                  ),

                  // Dots Indicator
                  Row(
                    children: List.generate(
                        _onboardingData.length, (index) => _buildDot(index, activeColor)),
                  ),

                  // ปุ่ม Next / Start
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _onSkip();
                      } else {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    child: Text(_currentPage == _onboardingData.length - 1 ? "Start" : "Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
    Color contentColor = _onboardingData[index]["color"];
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // วงกลมพื้นหลัง Icon + Icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: contentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                _onboardingData[index]["icon"],
                size: 100,
                color: contentColor,
              ),
            ],
          ),
          const SizedBox(height: 50),
          
          // หัวข้อ
          Text(
            _onboardingData[index]["title"]!,
            textAlign: TextAlign.center,
            style: MyConstant.h1Style().copyWith(color: contentColor, fontSize: 28),
          ),
          const SizedBox(height: 20),
          
          // คำอธิบาย
          Text(
            _onboardingData[index]["description"]!,
            textAlign: TextAlign.center,
            style: MyConstant.bodyStyle().copyWith(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, Color activeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 24 : 8, // ยืดจุดเมื่อ active
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? activeColor : MyConstant.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}