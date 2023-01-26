import 'package:flutter/material.dart';

class BestPage extends StatefulWidget {
  const BestPage({super.key});

  @override
  State<BestPage> createState() => _BestPageState();
}

class _BestPageState extends State<BestPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
}
