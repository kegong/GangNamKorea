import 'package:gang_nam_korea/src/model/user_data.dart';
import 'package:gang_nam_korea/src/helper/time_helper.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  UserData userData = UserData();

  @override
  void onInit() {
    super.onInit();

    TimeHelper.init();
  }

  void setUserData(int userNo, String authKey) {
    userData.userNo = userNo;
    userData.authKey = authKey;
  }

  bool isMyUserNo(userNo) {
    return userData.userNo == userNo;
  }

  RxMap<int, int> blockUsers = <int, int>{}.obs;
}
