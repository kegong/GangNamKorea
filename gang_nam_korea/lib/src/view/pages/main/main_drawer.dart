import 'package:flutter/material.dart';

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
    );
  }
}
