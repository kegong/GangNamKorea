import 'package:gang_nam_korea/src/model/user_data.dart';
import 'package:gang_nam_korea/src/util/time_util.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  Rx<UserData> userData = UserData().obs;

  @override
  void onInit() {
    super.onInit();

    TimeUtil.init();
  }

  void setUserData(int userNo, String authKey) {
    userData.update((val) {
      val!.userNo = userNo;
      val.authKey = authKey;
    });
  }
}
