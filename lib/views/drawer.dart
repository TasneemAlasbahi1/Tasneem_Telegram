import 'package:flutter/material.dart';
import 'package:flutter_application_16/views/contact_list.dart';
import 'package:flutter_application_16/views/new_group_select.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/switch_mode.dart'; 

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // التعديل هنا: استخدمنا put بدلاً من find لضمان عدم ظهور الخطأ الأحمر
    final themeController = Get.put(ThemeController());

    return Drawer(
      elevation: 16.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      width: 300.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20.0)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Obx(() => UserAccountsDrawerHeader(
            accountName: const Text('Tasneem Alasbahi'),
            accountEmail: const Text('+967 77 483 2386'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/TasneemPic.jpeg'),
            ),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(
                  themeController.isDarkMode.value 
                      ? Icons.wb_sunny_rounded 
                      : Icons.nightlight_round, 
                  color: Colors.white,
                ),
                onPressed: () {
                  themeController.toggleTheme(); 
                },
              ),
            ],
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 79, 145, 169),
            ),
          )),
          
          _item(Icons.person_outline, 'profile'.tr, () {
            Get.back();
            Get.toNamed('/profile');
          }),
          const Divider(),
          _item(Icons.group, 'new_group'.tr, () {
            Get.back();
            Get.to(() => const NewGroupSelectView());
          }),
          _item(Icons.person_outline, 'contacts'.tr, () {
            Get.back();
            Get.to(() => const ContactsListView());
          }),
          
          _item(Icons.person_add_outlined, 'add_user'.tr, () {
            Get.back();
            Get.toNamed('/adduser'); 
          }),
          
          _item(Icons.call, 'calls'.tr, () => Get.back()),
          _item(Icons.bookmark_border, 'saved_messages'.tr, () {
            Get.back();
            Get.toNamed('/chat', arguments: 'saved_messages'.tr); 
          }),
          _item(Icons.settings, 'settings'.tr, () {
            Get.back();
            Get.toNamed('/settings');
          }),
          
          _item(Icons.language, Get.locale?.languageCode == 'ar' ? 'English' : 'العربية', () {
            if (Get.locale?.languageCode == 'ar') {
              Get.updateLocale(const Locale('en', 'US'));
            } else {
              Get.updateLocale(const Locale('ar', 'SA'));
            }
            Get.back(); 
          }),
          
          const Divider(),
          _item(Icons.exit_to_app, 'exit'.tr, (){ 
            GetStorage().write('isLoggedIn', false);
            Get.offAllNamed('/login');
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap, {Color color = Colors.blue}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }
}