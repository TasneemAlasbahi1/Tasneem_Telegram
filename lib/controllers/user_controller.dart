import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  var users = <String>[].obs;
  var nameController = TextEditingController();
  final box = GetStorage(); // أداة الحفظ

  @override
  void onInit() {
    super.onInit();
    // استرجاع القائمة المحفوظة عند فتح التطبيق
    List? storedUsers = box.read<List>('myUsers');
    if (storedUsers != null) {
      users.assignAll(storedUsers.cast<String>());
    }
    
    // حفظ القائمة تلقائياً فور حدوث أي تغيير (إضافة/حذف)
    ever(users, (_) => box.write('myUsers', users.toList()));
  }

  void addUser() {
    if (nameController.text.trim().isNotEmpty) {
      users.add(nameController.text.trim());
      nameController.clear();
    }
  }

  void deleteUser(int index) => users.removeAt(index);
  
  void editUser(int index) {
    if (nameController.text.isNotEmpty) {
      users[index] = nameController.text;
      nameController.clear();
    }
  }
}