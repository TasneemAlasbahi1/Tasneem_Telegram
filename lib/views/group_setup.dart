import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart'; // تأكدي من استيراد الكنترولر

class GroupSetupView extends StatelessWidget {
  final List<Map<String, dynamic>> selectedMembers;
  GroupSetupView({super.key, required this.selectedMembers});

  final TextEditingController groupNameController = TextEditingController();
  final RxString groupImagePath = ''.obs;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) groupImagePath.value = pickedFile.path;
  }

  @override
  Widget build(BuildContext context) {
    const myColor = Color.fromARGB(255, 78, 150, 194);
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    // استدعاء الكنترولر للوصول لدالة الحفظ
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("new_group".tr, style: const TextStyle(color: Colors.white)),
        backgroundColor: myColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Obx(() => CircleAvatar(
                    radius: 35,
                    backgroundColor: myColor.withOpacity(0.2),
                    backgroundImage: groupImagePath.value.isNotEmpty
                        ? FileImage(File(groupImagePath.value)) : null,
                    child: groupImagePath.value.isEmpty
                        ? const Icon(Icons.camera_alt, size: 30, color: myColor) : null,
                  )),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: groupNameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "group_name_hint".tr, // أضيفي هذا المفتاح في الترجمة "اسم المجموعة..."
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: myColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("members".tr, style: const TextStyle(color: myColor, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedMembers.length,
              itemBuilder: (context, index) {
                var member = selectedMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (member['image'] != null && File(member['image']).existsSync())
                        ? FileImage(File(member['image'])) : null,
                    child: (member['image'] == null || member['image'] == '') 
                        ? Text(member['name'][0]) : null,
                  ),
                  title: Text(member['name'], style: TextStyle(color: textColor)),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColor,
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () {
          String name = groupNameController.text.trim();
          if (name.isEmpty) {
            Get.snackbar("error".tr, "type_message".tr, 
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          } else {
            // استدعاء دالة الحفظ في قاعدة البيانات من الـ UserController
            userController.addGroup(
              name, 
              groupImagePath.value, 
              selectedMembers
            );
          }
        },
      ),
    );
  }
}