import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constant/my_constant.dart';
import 'signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotiEnabled = true;
  bool _isPromoEnabled = false;

  Future<void> _signOut() async {
    // ... (Logic เดิม) ...
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign Out", style: MyConstant.h2Style()),
        content: Text("Are you sure you want to sign out?", style: MyConstant.bodyStyle()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel", style: MyConstant.bodyStyle().copyWith(color: MyConstant.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Sign Out", style: MyConstant.bodyStyle().copyWith(color: MyConstant.danger))),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Traveler';
    final email = user?.email ?? 'bp.onuma@gmail.com';

    return Scaffold(
      backgroundColor: MyConstant.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Profile", style: MyConstant.h1Style().copyWith(fontSize: 24)), // ใช้ h1
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const CircleAvatar(radius: 35.0, backgroundImage: AssetImage('lib/images/head_rabbit.jpg')),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: MyConstant.h2Style()), // ใช้ h2
                        Text(email, style: MyConstant.smallStyle().copyWith(fontSize: 16)), // ใช้ small ปรับไซส์
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF003580), borderRadius: BorderRadius.circular(4)),
                          child: const Text("Genius Level 1", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: MyConstant.primary)),
                ],
              ),
            ),

            _buildSectionLayout(icon: Icons.person_outline, title: "Manage Account", children: [
              _buildListTileMenu(title: "Personal Details", subtitle: "Passport, Name, Address"),
              _buildListTileMenu(title: "Payment Methods", subtitle: "Visa **42"),
              _buildListTileMenu(title: "Email Notifications", subtitle: "Booking confirmations"),
            ]),

            _buildSectionLayout(icon: Icons.settings_outlined, title: "Settings", children: [
              _buildListTileMenu(title: "Currency", subtitle: "USD (\$)", trailing: Text("USD", style: MyConstant.bodyStyle().copyWith(color: MyConstant.primary, fontWeight: FontWeight.bold))),
              _buildListTileMenu(title: "Language", subtitle: "English (US)", trailing: Text("English", style: MyConstant.bodyStyle().copyWith(color: MyConstant.primary, fontWeight: FontWeight.bold))),
              _buildNotificationItem(title: "Price Alerts", subtitle: "Get notified when prices drop", value: _isNotiEnabled, onChanged: (val) => setState(() => _isNotiEnabled = val)),
              _buildNotificationItem(title: "Special Offers", subtitle: "Receive exclusive deals", value: _isPromoEnabled, onChanged: (val) => setState(() => _isPromoEnabled = val)),
            ]),

            _buildSectionLayout(icon: Icons.headset_mic_outlined, title: "Support", children: [
              _buildListTileMenu(title: "Contact Customer Service", subtitle: "24/7 Support"),
              _buildListTileMenu(title: "Safety Resource Center", subtitle: "Travel advice"),
              _buildListTileMenu(title: "Legal & Privacy", subtitle: "Terms of service"),
            ]),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _signOut,
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0), side: const BorderSide(color: Color(0xFFE74C3C), width: 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                  child: Text("Sign Out", style: MyConstant.bodyStyle().copyWith(color: const Color(0xFFE74C3C), fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLayout({required IconData icon, required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: MyConstant.primary, size: 26),
                  const SizedBox(width: 12.0),
                  Text(title, style: MyConstant.h2Style().copyWith(fontSize: 18)), // ใช้ h2 ปรับไซส์
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTileMenu({required String title, required String subtitle, Widget? trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: MyConstant.bodyStyle().copyWith(fontWeight: FontWeight.w600)), // ใช้ body หนา
      subtitle: Text(subtitle, style: MyConstant.smallStyle()), // ใช้ small
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: MyConstant.grey, size: 14),
      onTap: () {},
    );
  }

  Widget _buildNotificationItem({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: MyConstant.bodyStyle().copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: MyConstant.smallStyle()),
      value: value,
      onChanged: onChanged,
      activeColor: MyConstant.primary,
    );
  }
}