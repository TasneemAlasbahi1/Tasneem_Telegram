import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'user_controller.dart'; 

class ChatMessage {
  String text;
  bool isRead;
  String? emoji;

  ChatMessage({required this.text, this.isRead = false, this.emoji});

  Map<String, dynamic> toJson() => {'text': text, 'isRead': isRead, 'emoji': emoji};

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'] ?? '',
        isRead: json['isRead'] ?? false,
        emoji: json['emoji'],
      );
}

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  final box = GetStorage();
  var isEditing = false.obs;
  var editingIndex = (-1).obs;
  
  // حل مشكلة Late: تعريف المتغير بقيمة مبدئية فارغة
  String currentChatUser = ""; 

  // الدالة التي يحتاجها البرنامج في الصورة e3bd82b8
  void initChat(String userName) {
    currentChatUser = userName;
    messages.clear();
    List? storedMsgs = box.read<List>('chat_$userName');
    if (storedMsgs != null) {
      messages.assignAll(storedMsgs.map((e) => ChatMessage.fromJson(e)).toList());
    }
  }

  void sendMessage() {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    if (isEditing.value) {
      messages[editingIndex.value].text = text;
      isEditing.value = false;
      editingIndex.value = -1;
    } else {
      messages.add(ChatMessage(text: text));
      int currentIndex = messages.length - 1;
      Future.delayed(const Duration(seconds: 1), () {
        if (currentIndex < messages.length) {
          messages[currentIndex].isRead = true;
          messages.refresh();
          saveToStorage(); 
        }
      });
    }
    textController.clear();
    saveToStorage();
    updateHomeSubtitle(text); 
  }

  void deleteMessage(int index) {
  messages.removeAt(index);
  saveToStorage();
  
  // نرسل المفتاح فقط كـ String بدون .tr أو نرسل null
  updateHomeSubtitle(messages.isNotEmpty ? messages.last.text : 'no_messages');
}

  void addEmoji(int index, String emoji) {
    messages[index].emoji = emoji;
    messages.refresh();
    saveToStorage();
  }

  void saveToStorage() {
    if (currentChatUser.isNotEmpty) {
      List data = messages.map((m) => m.toJson()).toList();
      box.write('chat_$currentChatUser', data);
    }
  }

  void updateHomeSubtitle(String text) {
    try {
      Get.find<UserController>().updateLastMessage(currentChatUser, text);
    } catch (e) { print("Error updating subtitle: $e"); }
  }
}