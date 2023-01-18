class Category {
  final String keyName;
  final String name;
  final bool isViewSubCategory;
  final bool isViewFilter;
  final List<SubCatetory> subCategorys = [];

  Category(this.keyName, this.name, this.isViewSubCategory, this.isViewFilter);

  static factory(String keyName, String name) {
    Category? category;

    if (keyName == "best") {
      category = Category(keyName, name, true, true);
      category.subCategorys.add(SubCatetory("best_home", "최신 인기"));
    } else {
      category = Category(keyName, name, true, true);
    }

    return category;
  }
}

class SubCatetory {
  final String keyName;
  final String name;
  final List<Filter> filters = [];

  SubCatetory(this.keyName, this.name) {
    if (keyName == "home_home") {
      filters.add(Filter("keyName", "name"));
      filters.add(Filter("keyName", "name"));
    }
  }

  static factory(String keyName, String name) {}
}

class Filter {
  final String keyName;
  final String name;

  Filter(this.keyName, this.name);
}

class CatetoryMng {
  static List<Category> categorys = [];

  static init() {
    categorys.add(Category.factory("home", "  홈  "));
    categorys.add(Category.factory("best", " 인기 "));
    categorys.add(Category.factory("humor", " 유머 "));
    categorys.add(Category.factory("news", " 뉴스 "));
    categorys.add(Category.factory("sports", " 스포츠 "));
    categorys.add(Category.factory("game", " 게임 "));
    categorys.add(Category.factory("broadcast", " 방송 "));
    categorys.add(Category.factory("shopping", " 쇼핑 "));
    categorys.add(Category.factory("community", " 커뮤니티 "));
    categorys.add(Category.factory("gallery", " 갤러리 "));
  }
}
