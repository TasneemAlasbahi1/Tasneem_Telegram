import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart'; // تأكدي من صحة المسار

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط الصفحة بالكنترولر
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: const Color.fromARGB(255, 78, 150, 194),
       // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // حقل الاسم (يمكنك إضافة متغير له في الكنترولر إذا أردتِ تخزينه)
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 78, 150, 194)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),

            // حقل البريد المرتبط بالكنترولر
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 78, 150, 194)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),

            // حقل الباسورد المرتبط بالكنترولر
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 78, 150, 194)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 78, 150, 194),
              ),
              onPressed: () {
                // استدعاء دالة التسجيل التي تحفظ البيانات في GetStorage
                controller.register();
              },
              child: const Text("Register", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}