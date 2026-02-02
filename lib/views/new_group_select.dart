import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/user_controller.dart';
import 'group_setup.dart';

class NewGroupSelectView extends StatefulWidget {
  const NewGroupSelectView({super.key});

  @override
  State<NewGroupSelectView> createState() => _NewGroupSelectViewState();
}

class _NewGroupSelectViewState extends State<NewGroupSelectView> {
  final UserController userController = Get.find();
  final RxList<Map<String, dynamic>> selectedUsers = <Map<String, dynamic>>[].obs;

  @override
  Widget build(BuildContext context) {
    const myColor = Color.fromARGB(255, 78, 150, 194);
    final bool isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: myColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "new_group".tr,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => Text(
                  "${selectedUsers.length} of ${userController.users.length} selected",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                )),
          ],
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: userController.users.length,
            itemBuilder: (context, index) {
              var user = userController.users[index];
              return Obx(() {
                bool isSelected = selectedUsers.contains(user);
                return ListTile(
                  onTap: () {
                    isSelected ? selectedUsers.remove(user) : selectedUsers.add(user);
                  },
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: myColor.withOpacity(0.1),
                        backgroundImage: (user['image'] != null && File(user['image']).existsSync())
                            ? FileImage(File(user['image'])) : null,
                        child: (user['image'] == null)
                            ? Text(user['name'][0], style: const TextStyle(color: myColor)) : null,
                      ),
                      if (isSelected)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: myColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    user['name'],
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                  ),
                  trailing: isSelected 
                    ? const Icon(Icons.check_circle, color: myColor) 
                    : Icon(Icons.circle_outlined, color: Colors.grey.withOpacity(0.3)),
                );
              });
            },
          )),
      floatingActionButton: Obx(() => selectedUsers.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: myColor,
              child: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () => Get.to(() => GroupSetupView(selectedMembers: selectedUsers.toList())),
            )
          : const SizedBox()),
    );
  }
}