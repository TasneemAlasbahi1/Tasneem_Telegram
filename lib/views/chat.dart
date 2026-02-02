import 'package:flutter/material.dart';
import 'package:flutter_application_16/controllers/user_controller.dart'; 
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'dart:io';

class Mychat extends StatelessWidget {
  const Mychat({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = Get.arguments ?? "user".tr;
    final ChatController chatController = Get.put(ChatController());
    chatController.initChat(userName); 
    final UserController userController = Get.find<UserController>();

    const Color primaryColor = Color.fromARGB(255, 78, 150, 194);
    const Color bubbleColor = Color.fromARGB(255, 128, 169, 195);

    final userMap = userController.users.firstWhereOrNull(
      (u) => u['name'] == userName
    );

    // --- الإضافات المطلوبة فقط ---
    bool isGroup = userMap != null && userMap['phone'] == 'Group';
    String imgPath = userMap != null ? (userMap['image'] ?? '') : '';
    String phone = userMap != null ? (userMap['phone'] ?? 'no_number'.tr) : 'no_number'.tr;

    // --- دالة إضافة عضو جديد (معدلة للمسار فقط) ---
    void _showAddMemberDialog(int groupId) {
      Get.defaultDialog(
        title: "إضافة للمجموعة",
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Obx(() => ListView.builder(
            itemCount: userController.users.length,
            itemBuilder: (context, index) {
              var user = userController.users[index];
              if (user['phone'] == 'Group') return const SizedBox();
              
              return ListTile(
                leading: FutureBuilder<String>(
                  future: userController.getCorrectPath(user['image']),
                  builder: (context, snapshot) {
                    String fullPath = snapshot.data ?? '';
                    bool exists = fullPath.isNotEmpty && File(fullPath).existsSync();
                    return CircleAvatar(
                      backgroundImage: exists ? FileImage(File(fullPath)) : null,
                      child: !exists ? const Icon(Icons.person) : null,
                    );
                  },
                ),
                title: Text(user['name']),
                onTap: () {
                  userController.addMemberToGroup(groupId, user['id']);
                  Get.back(); // إغلاق الديالوج
                  Get.back(); // إغلاق البوتوم شيت لتحديث القائمة
                },
              );
            },
          )),
        ),
      );
    }

    // وظيفة عرض الأعضاء (معدلة للمسار فقط)
    void _showGroupMembers() async {
      var members = await userController.getGroupMembers(userName);
      
      final db = await userController.dbHelper.db;
      var groupInfo = await db.query('groups', where: 'group_name = ?', whereArgs: [userName]);
      int? groupId = groupInfo.isNotEmpty ? groupInfo.first['id'] as int : null;

      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("members".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  if (groupId != null)
                    IconButton(
                      icon: const Icon(Icons.person_add, color: primaryColor),
                      onPressed: () => _showAddMemberDialog(groupId),
                    ),
                ],
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: FutureBuilder<String>(
                      future: userController.getCorrectPath(members[index]['image']),
                      builder: (context, snapshot) {
                        String fullPath = snapshot.data ?? '';
                        bool exists = fullPath.isNotEmpty && File(fullPath).existsSync();
                        return CircleAvatar(
                          backgroundImage: exists ? FileImage(File(fullPath)) : null,
                          child: !exists ? Text(members[index]['name'][0]) : null,
                        );
                      },
                    ),
                    title: Text(members[index]['name']),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    void _showMsgOptions(int index, String currentText) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['👍', '❤️', '😂', '🔥', '😢'].map((emoji) => InkWell(
                  onTap: () { chatController.addEmoji(index, emoji); Get.back(); },
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                )).toList(),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text("edit".tr), 
                onTap: () {
                  Get.back();
                  chatController.isEditing.value = true;
                  chatController.editingIndex.value = index;
                  chatController.textController.text = currentText;
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text("delete_msg".tr), 
                onTap: () { chatController.deleteMessage(index); Get.back(); },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: GestureDetector(
          onTap: () {
            if (isGroup) {
              _showGroupMembers();
            } else {
              Get.defaultDialog(
                title: userName,
                titleStyle: const TextStyle(color: primaryColor),
                content: FutureBuilder<String>(
                  future: userController.getCorrectPath(imgPath),
                  builder: (context, snapshot) {
                    String fullPath = snapshot.data ?? '';
                    bool exists = fullPath.isNotEmpty && File(fullPath).existsSync();
                    return Column(
                      children: [
                        if (exists) 
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10), 
                            child: Image.file(File(fullPath), height: 150, width: 150, fit: BoxFit.cover)
                          )
                        else 
                          const Icon(Icons.person, size: 80, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text("${'phone'.tr}: $phone"), 
                      ],
                    );
                  }
                ),
                confirm: TextButton(onPressed: () => Get.back(), child: Text("ok".tr)),
              );
            }
          },
          child: Row(
            children: [
              FutureBuilder<String>(
                future: userController.getCorrectPath(imgPath),
                builder: (context, snapshot) {
                  String fullPath = snapshot.data ?? '';
                  bool exists = fullPath.isNotEmpty && File(fullPath).existsSync();
                  return CircleAvatar(
                    backgroundColor: Colors.white24,
                    backgroundImage: exists ? FileImage(File(fullPath)) : null,
                    child: !exists 
                        ? (isGroup ? const Icon(Icons.groups, color: Colors.white) : Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.white))) 
                        : null,
                  );
                }
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    isGroup 
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                          future: userController.getGroupMembers(userName),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String names = snapshot.data!.map((e) => e['name'].toString().split(' ')[0]).join(', ');
                              return Text(names, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis);
                            }
                            return const Text("...", style: TextStyle(color: Colors.white70, fontSize: 11));
                          },
                        )
                      : Text('online'.tr, style: const TextStyle(color: Colors.white70, fontSize: 11)), 
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'block') {
                if (userMap != null) {
                  userController.deleteUser(userMap['id']);
                  Get.back();
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'block', 
                child: Text(isGroup ? "block_group".tr : "block_user".tr, style: const TextStyle(color: Colors.red)) 
              )
            ],
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: chatController.messages.length,
                itemBuilder: (context, i) {
                  var msg = chatController.messages[i];
                  return GestureDetector(
                    onLongPress: () => _showMsgOptions(i, msg.text),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            decoration: const BoxDecoration(
                                color: bubbleColor, 
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15), 
                                  topRight: Radius.circular(15), 
                                  bottomLeft: Radius.circular(15)
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("12:00 PM", style: TextStyle(color: Colors.white70, fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Icon(
                                      msg.isRead ? Icons.done_all : Icons.done, 
                                      size: 14, 
                                      color: msg.isRead ? Colors.blueAccent : Colors.white70
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (msg.emoji != null)
                            Positioned(
                              bottom: -2, 
                              left: 5, 
                              child: Container(
                                padding: const EdgeInsets.all(2), 
                                decoration: BoxDecoration(
                                  color: Colors.white, 
                                  borderRadius: BorderRadius.circular(10), 
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]
                                ), 
                                child: Text(msg.emoji!, style: const TextStyle(fontSize: 12))
                              )
                            ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white, 
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: TextField(
                        controller: chatController.textController,
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          hintText: "type_message".tr, 
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          suffixIcon: Obx(() => chatController.isEditing.value 
                            ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.red), 
                                onPressed: () { 
                                  chatController.isEditing.value = false; 
                                  chatController.textController.clear(); 
                                }
                              ) 
                            : const SizedBox()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon: Obx(() => Icon(chatController.isEditing.value ? Icons.check : Icons.send, color: Colors.white)),
                      onPressed: () => chatController.sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}