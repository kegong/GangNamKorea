import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gang_nam_korea/scr/model/category.dart';
import 'package:gang_nam_korea/scr/view/pages/main/main_tab_page.dart';
import 'package:gang_nam_korea/scr/viewmodel/pages/main/main_tabs_controller.dart';
import 'package:get/get.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> with SingleTickerProviderStateMixin {
  final MainTabsController _controller = Get.put(MainTabsController());

  @override
  void initState() {
    super.initState();
    _controller.initState(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_MainTabsState build!");
    }
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 59,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          flexibleSpace: Obx((() => Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: _controller.tabBarColor.toList(),
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
                child: SafeArea(
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.menu, color: CustomColors.iconWhite),
                      //   onPressed: () {
                      //     // Navigator.push(context, MaterialPageRoute(builder: ((context) => const TestPage())));
                      //     //AuthController.to.logoutFirebase();
                      //   },
                      // ),
                      const SizedBox(
                        width: 50,
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
                          controller: _controller.tabController,
                        ),
                      ),
                    ],
                  ),
                ),
              )))),
      body: TabBarView(
          controller: _controller.tabController,
          physics: const BouncingScrollPhysics(),
          children: CatetoryMng.categorys.map((category) {
            return MainTabPage(category: category);
          }).toList()),
      drawer: Drawer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 100,
            color: Colors.red,
          ),
          Container(
            height: 100,
            color: Colors.green,
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('글쓰기'),
              ),
            ),
          ),
          Container(
            height: 100,
            color: Colors.yellow,
          ),
          Container(
            height: 100,
            color: Colors.blue,
          ),
        ]),
      ),
    );
  }
}
