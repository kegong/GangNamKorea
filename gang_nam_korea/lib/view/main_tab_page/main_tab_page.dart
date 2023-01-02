import 'package:flutter/material.dart';
import 'package:gang_nam_korea/model/constants.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key, required this.pageType});

  final MainTabPageType pageType;

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _makeImage() {
    if (widget.pageType == MainTabPageType.home) {
      return const Image(image: AssetImage('assets/images/test/content1.png'));
    }
    if (widget.pageType == MainTabPageType.best) {
      return const Image(image: AssetImage('assets/images/test/content2.png'));
    }

    return const Image(image: AssetImage('assets/images/test/content3.png'));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.amber,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(0.0),
              child: _makeImage(),
            ),
          ),
        ],
      ),
    );
  }
}
