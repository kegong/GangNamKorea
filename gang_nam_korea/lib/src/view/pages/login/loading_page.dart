import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/viewmodel/common/auth_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AuthController.to.requestCheckVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
