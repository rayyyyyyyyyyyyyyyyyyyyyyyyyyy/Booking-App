import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyConstant {
  // --- Colors ---
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF003366);
  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Colors.white;

  // [แก้ไข] ปรับให้เข้มขึ้น (เกือบดำ) เพื่อให้อ่านง่าย
  static const Color textDark = Color(0xFF1A1A1A); 
  
  // [แก้ไข] ปรับสีเทาให้อ่อนลงนิดนึง เพื่อให้ตัดกับสีดำชัดเจน (สำหรับ subtitle)
  static const Color grey = Color(0xFF757575); 
  
  static const Color danger = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);

  // --- Text Styles ---

  static TextStyle h1Style() => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: textDark, // สีดำเข้ม
      );

  static TextStyle h2Style() => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textDark, // สีดำเข้ม (แก้ปัญหาหัวข้อจาง)
      );

  // ใช้สำหรับหัวข้อเมนูย่อย (เช่น Personal Details)
  static TextStyle h3Style() => GoogleFonts.poppins(
        fontSize: 16, 
        fontWeight: FontWeight.w600, // หนาปานกลาง
        color: textDark, // สีดำเข้ม
      );

  static TextStyle bodyStyle() => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textDark, // เนื้อหาปกติก็ควรเข้ม
      );

  static TextStyle smallStyle() => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: grey, // รายละเอียดรองใช้สีเทาได้
      );

  static TextStyle priceStyle() => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primary,
      );
}