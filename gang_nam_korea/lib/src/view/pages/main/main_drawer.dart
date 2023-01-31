import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/env/theme_mng.dart';
import 'package:get/get.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 100,
          color: AppColor.red,
        ),
        Container(
          height: 100,
          color: AppColor.green,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.toNamed('/postwrite', arguments: {'boardKey': '', 'post': null});
              },
              child: const Text('글쓰기'),
            ),
          ),
        ),
        Container(
          height: 100,
          color: AppColor.yellow,
        ),
        Container(
          height: 100,
          color: AppColor.blue,
        ),
      ]),
    );
  }
}
