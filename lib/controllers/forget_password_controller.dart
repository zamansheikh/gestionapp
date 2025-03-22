// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../helpers/toast_message_helper.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../routes/routes.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController enterEmailController = TextEditingController();

  ///===============Forgot Password================<>
  RxBool forgotLoading = false.obs;

  handleForgot(String email, screenType) async {
    forgotLoading(true);
    var body = {"email": email};

    var response = await ApiClient.postData(
        ApiConstants.forgetPasswordEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('=================screen type $screenType');
      Get.toNamed(AppRoutes.verifyEmailScreen,
          parameters: {"screenType": "forgotPassword", 'email': email});
      print("======>>> successful");
      forgotLoading(false);
    } else if (response.statusCode == 1) {
      forgotLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      forgotLoading(false);
    }
  }
}
