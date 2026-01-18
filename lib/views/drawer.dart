import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      backgroundColor: Colors.white,
      width: 300.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20.0)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Tasneem Alasbahi'),
            accountEmail: const Text('+967 77 483 2386'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/TasneemPic.jpeg'),
            ),
            decoration: const BoxDecoration(color: Color.fromARGB(255, 79, 145, 169)),
          ),
          
          // استخدام .tr لضمان الترجمة التلقائية عند تغيير اللغة
          _item(Icons.person, 'profile'.tr, () => Get.back()),
          const Divider(),
          _item(Icons.group, 'new_group'.tr, () => Get.back()),
          _item(Icons.person_outline, 'contacts'.tr, () => Get.back()),
          
          _item(Icons.person_add_outlined, 'add_user'.tr, () {
            Get.back();
            Get.toNamed('/adduser'); 
          }),
          
          _item(Icons.call, 'calls'.tr, () => Get.back()),
          _item(Icons.bookmark_border, 'saved_messages'.tr, () => Get.back()),
          _item(Icons.settings, 'settings'.tr, () => Get.back()),
          
          // زر تبديل اللغة
          _item(Icons.language, Get.locale?.languageCode == 'ar' ? 'English' : 'العربية', () {
            if (Get.locale?.languageCode == 'ar') {
              Get.updateLocale(const Locale('en', 'US'));
            } else {
              Get.updateLocale(const Locale('ar', 'SA'));
            }
            // لا نحتاج لإغلاق الدرور هنا إذا أردتِ رؤية التأثير فوراً، أو اتركيه حسب رغبتك
            Get.back(); 
          }),
          
          const Divider(),
          _item(Icons.exit_to_app, 'exit'.tr, () => Get.back(), color: Colors.red),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap, {Color color = Colors.blue}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title), // النص هنا سيستلم القيمة المترجمة
      onTap: onTap,
    );
  }
}