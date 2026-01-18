import 'package:flutter/material.dart';
import 'package:get/get.dart';

// تأكدي من حرف الـ C الكبير هنا
class ChatController extends GetxController {
  // قائمة الرسائل
  var messages = <String>[].obs;
  
  // التحكم بحقل النص
  var textController = TextEditingController();

  // دالة الإرسال
  void sendMessage() {
    if (textController.text.isNotEmpty) {
      messages.add(textController.text);
      textController.clear(); // لمسح الحقل بعد الإرسال
    }
  }

  @override
  void onClose() {
    textController.dispose(); // لإغلاق الـ controller عند الخروج من الصفحة
    super.onClose();
  }
}