import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gang_nam_korea/env/theme_mng.dart';
import 'package:gang_nam_korea/model/category.dart';
import 'package:gang_nam_korea/view/pages/main/main_tab_page.dart';
import 'package:gang_nam_korea/view/pages/test_page.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int indexTabColor = 0;

  @override
  void initState() {
    super.initState();

    CatetoryMng.init();

    _tabController = TabController(vsync: this, length: CatetoryMng.categorys.length);
    _tabController.addListener(() {
      setState(() {
        indexTabColor = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 59,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: _getTabBarColor(),
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: CustomColors.iconWhite),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => const TestPage())));
                  },
                ),
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    indicatorColor: Colors.white.withAlpha(150),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    tabs: CatetoryMng.categorys.map((e) {
                      return Tab(text: e.name);
                    }).toList(),
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: CatetoryMng.categorys.map((category) {
            return MainTabPage(category: category);
          }).toList()),
    );
  }
}
