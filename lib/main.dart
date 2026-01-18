import 'package:flutter/material.dart';
import 'package:flutter_application_16/views/adduser.dart';
import 'package:flutter_application_16/views/chat.dart';
import 'package:flutter_application_16/views/home.dart';
import 'package:flutter_application_16/views/login.dart';
import 'package:flutter_application_16/views/register.dart';
import 'package:get/get.dart';
// استيراد الملفات (تأكدي من صحة المسارات حسب مجلداتك الجديدة)
import 'core/localization.dart'; 
import 'views/splash.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا GetMaterialApp بدلاً من MaterialApp لتفعيل ميزات GetX
    return GetMaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Telegram Clone',
  translations: MyLocalization(),
  locale: const Locale('ar'),
  fallbackLocale: const Locale('en'),
  
  // تعريف الصفحات هنا
  initialRoute: '/',
  getPages: [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/login', page: () => const Login()),
    GetPage(name: '/register', page: () => const Register()),
    GetPage(name: '/home', page: () => const HomePage()),
    GetPage(name: '/adduser', page: () => const Adduser()),
    GetPage(name: '/chat', page: () => const Mychat()),
  ],
);
  }
}