import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.off(() => const Login()); // Get.off تعني الانتقال وعدم العودة للخلف (مثل Replacement)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 78, 150, 194),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.send_rounded,
              size: 80,
              color: Colors.white,
            ),

          Text(
          "Telegram",
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
          ],
        )
        
      ),
    );
  }
}