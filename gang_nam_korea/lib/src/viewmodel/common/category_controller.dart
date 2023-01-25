import 'package:get/get.dart';

import '../../model/category.dart';

class CatetoryController extends GetxController {
  static CatetoryController get to => Get.find();

  List<CategoryData> categorys = [];

  void loadCategoryFromJson(Map<String, dynamic> json) {
    json.forEach((key, category) {
      categorys.add(CategoryData.factory(key, category['name'], category['menu']));
    });
  }
}
