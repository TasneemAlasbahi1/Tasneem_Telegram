import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  
  // تعريف اللون الأساسي للتطبيق لاستخدامه في النصوص والمؤشر
  final Color mainColor = const Color.fromARGB(255, 78, 150, 194);

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      bool isLoggedIn = box.read('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء كما طلبتِ
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة التليجرام
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Telegram_blue_icon.png',
                  width: 140, // تكبير الأيقونة قليلاً لتتناسب مع النص الكبير
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // كلمة Telegram كبيرة وباللون المطلوب
            Text(
              "Telegram",
              style: TextStyle(
                fontSize: 40, // حجم كبير وواضح
                color: mainColor, // اللون المعتمد في التطبيق
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // مؤشر التحميل بنفس لون التطبيق ليتناسق مع التصميم
            CircularProgressIndicator(
              color: mainColor,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}