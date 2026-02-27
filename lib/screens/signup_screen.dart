import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constant/my_constant.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ตัวแปรสำหรับซ่อน/แสดงรหัสผ่าน (แยกกัน 2 ช่อง)
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controller สำหรับรับค่าจากฟอร์ม
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  // ฟังก์ชันสมัครสมาชิก
  void signup() async {
    // 1. ตรวจสอบความถูกต้องของข้อมูล (Validation)
    if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      _showErrorSnackBar("Please fill in all fields.");
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showErrorSnackBar("Passwords do not match.");
      return;
    }

    if (passwordCtrl.text.length < 6) {
      _showErrorSnackBar("Password must be at least 6 characters.");
      return;
    }

    // 2. แสดง Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 3. สร้างบัญชีกับ Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      // (Optional) อัปเดตชื่อผู้ใช้ (Display Name)
      await userCredential.user?.updateDisplayName(nameCtrl.text.trim());

      // ปิด Loading
      if (mounted) Navigator.pop(context);

      // 4. แจ้งเตือนสำเร็จและกลับไปหน้า Sign In
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully! Please Sign In."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }

    } on FirebaseAuthException catch (e) {
      // ปิด Loading
      if (mounted) Navigator.pop(context);

      // จัดการ Error Message จาก Firebase
      String message = "Registration failed";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }

      _showErrorSnackBar(message);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackBar("An error occurred: $e");
    }
  }

  // ฟังก์ชันช่วยแสดง Error
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: MyConstant.h1Style().copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text("Sign up to get started!", style: MyConstant.bodyStyle()),
              const SizedBox(height: 40),

              // ช่อง Full Name
              _buildTextField("Full Name", Icons.person_outline, controller: nameCtrl),
              const SizedBox(height: 20),
              
              // ช่อง Email
              _buildTextField("Email", Icons.email_outlined, controller: emailCtrl),
              const SizedBox(height: 20),

              // ช่อง Password
              _buildPasswordField(
                label: "Password",
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                controller: passwordCtrl,
                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 20),

              // ช่อง Confirm Password
              _buildPasswordField(
                label: "Confirm Password",
                icon: Icons.lock_reset,
                obscureText: _obscureConfirmPassword,
                controller: confirmPasswordCtrl,
                onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),

              const SizedBox(height: 30),

              // ปุ่ม Sign Up (Gradient)
              _buildGradientButton(context, "Sign Up", signup),

              const SizedBox(height: 30),
              
              // ลิงก์กลับไปหน้า Sign In
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: MyConstant.grey),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: MyConstant.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget: TextField ทั่วไป
  Widget _buildTextField(String label, IconData icon, {required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: MyConstant.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: MyConstant.primary, width: 2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Widget: TextField รหัสผ่าน
  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggle,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: MyConstant.primary),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: MyConstant.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: MyConstant.primary, width: 2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Widget: ปุ่ม Gradient
  Widget _buildGradientButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MyConstant.secondary, MyConstant.primary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: MyConstant.primary.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}