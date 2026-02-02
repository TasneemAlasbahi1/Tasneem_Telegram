import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var myName = "".obs;
  var myPhone = "".obs;
  var myImagePath = "".obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // قراءة البيانات من الذاكرة أو استخدام القيم الافتراضية
    myName.value = box.read('myName') ?? "Tasneem Alasbahi"; 
    myPhone.value = box.read('myPhone') ?? "+967 774 832 386";
    myImagePath.value = box.read('imagePath') ?? "";
  }

  void updateProfile(String newName, String newPhone, String newPath) {
    // 1. تحديث القيم في الـ UI فوراً
    myName.value = newName;
    myPhone.value = newPhone;
    myImagePath.value = newPath;

    // 2. حفظها في الذاكرة الدائمة
    box.write('myName', newName);
    box.write('myPhone', newPhone);
    box.write('imagePath', newPath);
    
    // تأكيد التحديث
    update(); 
  }
}