// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/env/theme_mng.dart';
import 'package:gang_nam_korea/src/viewmodel/common/auth_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginJoinPage extends StatefulWidget {
  const LoginJoinPage({Key? key}) : super(key: key);

  @override
  State<LoginJoinPage> createState() => _LoginJoinPageState();
}

class _LoginJoinPageState extends State<LoginJoinPage> {
  bool isSignupScreen = true;
  bool showSpinner = false;

  // 폼 필드 키
  final _formKey = GlobalKey<FormState>();
  String nickName = '';
  String userEmail = '';
  String userPassword = '';

  bool _tryValidation() {
    // 폼 필드 유효성 체크
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // 세이브
      _formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  void initState() {
    isSignupScreen = !AuthController.to.wantStartLoginPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.login.background,

      // 로딩 스피너
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              _buildBackground(),
              _buildTextForm(),
              _buildSendButton(),
              _buildGoogleLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/red.jpg'), fit: BoxFit.fill),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 90, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RichText
              RichText(
                // TextSpan
                text: const TextSpan(
                  text: '강한 남자들의 커뮤니티!',
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 25,
                    color: AppColor.white,
                  ),
                  // children: [
                  //   TextSpan(
                  //     text: '강남 코리아',
                  //     style: TextStyle(
                  //       letterSpacing: 1.0,
                  //       fontSize: 25,
                  //       color: AppColor.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ],
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                isSignupScreen ? 'Gang Nam Korea' : 'Gang Nam Korea',
                style: const TextStyle(letterSpacing: 1.0, color: AppColor.textWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _makeTextFormInputDecoration(String hint) {
    return InputDecoration(
        prefixIcon: Icon(Icons.account_circle, color: AppColor.login.iconColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.login.textColor),
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.login.textColor),
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: AppColor.login.textColor),
        contentPadding: const EdgeInsets.all(10));
  }

  Widget _buildLoginTextForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              key: const ValueKey(2),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'email 형식으로 입력하세요.';
                }
                return null;
              },
              onSaved: (value) {
                userEmail = value!;
              },
              onChanged: (value) {
                userEmail = value;
              },
              decoration: _makeTextFormInputDecoration('email'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              obscureText: true,
              key: const ValueKey(3),
              validator: (value) {
                if (value!.isEmpty || value.length < 6 || value.length > 15) {
                  return '6~15자 문자로 입력하세요.';
                }
                return null;
              },
              onSaved: (value) {
                userPassword = value!;
              },
              onChanged: (value) {
                userPassword = value;
              },
              decoration: _makeTextFormInputDecoration('password'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              key: const ValueKey(1),
              validator: (value) {
                if (value!.isEmpty || value.length < 4 || value.length > 15) {
                  return '4~5자 문자로 입력하세요.';
                }
                return null;
              },
              onSaved: (value) {
                nickName = value!;
              },
              onChanged: (value) {
                nickName = value;
              },
              decoration: _makeTextFormInputDecoration('nick name'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinTextForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: const ValueKey(4),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'email 형식으로 입력하세요.';
                }
                return null;
              },
              onSaved: (value) {
                userEmail = value!;
              },
              onChanged: (value) {
                userEmail = value;
              },
              decoration: _makeTextFormInputDecoration('email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              key: const ValueKey(5),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return '6~15자 문자로 입력하세요.';
                }
                return null;
              },
              onSaved: (value) {
                userPassword = value!;
              },
              onChanged: (value) {
                userPassword = value;
              },
              decoration: _makeTextFormInputDecoration('password'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextForm() {
    // AnimatedPositioned 에니메이션
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      top: 180,
      // AnimatedContainer 에니메이션 될 컨테이너
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(20.0),
        height: isSignupScreen ? 280.0 : 250.0,
        width: MediaQuery.of(context).size.width - 40,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignupScreen = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: !isSignupScreen ? AppColor.login.activeColor : AppColor.login.textColor),
                        ),
                        if (!isSignupScreen)
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            height: 2,
                            width: 55,
                            color: AppColor.login.orange,
                          )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignupScreen = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          '회원가입',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSignupScreen ? AppColor.login.activeColor : AppColor.login.textColor),
                        ),
                        if (isSignupScreen)
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            height: 2,
                            width: 65,
                            color: AppColor.login.orange,
                          )
                      ],
                    ),
                  )
                ],
              ),
              if (isSignupScreen) _buildLoginTextForm(),
              if (!isSignupScreen) _buildJoinTextForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      top: isSignupScreen ? 430 : 390,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: GestureDetector(
            onTap: () async {
              if (!_tryValidation()) return;

              setState(() {
                showSpinner = true;
              });

              if (isSignupScreen) {
                await AuthController.to.registerFirebase(userEmail, userPassword, nickName);
              } else {
                await AuthController.to.loginFirebase(userEmail, userPassword);
              }

              setState(() {
                showSpinner = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.login.orange, AppColor.login.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: AppColor.shadowColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColor.iconWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLogin() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      top: isSignupScreen ? MediaQuery.of(context).size.height - 125 : MediaQuery.of(context).size.height - 165,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: AppColor.textWhite,
                minimumSize: const Size(155, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: AppColor.login.googleColor),
            icon: const Icon(Icons.add),
            label: const Text('Google'),
          ),
        ],
      ),
    );
  }
}
