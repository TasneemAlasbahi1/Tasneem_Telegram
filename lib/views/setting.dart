import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/profile_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController pController = Get.find<ProfileController>();
    const telegramBlue = Color(0xFF5288A9); 

    return Scaffold(
      // التعديل 1: جعل الخلفية تتبع الثيم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            backgroundColor: telegramBlue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: pController.myImagePath.value.isNotEmpty
                          ? FileImage(File(pController.myImagePath.value))
                          : const AssetImage('assets/images/TasneemPic.jpeg') as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pController.myName.value,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "online".tr,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              )),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle(context, "account".tr),
              _buildSettingItem(context, Icons.phone_outlined, pController.myPhone.value, "tap_to_change".tr),
              _buildSettingItem(context, Icons.alternate_email, "@Tasneem_Alasbahi", "username".tr),
              _buildSettingItem(context, Icons.info_outline, "bio_text".tr, "bio".tr),

              const SizedBox(height: 10),
              
              _buildSectionTitle(context, "settings".tr),
              _buildSettingItem(context, Icons.chat_bubble_outline, "settings_chat".tr, null),
              _buildSettingItem(context, Icons.lock_outline, "settings_privacy".tr, null),
              _buildSettingItem(context, Icons.notifications_none, "settings_notif".tr, null),
              _buildSettingItem(context, Icons.pie_chart_outline, "settings_data".tr, null),
              _buildSettingItem(context, Icons.battery_charging_full, "settings_battery".tr, null),
              _buildSettingItem(context, Icons.folder_open, "settings_folders".tr, null),
              _buildSettingItem(context, Icons.devices, "settings_devices".tr, null),
              
              _buildSettingItem(
                context,
                Icons.language, 
                "settings_lang".tr, 
                "lang_name".tr,
                onTap: () {
                  Locale newLocale = Get.locale?.languageCode == 'ar' 
                      ? const Locale('en', 'US') 
                      : const Locale('ar', 'EG');
                  Get.updateLocale(newLocale);
                },
              ),

              const SizedBox(height: 10),

              _buildSectionTitle(context, "help".tr),
              _buildSettingItem(context, Icons.chat_bubble_outline, "ask_question".tr, null),
              _buildSettingItem(context, Icons.help_outline, "telegram_faq".tr, null),
              _buildSettingItem(context, Icons.security, "privacy_policy".tr, null),
              
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // التعديل 2: جعل عنوان القسم يتبع ثيم الكارد
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: Theme.of(context).cardColor, // يتغير آلياً بين الأبيض والأسود
      width: double.infinity,
      child: Text(title, style: const TextStyle(color: Color(0xFF5288A9), fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  // التعديل 3: جعل العناصر تتبع الثيم آلياً
  Widget _buildSettingItem(BuildContext context, IconData icon, String title, String? subtitle, {VoidCallback? onTap}) {
    return Container(
      color: Theme.of(context).cardColor, // السر هنا!
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.grey[600], size: 26),
            title: Text(title, style: TextStyle(
              fontSize: 16,
              // يضمن أن يكون النص أسود في الفاتح وأبيض في الغامق
              color: Theme.of(context).textTheme.bodyLarge?.color 
            )),
            subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)) : null,
            onTap: onTap ?? () {},
          ),
          const Divider(height: 1, indent: 70),
        ],
      ),
    );
  }
}