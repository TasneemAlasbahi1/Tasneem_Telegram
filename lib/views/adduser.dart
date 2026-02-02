import 'package:flutter/material.dart';
import 'package:flutter_application_16/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'dart:io';

class Adduser extends StatelessWidget {
  const Adduser({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    
    final int? userId = Get.arguments is int ? Get.arguments : null;
    final bool isEditMode = userId != null;

    // الحصول على لون النص المناسب للثيم الحالي (أبيض في الليلي وأسود في الفاتح)
    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // تلوين زر الرجوع تلقائياً
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearFields();
            Get.back();
          },
        ),
        title: Text(
          isEditMode ? "edit".tr : "add_user".tr, 
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // اختيار الصورة
            Obx(() => GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: controller.selectedImagePath.value.isNotEmpty
                        ? FileImage(File(controller.selectedImagePath.value))
                        : null,
                    child: controller.selectedImagePath.value.isEmpty
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                )),
            const SizedBox(height: 30),
            
            // حقل الاسم الأول
            TextField(
              controller: controller.firstNameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "first_name".tr, 
                labelStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            
            // حقل الاسم الأخير
            TextField(
              controller: controller.lastNameController,
              style: TextStyle(color: textColor),
              decoration:  InputDecoration(
                labelText: "last_name".tr, 
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            
            // حقل الهاتف
            TextField(
              controller: controller.phoneController,
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("🇾🇪 +967", style: TextStyle(fontSize: 16, color: textColor)),
                ),
                labelText: "phone".tr, 
                labelStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 78, 150, 194),
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () {
          if (isEditMode) {
            controller.updateUser(userId!);
          } else {
            controller.addUser();
          }

          // رسالة نجاح (Snackbar) تظهر بلون أخضر وباللغة الصحيحة
          Get.snackbar(
            "ok".tr, 
            "success_update".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
            margin: const EdgeInsets.all(15),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        },
      ),
    );
  }
}