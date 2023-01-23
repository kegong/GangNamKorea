import 'package:get/get.dart';

import '../app_controller.dart';
import '../category_controller.dart';
import '../server_controller.dart';
import '../auth_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(ServerController(), permanent: true);
    Get.put(CatetoryController(), permanent: true);
  }
}
