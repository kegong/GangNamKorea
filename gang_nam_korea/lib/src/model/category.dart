import '../viewmodel/util/extention.dart';

class CategoryData {
  final String categoryKey;
  final String name;
  final bool isViewSubCategory;
  final bool isViewFilter;
  final List<MenuData> menus = [];

  CategoryData(this.categoryKey, this.name, this.isViewSubCategory, this.isViewFilter);

  static factory(String categoryKey, String name, Map<String, dynamic>? iMenus) {
    CategoryData category = CategoryData(categoryKey, name, true, true);

    if (iMenus != null) {
      iMenus.forEach((menuKey, menu) {
        category.menus.add(MenuData.factory(menuKey, menu['name'], Parser.toBool(menu['isBoard']), menu['subMenu']));
      });
    }

    return category;
  }
}

class MenuData {
  final String menuKey;
  final String name;
  bool isBoard;
  final List<SubMenuData> subMenus = [];

  MenuData(this.menuKey, this.name, this.isBoard);

  static factory(String menuKey, String name, bool isBoard, Map<String, dynamic>? iSubMenus) {
    MenuData menu = MenuData(menuKey, name, isBoard);

    if (iSubMenus != null) {
      iSubMenus.forEach((subMenuKey, subMenu) {
        menu.subMenus.add(SubMenuData(subMenuKey, subMenu['name'], Parser.toBool(subMenu['isBoard'])));
      });
    }

    return menu;
  }
}

class SubMenuData {
  final String subMenukey;
  final String name;
  bool isBoard;

  SubMenuData(this.subMenukey, this.name, this.isBoard);
}
