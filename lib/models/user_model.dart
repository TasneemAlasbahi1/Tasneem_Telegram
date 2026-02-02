// models/user_model.dart (أنشئي هذا الملف)
class UserModel {
  String name;
  String lastMessage;
  String time;
  String image;

  UserModel({required this.name, required this.lastMessage, required this.time, required this.image});

  // لتحويل البيانات من وإلى JSON للتخزين في GetStorage
  Map<String, dynamic> toJson() => {'name': name, 'lastMessage': lastMessage, 'time': time, 'image': image};
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    lastMessage: json['lastMessage'],
    time: json['time'],
    image: json['image'],
  );
}