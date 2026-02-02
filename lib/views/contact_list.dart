import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/user_controller.dart';

class ContactsListView extends StatelessWidget {
  const ContactsListView({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الكنترولر الذي يحتوي على قائمة المستخدمين من SQL
    final UserController userController = Get.find<UserController>();
    const myCustomColor = Color.fromARGB(255, 78, 150, 194);

    return Scaffold(
      appBar: AppBar(
       backgroundColor: myCustomColor,
       //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "contacts".tr, // ترجمة كلمة جهات الاتصال
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // إذا كانت القائمة فارغة
        if (userController.users.isEmpty) {
          return const Center(child: Text("لا توجد جهات اتصال بعد"));
        }

        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            var user = userController.users[index];
            String userName = user['name'] ?? 'Unknown';
            String imagePath = user['image'] ?? '';

            return ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: myCustomColor,
                backgroundImage: (imagePath.isNotEmpty && File(imagePath).existsSync()) 
                    ? FileImage(File(imagePath)) : null,
                child: (imagePath.isEmpty || !File(imagePath).existsSync()) 
                    ? Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.white)) 
                    : null,
              ),
              title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user['phone'] ?? ''),
              onTap: () {
                // أهم جزء: عند الضغط يغلق الصفحة الحالية ويفتح الشات مع الشخص المختار
                Get.back(); // العودة للخلف (إغلاق قائمة جهات الاتصال)
                Get.toNamed('/chat', arguments: userName); // فتح واجهة المحادثة
              },
            );
          },
        );
      }),
    );
  }
}