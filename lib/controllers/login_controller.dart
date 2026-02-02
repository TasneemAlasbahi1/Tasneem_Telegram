import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/database_helper.dart'; // تأكدي أن المسار يؤدي لملف الهيلبر

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); 
  
  final box = GetStorage();
  final dbHelper = DatabaseHelper(); // هذا السطر سيحل مشكلة الخط الأحمر تحت dbHelper

  void register() async {
    String email = emailController.text.trim();
    String pass = passwordController.text.trim(); // تأكدي من تسمية المتغير pass
    String name = nameController.text.trim();

    if (email.isNotEmpty && pass.isNotEmpty) {
      final db = await dbHelper.db;
      try {
        await db.insert('auth_users', {
          'email': email,
          'password': pass, // استخدام المتغير الصحيح
          'name': name,
        });
        Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
        Get.offNamed('/login');
      } catch (e) {
        Get.snackbar("خطأ", "البريد مسجل مسبقاً أو حدث خطأ في القاعدة");
      }
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();

    final db = await dbHelper.db;
    List<Map<String, dynamic>> user = await db.query(
      'auth_users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, pass],
    );

    if (user.isNotEmpty) {
      box.write('isLoggedIn', true);
      box.write('myName', user[0]['name']); 
      Get.offAllNamed('/home');
    } else {
      Get.snackbar("فشل", "البيانات غير صحيحة");
    }
  }
}