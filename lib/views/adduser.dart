import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawer.dart';
import '../controllers/user_controller.dart';

class Adduser extends StatelessWidget {
  const Adduser({super.key});

  @override
  Widget build(BuildContext context) {
    // نتحقق إذا كان الكنترولر شغال أو نشغله
    final UserController controller = Get.isRegistered<UserController>() 
        ? Get.find<UserController>() 
        : Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Telegram", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: const Color.fromARGB(255, 78, 150, 194),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Name",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () => controller.addUser(),
            child: const Text("أضف مستخدم", style: TextStyle(color: Colors.black)),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) => Card(
                color: const Color.fromARGB(255, 128, 169, 195),
                child: ListTile(
                  onTap: () => Get.toNamed('/chat', arguments: controller.users[i]),
                  leading: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteUser(i),
                  ),
                  title: Text(controller.users[i], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => controller.editUser(i),
                  ),
                ),
              ),
            )),
          )
        ],
      ),
    );
  }
}