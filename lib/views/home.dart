import 'package:flutter/material.dart';
import 'package:flutter_application_16/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'drawer.dart'; 
import 'dart:io';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر باستخدام Get.find
    final UserController userController = Get.find<UserController>();
    final TextEditingController searchController = TextEditingController();
    const myCustomColor = Color.fromARGB(255, 78, 150, 194);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Obx(() => userController.isSearching.value
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => userController.filterSearch(value),
              )
            : Text(
                'Telegram'.tr, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
              )),
        backgroundColor: myCustomColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Obx(() => IconButton(
                icon: Icon(userController.isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  if (userController.isSearching.value) {
                    searchController.clear();
                    userController.filterSearch("");
                    userController.isSearching.value = false;
                  } else {
                    userController.isSearching.value = true;
                  }
                },
              )),
        ],
      ),
      drawer: const MyDrawer(),
      body: Obx(() {
        var displayList = userController.isSearching.value 
            ? userController.filteredUsers 
            : userController.users;

        if (displayList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, size: 80, color: Colors.grey),
                const SizedBox(height: 10),
                Text("no_chats".tr, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            var user = displayList[index];
            int id = user['id'];
            String userName = user['name'] ?? 'Unknown';
            String imageField = user['image'] ?? ''; 
            String phoneNumber = user['phone'] ?? '';
            
            // --- تعديل منطق الترجمة الشامل ليعالج النص العربي القديم والمفتاح الإنجليزي ---
            String rawLastMsg = user['last_msg'] ?? '';
            String lastMessage;
            
            if (rawLastMsg == 'no_messages' || 
                rawLastMsg == 'لا توجد رسائل' || 
                rawLastMsg == 'لا توجد رسائل بعد' || 
                rawLastMsg.isEmpty) {
              lastMessage = 'no_messages'.tr;
            } else {
              lastMessage = rawLastMsg;
            }

            return ListTile(
              leading: FutureBuilder<String>(
                future: userController.getCorrectPath(imageField),
                builder: (context, snapshot) {
                  String fullPath = snapshot.data ?? '';
                  bool exists = fullPath.isNotEmpty && File(fullPath).existsSync();

                  return CircleAvatar(
                    radius: 25,
                    backgroundColor: myCustomColor,
                    backgroundImage: exists ? FileImage(File(fullPath)) : null,
                    child: !exists 
                        ? Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.white)) 
                        : null,
                  );
                },
              ),
              title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                lastMessage, 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              onTap: () {
                Get.toNamed('/chat', arguments: userName);
              },
              onLongPress: () {
                _showOptionsBottomSheet(context, userController, id, userName, phoneNumber, imageField);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myCustomColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          userController.clearFields();
          Get.toNamed('/adduser', arguments: null); 
        },
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, UserController controller, int id, String name, String phone, String image) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            const Center(child: Icon(Icons.drag_handle, color: Colors.grey)),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text("edit".tr),
              onTap: () {
                Get.back();
                controller.firstNameController.text = name; 
                controller.phoneController.text = phone;
                controller.selectedImagePath.value = image;
                Get.toNamed('/adduser', arguments: id); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text("delete".tr),
              onTap: () {
                Get.back();
                Get.defaultDialog(
                  title: "confirm_delete".tr,
                  middleText: "are_you_sure".tr,
                  textConfirm: "delete".tr,
                  textCancel: "cancel".tr,
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    controller.deleteUser(id);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}