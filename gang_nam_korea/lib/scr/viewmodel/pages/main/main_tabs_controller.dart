import 'package:flutter/material.dart';
import 'package:gang_nam_korea/scr/model/category.dart';
import 'package:get/get.dart';

class MainTabsController extends GetxController {
  late TabController _tabController;
  TabController get tabController => _tabController;

  RxList<Color> tabBarColor = <Color>[].obs;
  int indexTabColor = 0;

  void initState({required TickerProvider vsync}) {
    CatetoryMng.init();

    _tabController = TabController(vsync: vsync, length: CatetoryMng.categorys.length);
    _tabController.addListener(() {
      indexTabColor = _tabController.index;
      tabBarColor(_getTabBarColor());
    });

    tabBarColor(_getTabBarColor());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Color> _getTabBarColor() {
    List<List<Color>> colorList = [
      [const Color.fromARGB(255, 8, 198, 100), const Color.fromARGB(255, 8, 198, 120)],
      [const Color.fromARGB(255, 7, 193, 110), const Color.fromARGB(255, 10, 171, 151)],
      [const Color.fromARGB(255, 7, 187, 122), const Color.fromARGB(255, 8, 198, 120)],
      [const Color.fromARGB(255, 9, 178, 139), const Color.fromARGB(255, 12, 165, 162)],
      [const Color.fromARGB(255, 12, 170, 155), const Color.fromARGB(255, 16, 160, 171)],
      [const Color.fromARGB(255, 13, 163, 164), const Color.fromARGB(255, 16, 159, 172)],
      [const Color.fromARGB(255, 26, 165, 180), const Color.fromARGB(255, 88, 142, 204)],
      [const Color.fromARGB(255, 40, 153, 187), const Color.fromARGB(255, 153, 128, 230)],
      [const Color.fromARGB(255, 158, 127, 230), const Color.fromARGB(255, 230, 116, 149)],
      [const Color.fromARGB(255, 196, 122, 185), const Color.fromARGB(255, 226, 113, 157)],
    ];

    return colorList[indexTabColor];
  }
}
