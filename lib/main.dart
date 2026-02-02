import 'package:flutter/material.dart';
import 'package:flutter_application_16/controllers/switch_mode.dart'; 
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// استيراد الشاشات
import 'package:flutter_application_16/views/home.dart';
import 'package:flutter_application_16/views/login.dart';
import 'package:flutter_application_16/views/register.dart';
import 'package:flutter_application_16/views/splash.dart';
import 'package:flutter_application_16/views/chat.dart';
import 'package:flutter_application_16/views/adduser.dart';
import 'package:flutter_application_16/views/setting.dart';
import 'package:flutter_application_16/views/profile.dart';
import 'package:flutter_application_16/views/new_group_select.dart';
import 'package:flutter_application_16/views/contact_list.dart';

// استيراد ملفات اللغة والكنترولر
import 'core/localization.dart'; 
import 'controllers/profile_controller.dart';
import 'controllers/user_controller.dart';

void main() async {
  // التأكد من تهيئة بيئة فلاتر قبل تشغيل أي شيء
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة مخزن البيانات المحلي
  await GetStorage.init();
  
  // تهيئة الكنترولرز الأساسية لتعمل في خلفية التطبيق
  Get.put(ThemeController()); 
  Get.put(ProfileController());
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء كنترولر الثيم للتحكم في الوضع الليلي/العادي
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasneem Chat',

      // إعدادات الثيم الفاتح
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 78, 150, 194),
        brightness: Brightness.light,
        useMaterial3: false, // لضمان ثبات الشكل كما صممتيه
      ),

      // إعدادات الثيم المظلم
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),

      // ربط حالة الثيم ببيانات الكنترولر المحفوظة
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

      // إعدادات اللغة والترجمة
      translations: MyLocalization(),
      locale: Get.deviceLocale ?? const Locale('ar'),
      fallbackLocale: const Locale('en', 'US'),
      
      // التعديل الجوهري: البداية دائماً من الـ Splash لتظهر علامتك التجارية
      initialRoute: '/', 
      
      getPages: [
        // تعريف المسارات (Routes) بوضوح
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/register', page: () => const Register()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/adduser', page: () => const Adduser()),
        GetPage(name: '/chat', page: () => const Mychat()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/new_group', page: () => const NewGroupSelectView()),
        GetPage(name: '/contacts', page: () => const ContactsListView()),
      ],
    ));
  }
}