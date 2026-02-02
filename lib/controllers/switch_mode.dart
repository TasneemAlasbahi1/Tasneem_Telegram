import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // قراءة الحالة المحفوظة أو اعتماد الوضع الفاتح كافتراضي
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    isDarkMode.value = _loadTheme();
    super.onInit();
  }

  bool _loadTheme() => _box.read(_key) ?? false;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _box.write(_key, isDarkMode.value);
  }
}