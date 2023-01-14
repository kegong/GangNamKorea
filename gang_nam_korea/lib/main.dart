import 'package:flutter/material.dart';
import 'package:gang_nam_korea/view/pages/main/main_tabs.dart';
import 'package:get/get.dart';
import 'env/theme_mng.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.a
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gang Nam Korea',
      theme: ThemeMng.defaultTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainTabs()),
        GetPage(name: '/mainTabs', page: () => const MainTabs()),
      ],
    );
  }
}
