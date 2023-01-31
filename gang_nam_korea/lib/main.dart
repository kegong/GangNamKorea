import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/view/pages/login/loading_page.dart';
import 'package:gang_nam_korea/src/view/pages/main/main_tabs.dart';
import 'package:gang_nam_korea/src/view/pages/post/post_write_page.dart';
import 'package:get/get.dart';
import 'src/viewmodel/common/bind/init_binding.dart';
import 'src/env/theme_mng.dart';
import 'src/env/constants.dart';
import 'src/view/pages/login/login_join_page.dart';
import 'src/view/pages/login/server_login_page.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.a
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: ConstValue.titleName,
      theme: ThemeMng.defaultTheme,
      initialBinding: InitBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoadingPage()),
        GetPage(name: '/login', page: () => const LoginJoinPage()),
        GetPage(name: '/serverlogin', page: () => const ServerLoginPage()),
        GetPage(name: '/main', page: () => const MainTabs()),
        GetPage(name: '/postwrite', page: () => const PostWritePage()),
      ],
    );
  }
}
