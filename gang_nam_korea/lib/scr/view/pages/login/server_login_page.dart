import 'package:flutter/material.dart';
import 'package:gang_nam_korea/scr/viewmodel/common/auth_controller.dart';

class ServerLoginPage extends StatefulWidget {
  const ServerLoginPage({super.key});

  @override
  State<ServerLoginPage> createState() => _ServerLoginPageState();
}

class _ServerLoginPageState extends State<ServerLoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AuthController.to.requestLoginToServer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}
