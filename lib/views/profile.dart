import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/profile_controller.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController pController = Get.find<ProfileController>();
    
    // تعريف الكنترولرز بدون قيم ابتدائية في الأقواس
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    // نستخدم دالة لمرة واحدة لملء الحقول لضمان عدم مسح ما يكتبه المستخدم
    nameCtrl.text = pController.myName.value;
    phoneCtrl.text = pController.myPhone.value;
    
    var tempPath = pController.myImagePath.value.obs;
    const mainColor = Color.fromARGB(255, 78, 150, 194);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: Text("profile".tr, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(color: mainColor),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (img != null) tempPath.value = img.path;
                        },
                        child: Obx(() => CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 61,
                            backgroundImage: tempPath.value.isNotEmpty 
                                ? FileImage(File(tempPath.value)) 
                                : const AssetImage('assets/images/TasneemPic.jpeg') as ImageProvider,
                          ),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: mainColor, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Obx(() => Text(
                    pController.myName.value,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // التعديل الجوهري: ربط الحقل بالكنترولر
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: mainColor),
                      labelText: "username".tr, 
                      // إضافة hint للتأكد إذا كان الحقل فارغاً فعلاً
                      hintText: pController.myName.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: mainColor),
                      labelText: "phone".tr,
                      hintText: pController.myPhone.value,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // تحديث البيانات
                  pController.updateProfile(nameCtrl.text, phoneCtrl.text, tempPath.value);
                  Get.back(); 
                  Get.snackbar(
                    "ok".tr, 
                    "success_update".tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.7),
                    colorText: Colors.white,
                  );
                },
                child: Text("save_changes".tr, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}