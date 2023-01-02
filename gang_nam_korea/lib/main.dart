import 'package:flutter/material.dart';
import 'package:gang_nam_korea/view/main_tab_page/main_tabs.dart';
import 'env/theme_mng.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gang Nam Korea',
      theme: ThemeMng.defaultTheme,
      home: const MainTabs(),
      debugShowCheckedModeBanner: false,
    );
  }
}
