import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawer.dart'; // تأكدي أن الملف اسمه drawer.dart

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // درجة اللون الدقيقة من صورتك (RGB: 79, 145, 169)
    const myCustomColor = Color.fromARGB(255, 78, 150, 194);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // استخدام المفتاح للترجمة مع الحفاظ على النص
        title: Text('Telegram'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),), 
        backgroundColor: myCustomColor,
        iconTheme: IconThemeData(color: Colors.white), // لونكِ المفضل
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // استدعاء الـ Drawer الذي عدلناه سوياً
      drawer: const MyDrawer(),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة بسيطة في المنتصف مثل التليجرام
            Icon(
              Icons.send_rounded,
              size: 80,
              color: myCustomColor,
            ),
          ],
        ),
      ),

      // الزر العائم بنفس لونكِ الأصلي
      floatingActionButton: FloatingActionButton(
        backgroundColor: myCustomColor,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Get.toNamed('/adduser'); 
        },
      ),
    );
  }
}