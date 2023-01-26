import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/model/category.dart';

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

  Widget _makeTestImage() {
    if (widget.category.categoryKey == "home") {
      return const Image(image: AssetImage('assets/images/test/content1.png'));
    }
    if (widget.category.categoryKey == "best") {
      return const Image(image: AssetImage('assets/images/test/content2.png'));
    }

    return const Image(image: AssetImage('assets/images/test/content3.png'));
  }

  Widget _makeMenu() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Text("text"),
    );
  }

  Widget _makeFilter() {
    return Container();
  }

  Widget _makeContentList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(0.0),
        child: _makeTestImage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _makeMenu(),
          _makeFilter(),
          _makeContentList(),
        ],
      ),
    );
  }
}
