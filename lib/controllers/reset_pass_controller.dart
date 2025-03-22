import 'dart:convert';
import 'package:get/get.dart';
import '../../helpers/prefs_helper.dart';
import '../../helpers/toast_message_helper.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../routes/routes.dart';

class ResetForgetController extends GetxController {
  //===============Set Password================<>

  RxBool setPasswordLoading = false.obs;
  setPassword(String newPassword, String confirmPassword, type) async {
    setPasswordLoading(true);
    var body = !(type == "resetPassword")
        ? {"newPassword": newPassword}
        : {
            "confirmPassword": confirmPassword,
            "newPassword": newPassword
          };
    //otpToken
    String otpToken = await PrefsHelper.getString('otpToken');

    //Write a custom Header then pass it with this otpTokern
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': otpToken
    };
    print(otpToken);
    var response = await ApiClient.postData(
      ApiConstants.resetPassEndPoint,
      jsonEncode(body),
      headers: header,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (type == "resetPassword") {
        Get.offAllNamed(AppRoutes.signIn);
      }

      ToastMessageHelper.showToastMessage('Password Changed');
      print("======>>> successful");
      setPasswordLoading(false);
    } else if (response.statusCode == 1) {
      setPasswordLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      setPasswordLoading(false);
    }
  }

// RxBool setPasswordLoading = false.obs;
//
// setPassword(String password, confirmPassword) async {
//   String token = await PrefsHelper.getString(AppConstants.bearerToken);
//   print(">>>>>>>>> token : $token");
//   setPasswordLoading(true);
//   var body = {"password": password, "confirmPassword": confirmPassword};
//   var headers = {'Content-Type': 'application/json',
//     'Authorization': 'Bearer $token'
//   };
//
//   var response = await ApiClient.postData(
//       ApiConstants.resetPasswordEndPoint, jsonEncode(body),headers: headers);
//
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     await PrefsHelper.setString(AppConstants.bearerToken, '');
//     Get.offAllNamed(AppRoutes.signInScreen);
//     ToastMessageHelper.showToastMessage('Password Changed');
//     print("======>>> successful");
//     setPasswordLoading(false);
//   }
// }
}
