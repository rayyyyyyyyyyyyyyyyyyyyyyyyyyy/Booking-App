import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/screens/home_screen.dart';
import 'package:smart_home_app/screens/product_screen.dart';

import 'screens/product_page.dart';

import 'screens/onboarding_screen.dart';
import 'screens/signin_screen.dart';
import 'constant/my_constant.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. ประกาศตัวแปร global หรือส่งผ่าน constructor
bool showOnboarding = true; 

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. ตรวจสอบสถานะจากเครื่อง
  final prefs = await SharedPreferences.getInstance();
  // ถ้าไม่เคยบันทึก (เป็น null) ให้ค่า default เป็น true (แสดง Onboarding)
  showOnboarding = prefs.getBool('ON_BOARDING') ?? true; 
   
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(
        scaffoldBackgroundColor: MyConstant.background,
        primaryColor: MyConstant.primary,
        useMaterial3: true,
      ),
      // 3. เลือกหน้าที่จะแสดงผลตามค่าที่ได้
      home: showOnboarding ? const OnboardingScreen() : const SignInScreen(),
      // home: showOnboarding ? const HomeScreen() : const SignInScreen(),
      // home: showOnboarding ? const ProductScreen() : const SignInScreen(),
      // home: showOnboarding ? const ProductsPage() : const SignInScreen(),
    );
  }
}