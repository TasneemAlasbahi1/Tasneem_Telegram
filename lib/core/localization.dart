import 'package:get/get.dart';

class MyLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': {
      'title': 'تليجرام',
      'login': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'pass': 'كلمة المرور',
      'register': 'إنشاء حساب جديد',


      'profile': 'الملف الشخصي',
      'new_group': 'مجموعة جديدة',
      'contacts': 'جهات الاتصال',
      'add_user': 'إضافة مستخدم',
      'calls': 'المكالمات',
      'saved_messages': 'الرسائل المحفوظة',
      'settings': 'الإعدادات',
      'exit': 'خروج',
    },
    'en': {
      'title': 'Telegram',
      'login': 'Login',
      'email': 'Email',
      'pass': 'Password',
      'register': 'Create new account',

      'profile': 'My Profile',
      'new_group': 'New Group',
      'contacts': 'Contacts',
      'add_user': 'Add user',
      'calls': 'Calls',
      'saved_messages': 'Saved Messages',
      'settings': 'Settings',
      'exit': 'Exit',



    },
  };
}