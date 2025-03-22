import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:get/get.dart';
import '../services/api_checker.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../routes/routes.dart';

class VerifyEmailController extends GetxController {
  //<===== ============== Verify Email =============== =====>

  TextEditingController otpCtrl = TextEditingController();
  var verifyLoading = false.obs;

  handleOtpVerify({String? oneTimeCode, email, String screenType = ''}) async {
    if (oneTimeCode == null || oneTimeCode.isEmpty) {
      Get.snackbar('Error', 'OTP code cannot be empty');
      return;
    }

    var body = {'email': email, 'oneTimeCode': int.tryParse(oneTimeCode)};
    verifyLoading(true);

    try {
      Response response = await ApiClient.postData(
        ApiConstants.verifyOtpEndPoint,
        json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        String message = response.body['message'] ?? 'Verification successful';
        Get.snackbar('Verify', message);
        PrefsHelper.setString("otpToken", response.body['data']);

        if (screenType == 'forgotPassword') {
          Get.toNamed(AppRoutes.resetPassScreen);
        } else {
          // Get.toNamed(AppRoutes.aboutScreen);
        }
      } else {
        ApiChecker.checkApi(response);
        print("Error: ${response.statusText}");
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      print("Exception: $e");
    } finally {
      verifyLoading(false);
    }
  }

  //
  // ///===============Resend================<>
  // RxBool resendLoading = false.obs;
  //
  // reSendOtp() async {
  //   resendLoading(true);
  //
  //
  //   var response =
  //   await ApiClient.postData(ApiConstants.reSendOtpEndPoint, '');
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print("======>>> successful");
  //     resendLoading(false);
  //   }
  // }
}
