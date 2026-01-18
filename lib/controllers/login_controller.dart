import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // تعريف وحدات التحكم بالنصوص
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // دالة تسجيل الدخول
  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // الانتقال لصفحة الهوم باستخدام GetX
      Get.offNamed('/home'); 
    } else {
      Get.snackbar(
        "تنبيه", 
        "يرجى ملء الحقول",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}