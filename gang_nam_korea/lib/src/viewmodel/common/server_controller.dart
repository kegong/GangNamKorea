import 'package:flutter/foundation.dart';
import 'package:gang_nam_korea/src/viewmodel/common/app_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

class ServerController extends GetxController {
  static ServerController get to => Get.find();

  late dio.Dio _dio;
  static const String _versionFileUrl = 'api_version.php';
  static const String _baseUrl = 'http://bbiby2.godohosting.com/gangnamkorea/api/';
  String apiFileUrl = '';

  @override
  void onInit() {
    super.onInit();

    _dio = dio.Dio();
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
  }

  Future<void> request(
    String api,
    Map<String, dynamic> queryData, {
    String? filePath,
    void Function(dynamic json)? retFunc,
    void Function(String error, {dynamic json})? errorFunc,
  }) async {
    String errString = '';
    try {
      Map<String, dynamic> formQuery = {'API': api};

      if (api != 'CHECK_VERSION' && api != 'USER_LOGIN' && api != 'USER_JOIN') {
        formQuery['userNo'] = AppController.to.userData.userNo;
        formQuery['authKey'] = AppController.to.userData.authKey;
      }

      formQuery.addAll(queryData);

      // 이미지 데이터 추가
      if (filePath != null) {
        _dio.options.contentType = 'multipart/form-data';
        formQuery.addAll({'image': await dio.MultipartFile.fromFile(filePath)});
      }

      String path = _versionFileUrl;
      if (api != 'CHECK_VERSION') {
        path = apiFileUrl;
      }

      final formData = dio.FormData.fromMap(formQuery);
      final response = await _dio.post(path, data: formData);

      if (filePath != null) {
        _dio.options.contentType = null;
      }

      if (response.statusCode == 200) {
        try {
          var jsonData = convert.jsonDecode(response.data);

          if (jsonData['RET']) {
            if (retFunc != null) retFunc(jsonData);
          } else {
            errString = jsonData['RET2'];
            if (errorFunc != null) errorFunc(errString, json: jsonData);
            if (kDebugMode) {
              print('RET 에러 : $errString');
            }
          }
        } catch (e) {
          errString = 'JSON 파싱 에러 $api: ${response.data}';
          if (errorFunc != null) errorFunc(errString);
          if (kDebugMode) {
            print(errString);
          }
        }
      } else {
        errString = '통신 에러 : statusCode(${response.statusCode})';
        if (errorFunc != null) errorFunc(errString);

        if (kDebugMode) {
          Get.showSnackbar(GetSnackBar(title: '통신에러', message: errString));
        }

        if (kDebugMode) {
          print(errString);
        }
      }
    } catch (e) {
      errString = '통신 에러';
      if (errorFunc != null) errorFunc(errString);

      if (kDebugMode) {
        Get.showSnackbar(const GetSnackBar(title: '통신에러', message: '네트워크 에러'));
      }

      if (kDebugMode) {
        print(errString);
        e as dio.DioError;
        print(e.message);
      }
    }
  }
}
