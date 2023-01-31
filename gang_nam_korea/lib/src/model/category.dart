class CategoryData {
  final String categoryKey;
  final String name;
  final List<MenuData> menus = [];

  CategoryData(this.categoryKey, this.name);
}

class MenuData {
  final String menuKey;
  final String name;
  bool isBoard;
  final List<SubMenuData> subMenus = [];

  MenuData(this.menuKey, this.name, this.isBoard);
}

class SubMenuData {
  final String subMenukey;
  final String name;
  bool isBoard;

  SubMenuData(this.subMenukey, this.name, this.isBoard);
}

class BoardData {
  final String boardKey;
  final String name;
  final String categoryKey;
  final String menuKey;
  final String subMenukey;

  BoardData(this.boardKey, this.name, this.categoryKey, this.menuKey, this.subMenukey);
}
