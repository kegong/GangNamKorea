import 'package:flutter/material.dart';
import 'package:gang_nam_korea/model/category.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key, required this.category});

  final Category category;

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _makeTestImage() {
    if (widget.category.keyName == "home") {
      return const Image(image: AssetImage('assets/images/test/content1.png'));
    }
    if (widget.category.keyName == "best") {
      return const Image(image: AssetImage('assets/images/test/content2.png'));
    }

    return const Image(image: AssetImage('assets/images/test/content3.png'));
  }

  Widget _makeSubMenu() {
    return const Card(
      child: Text("text"),
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
        children: [
          _makeSubMenu(),
          _makeFilter(),
          _makeContentList(),
        ],
      ),
    );
  }
}
