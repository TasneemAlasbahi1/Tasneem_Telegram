import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط الصفحة بالـ Controller
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        // استخدام اللغات ( .tr )
        title: Text('login'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: const Color.fromARGB(255, 78, 150, 194),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر لتغيير اللغة للتجربة
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (Get.locale?.languageCode == 'ar') {
                Get.updateLocale(const Locale('en'));
              } else {
                Get.updateLocale(const Locale('ar'));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: "email".tr, // ترجمة الكلمة
                prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 78, 150, 194)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "pass".tr, // ترجمة الكلمة
                prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 78, 150, 194)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 78, 150, 194)),
              onPressed: () => controller.login(), // استدعاء الدالة من الـ Controller
              child: Text("login".tr, style: const TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'), // الانتقال لصفحة التسجيل
              child: Text("register".tr, style: const TextStyle(color: Color.fromARGB(255, 78, 150, 194))),
            ),
          ],
        ),
      ),
    );
  }
}