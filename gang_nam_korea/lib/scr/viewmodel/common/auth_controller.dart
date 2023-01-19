import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gang_nam_korea/scr/controller/app_controller.dart';
import 'package:gang_nam_korea/scr/controller/server_controller.dart';
import 'package:gang_nam_korea/scr/view/component/common_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  late Rx<User?> _user;
  FirebaseAuth authentication = FirebaseAuth.instance;

  bool wantStartLoginPage = false;
  bool isNeedJoinUserToServer = false;
  String joinNickName = "";
  bool isMustRemoveSplash = true;

  // 파이어베이스 데이터 바인딩
  void initFirebaseDataBind() {
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _moveToPage);
  }

  // 유저 상태에 따라 페이지 이동
  _moveToPage(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/serverlogin');
    }
  }

  // 파이어베이스에 회원 가입 요청
  Future<void> registerFirebase(String email, password, iNickName) async {
    try {
      isNeedJoinUserToServer = true;
      joinNickName = iNickName;
      await authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      isNeedJoinUserToServer = false;
      Get.snackbar(
        "Error message",
        "User message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Registration is failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  // 파이어베이스에 로그인 요청
  Future<void> loginFirebase(String email, password) async {
    try {
      await authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        "Error message",
        "User message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Registration is failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logoutFirebase() {
    wantStartLoginPage = true;
    authentication.signOut();
  }

  // 서버에 연결하여 버전 체크
  void requestCheckVersion(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();

    ServerController.to.request(
      'CHECK_VERSION',
      {'version': info.version},
      retFunc: (json) async {
        ServerController.to.apiFileUrl = json['apiFileUrl'];
        AuthController.to.initFirebaseDataBind();
      },
      errorFunc: (error, {json}) {
        if (AuthController.to.isMustRemoveSplash) {
          AuthController.to.isMustRemoveSplash = false;
          // FlutterNativeSplash.remove();
        }

        if (json == null || json['updateUrl'] == null) {
          CommonWidget.showNoticeDialog(context, content: '네트워크를 확인 후 다시 시도해주세요.', onPressed: () {
            if (Platform.isIOS) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          });
        } else {
          CommonWidget.showNoticeDialog(context, content: '앱 업데이트 이후 이용해주세요.', onPressed: () {
            launchUrl(json['updateUrl']);

            if (Platform.isIOS) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          });
        }
      },
    );
  }

  // 서버에 로그인 요청
  void requestLoginToServer() {
    if (isNeedJoinUserToServer) {
      isNeedJoinUserToServer = false;
      requestJoinToServer();
      return;
    }

    ServerController.to.request(
      'USER_LOGIN',
      {'email': _user.value!.email, 'authKey': _user.value!.uid},
      retFunc: (json) async {
        AppController.to.setUserData(int.parse(json['userNo']), _user.value!.uid);
        Get.offAllNamed('/main');
      },
      errorFunc: (error, {json}) {
        // 에러 상태 표시
      },
    );
  }

  // 서버에 회원가입 요청
  void requestJoinToServer() {
    ServerController.to.request(
      'USER_JOIN',
      {'email': _user.value!.email, 'authKey': _user.value!.uid, 'nickname': joinNickName},
      retFunc: (json) async {
        Get.offAllNamed('/main');
      },
      errorFunc: (error, {json}) {
        // 에러 상태 표시
      },
    );
  }
}
