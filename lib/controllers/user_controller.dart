import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/database_helper.dart'; 

class UserController extends GetxController {
  var users = <Map<String, dynamic>>[].obs; 
  var filteredUsers = <Map<String, dynamic>>[].obs; 
  var isSearching = false.obs;

  final box = GetStorage();
  final dbHelper = DatabaseHelper(); 

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  var selectedImagePath = ''.obs; 

  var myName = "".obs;
  var myPhone = "".obs;
  var myImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    refreshUsers();   
    loadMyProfile();  
  }

  // 🔥 الدالة السحرية للآيفون: تعيد المسار الحالي للملف مهما تغير مجلد التطبيق
  Future<String> getCorrectPath(String? imageField) async {
    if (imageField == null || imageField.isEmpty) return '';
    
    // إذا كان المسار القديم مخزناً كاملاً، نأخذ منه اسم الملف فقط
    String fileName = imageField.contains('/') ? imageField.split('/').last : imageField;
    
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  void refreshUsers() async {
    final db = await dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('users', orderBy: 'id DESC');
    users.assignAll(maps);
    filteredUsers.assignAll(maps);
  }

  // تعديل الإضافة: نحفظ اسم الملف فقط
  void addUser() async {
    String first = firstNameController.text.trim();
    if (first.isNotEmpty) {
      String fileName = await saveImagePermanently(selectedImagePath.value);

      final db = await dbHelper.db;
      await db.insert('users', {
        'name': "$first ${lastNameController.text.trim()}".trim(),
        'phone': phoneController.text.trim(),
        'image': fileName, // تخزين اسم الملف فقط
        'last_msg': 'no_messages'.tr 
      });
      
      refreshUsers();
      clearFields();
      Get.back();
    }
  }

  // تعديل التحديث: نحفظ اسم الملف الجديد فقط
  void updateUser(int id) async {
    try {
      final db = await dbHelper.db;
      String fileName = await saveImagePermanently(selectedImagePath.value);

      await db.update('users', {
        'name': "${firstNameController.text} ${lastNameController.text}".trim(),
        'phone': phoneController.text,
        'image': fileName, 
      }, where: 'id = ?', whereArgs: [id]);
      
      refreshUsers();
      clearFields();
      Get.back();
    } catch (e) { print("Update Error: $e"); }
  }

  // تعديل حفظ المجموعات
  void addGroup(String groupName, String imagePath, List<Map<String, dynamic>> members) async {
    try {
      String fileName = await saveImagePermanently(imagePath);
      final db = await dbHelper.db;

      await db.insert('users', {
        'name': groupName, 'phone': 'Group', 'image': fileName,
        'last_msg': '${members.length} members'
      });

      int groupId = await db.insert('groups', {
        'group_name': groupName, 'group_image': fileName,
      });

      for (var member in members) {
        if (member['id'] != null) {
          await db.insert('group_members', {'group_id': groupId, 'user_id': member['id']});
        }
      }
      refreshUsers(); 
      Get.offAllNamed('/home'); 
    } catch (e) { print(e); }
  }

  // دالة الحفظ: أصبحت تعيد "اسم الملف" فقط
  Future<String> saveImagePermanently(String imagePath) async {
    if (imagePath.isEmpty || imageFieldIsAlreadyFileName(imagePath)) return imagePath;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.png';
      final permanentPath = '${directory.path}/$fileName';
      
      await File(imagePath).copy(permanentPath);
      return fileName; // نرجع اسم الملف
    } catch (e) { return ''; }
  }

  bool imageFieldIsAlreadyFileName(String path) => !path.contains('/');

  // باقي الدوال كما هي...
  void deleteUser(int id) async {
    final db = await dbHelper.db;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    refreshUsers();
  }

  void updateLastMessage(String name, String lastMsg) async {
    final db = await dbHelper.db;
    await db.update('users', {'last_msg': lastMsg}, where: 'name = ?', whereArgs: [name.trim()]);
    refreshUsers(); 
  }

  void filterSearch(String query) {
    if (query.isEmpty) { filteredUsers.assignAll(users); } 
    else { filteredUsers.assignAll(users.where((u) => u['name'].toString().toLowerCase().contains(query.toLowerCase())).toList()); }
  }

  void loadMyProfile() {
    myName.value = box.read('myName') ?? "User";
    myPhone.value = box.read('myPhone') ?? "";
    myImagePath.value = box.read('myImagePath') ?? "";
  }

  void updateMyProfile(String name, String phone, String path) async {
    String fileName = await saveImagePermanently(path);
    box.write('myName', name); box.write('myPhone', phone); box.write('myImagePath', fileName);
    loadMyProfile();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImagePath.value = image.path;
  }

  void clearFields() {
    firstNameController.clear(); lastNameController.clear();
    phoneController.clear(); selectedImagePath.value = '';
  }

  void addMemberToGroup(int groupId, int userId) async {
    final db = await dbHelper.db;
    await db.insert('group_members', {'group_id': groupId, 'user_id': userId});
    refreshUsers();
  }

  Future<List<Map<String, dynamic>>> getGroupMembers(String groupName) async {
    final db = await dbHelper.db;
    final res = await db.query('groups', where: 'group_name = ?', whereArgs: [groupName], limit: 1);
    if (res.isNotEmpty) {
      return await db.rawQuery('SELECT users.* FROM users JOIN group_members ON users.id = group_members.user_id WHERE group_members.group_id = ?', [res.first['id']]);
    }
    return [];
  }
}