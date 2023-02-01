import 'package:get/get.dart';

import '../../model/category.dart';
import '../../helper/extention.dart';

class CatetoryController extends GetxController {
  static CatetoryController get to => Get.find();

  List<CategoryData> categorys = [];
  List<BoardData> boards = [];
  Map<String, BoardData> boardMap = {};

  void loadCategoryFromJson(Map<String, dynamic> json) {
    json.forEach((key, category) {
      categorys.add(_createCategory(key, category['name'], category['menu']));
    });
  }

  CategoryData _createCategory(String categoryKey, String name, Map<String, dynamic>? iMenus) {
    CategoryData category = CategoryData(categoryKey, name);

    if (iMenus != null) {
      iMenus.forEach((menuKey, menu) {
        bool isBoard = Parser.toBool(menu['isBoard']);
        category.menus.add(_createMenu(categoryKey, menuKey, menu['name'], isBoard, menu['subMenu']));

        if (isBoard) {
          BoardData board = BoardData(menuKey, menu['name'], categoryKey, menuKey, '');
          boards.add(board);
          boardMap[menuKey] = board;
        }
      });
    }

    return category;
  }

  MenuData _createMenu(String categoryKey, String menuKey, String name, bool isBoard, Map<String, dynamic>? iSubMenus) {
    MenuData menu = MenuData(menuKey, name, isBoard);

    if (iSubMenus != null) {
      iSubMenus.forEach((subMenuKey, subMenu) {
        bool isBoard = Parser.toBool(subMenu['isBoard']);
        menu.subMenus.add(SubMenuData(subMenuKey, subMenu['name'], isBoard));

        if (isBoard) {
          BoardData board = BoardData(subMenuKey, subMenu['name'], categoryKey, menuKey, subMenuKey);
          boards.add(board);
          boardMap[subMenuKey] = board;
        }
      });
    }

    return menu;
  }

  CategoryData? getCategoryByBoardKey(String boardKey) {
    return categorys[0];
  }
}
