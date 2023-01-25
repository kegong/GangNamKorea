class CategoryData {
  final String keyName;
  final String name;
  final bool isViewSubCategory;
  final bool isViewFilter;
  final List<MenuData> menus = [];

  CategoryData(this.keyName, this.name, this.isViewSubCategory, this.isViewFilter);

  static factory(String keyName, String name, Map<String, dynamic>? menus) {
    CategoryData category = CategoryData(keyName, name, true, true);

    if (menus != null) {
      menus.forEach((key, menu) {
        category.menus.add(MenuData.factory(key, menu['name'], menu['subMenu']));
      });
    }

    return category;
  }
}

class MenuData {
  final String keyName;
  final String name;
  final List<SubMenuData> subMenus = [];

  MenuData(this.keyName, this.name);

  static factory(String keyName, String name, Map<String, dynamic>? subMenus) {
    MenuData menu = MenuData(keyName, name);

    if (subMenus != null) {
      subMenus.forEach((key, subMenu) {
        menu.subMenus.add(SubMenuData(key, subMenu['name']));
      });
    }

    return menu;
  }
}

class SubMenuData {
  final String keyName;
  final String name;

  SubMenuData(this.keyName, this.name);
}
