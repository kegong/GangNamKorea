import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void setLogin(bool login) {
    _isLogin = login;
    update();
  }
}
