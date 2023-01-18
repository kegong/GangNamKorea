import 'package:gang_nam_korea/scr/model/user_data.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  Rx<UserData> userData = UserData().obs;

  void setUserData(int userNo, String authKey) {
    userData.update((val) {
      val!.userNo = userNo;
      val.authKey = authKey;
    });
  }
}
