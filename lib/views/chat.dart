import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class Mychat extends StatelessWidget {
  const Mychat({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط الصفحة بالـ Controller
    final ChatController chatController = Get.put(ChatController());
    
    // استقبال اسم الشخص الذي نراسله من الصفحة السابقة
    final String userName = Get.arguments ?? "User";

    // ألوانكِ المفضلة
    const Color primaryColor = Color.fromARGB(255, 78, 150, 194);
    const Color bubbleColor = Color.fromARGB(255, 128, 169, 195);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(userName[0], style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        // يمكنكِ وضع صورة خلفية هنا لتشبه تليجرام أكثر
        color: Colors.grey[200],
        child: Column(
          children: [
            // عرض الرسائل
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: chatController.messages.length,
                itemBuilder: (context, i) {
                  return Align(
                    alignment: Alignment.centerRight, // لرسائلكِ
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: const BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chatController.messages[i],
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "12:00 PM",
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
            
            // منطقة إدخال الرسالة (مثل تليجرام)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: chatController.textController,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
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