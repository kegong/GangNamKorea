import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/model/category.dart';
import 'package:gang_nam_korea/src/view/common/common_widget.dart';
import 'package:gang_nam_korea/src/view/pages/post/post_list_widget.dart';

import '../../../env/theme_mng.dart';

class TamplatePage extends StatefulWidget {
  const TamplatePage({super.key, required this.category});

  final CategoryData category;

  @override
  State<TamplatePage> createState() => _TamplatePageState();
}

class _TamplatePageState extends State<TamplatePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late CategoryData category;

  @override
  void initState() {
    super.initState();

    category = widget.category;
  }

  Widget _makeMenuText(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.textMenuBlack),
      ),
    );
  }

  Widget _makeMenu() {
    int menuCnt = category.menus.length;

    if (menuCnt <= 0) return const SizedBox();

    int colCnt = 0;
    int rowCnt = 0;

    if (menuCnt <= 4) {
      colCnt = 1;
      rowCnt = menuCnt;
    } else if (menuCnt <= 6) {
      colCnt = 2;
      rowCnt = 3;
    } else if (menuCnt <= 8) {
      colCnt = 2;
      rowCnt = 4;
    } else {
      colCnt = (menuCnt + 1) ~/ 4 + 1;
      rowCnt = 4;
    }

    int index = 0;
    List<Widget> colList = [];
    for (int i = 0; i < colCnt; i++) {
      List<Widget> rowList = [];
      for (int j = 0; j < rowCnt; j++) {
        if (j > 0) {
          rowList.add(CommonWidget.verticalDivider());
        }

        rowList.add(_makeMenuText(category.menus.length > index ? category.menus[index].name : '-'));
        index++;
      }

      if (i > 0) {
        colList.add(const SizedBox(height: 24));
      }

      colList.add(Row(children: rowList));
    }

    //Column column = Column(children: colList);

    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, top: 10),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(children: colList),
      // Column(
      //   children: [
      //     Row(
      //       children: [
      //         _makeMenuText('홈'),
      //         CommonWidget.verticalDivider(),
      //         _makeMenuText('최신 인기'),
      //         CommonWidget.verticalDivider(),
      //         _makeMenuText('오늘 인기'),
      //         // CommonWidget.verticalDivider(),
      //         // _makeMenuText('주간 인기'),
      //       ],
      //     ),
      //     const SizedBox(height: 24),
      //     Row(
      //       children: [
      //         _makeMenuText('유두 사진'),
      //         CommonWidget.verticalDivider(),
      //         _makeMenuText('순정이'),
      //         CommonWidget.verticalDivider(),
      //         _makeMenuText('아이유'),
      //         // CommonWidget.verticalDivider(),
      //         // _makeMenuText(''),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  Widget _makeFilter() {
    return Container();
  }

  // Widget _makeContentList() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 10),
  //     child: ListView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: 10,
  //       itemBuilder: (context, index) => Container(
  //         padding: const EdgeInsets.all(0.0),
  //         child: _makeTestImage(),
  //       ),
  //     ),
  //   );
  // }

  // Widget _makeTestImage() {
  //   if (category.categoryKey == "home") {
  //     return const Image(image: AssetImage('assets/images/test/content3.png'));
  //   }
  //   if (category.categoryKey == "best") {
  //     return const Image(image: AssetImage('assets/images/test/content2.png'));
  //   }

  //   return const Image(image: AssetImage('assets/images/test/content1.png'));
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _makeMenu(),
          _makeFilter(),
          const PostListWidget(),
        ],
      ),
    );
  }
}
