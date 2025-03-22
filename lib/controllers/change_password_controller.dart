// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helpers/toast_message_helper.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class ChangePasswordController extends GetxController {
  ///===============Change Password================<>
  RxBool changePasswordLoading = false.obs;
  final TextEditingController currentPasswordCTRl = TextEditingController();
  final TextEditingController newPasswordCTRl = TextEditingController();
  final TextEditingController conformPasswordCTRl = TextEditingController();

  changePassword(String currentPassword, newPassword, confirmPassword) async {
    changePasswordLoading(true);
    var body = {
      "currentPassword": currentPassword,
      "newPassword": "$newPassword",
      "confirmPassword": "$confirmPassword"
    };

    var response = await ApiClient.postData(
        ApiConstants.changePasswordEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage('Password Changed Successful');
      print("======>>> successful");
      currentPasswordCTRl.clear();
      newPasswordCTRl.clear();
      conformPasswordCTRl.clear();
      Get.back();
      changePasswordLoading(false);
    } else if (response.statusCode == 1) {
      changePasswordLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      ToastMessageHelper.showToastMessage(response.body['message']);
      changePasswordLoading(false);
    }
  }
}

  // changePassword(String oldPassword, newPassword) async {
  //   changePasswordLoading(true);
  //   var body = {"oldPassword": "$oldPassword", "newPassword": "$newPassword"};
  //
  //   var response = await ApiClient.postData(ApiConstants.changePasswordEndPoint, jsonEncode(body));
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     ToastMessageHelper.showToastMessage('Password Changed Successful');
  //     print("======>>> successful");
  //     currentPasswordCTRl.clear();
  //     newPasswordCTRl.clear();
  //     conformPasswordCTRl.clear();
  //     Get.back();
  //     changePasswordLoading(false);
  //   } else if(response.statusCode == 1){
  //     changePasswordLoading(false);
  //     ToastMessageHelper.showToastMessage("Server error! \n Please try later");
  //   } else {
  //     ToastMessageHelper.showToastMessage(response.body['message']);
  //     changePasswordLoading(false);
  //   }
  // }


