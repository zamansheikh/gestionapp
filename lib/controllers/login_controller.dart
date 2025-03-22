import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gestionapp/helpers/firebase_notification_service.dart';
import 'package:get/get.dart';
import '../../helpers/prefs_helper.dart';

import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../../utils/app_constants.dart';
import '../helpers/logger.dart';
import '../helpers/toast_message_helper.dart';
import '../routes/routes.dart';

class SignInController extends GetxController {
  ///=============== Log in ================
  final RxBool isObscure = true.obs;
  final RxBool logInLoading = false.obs;

  /// Toggle password visibility
  void toggleIsObscure() {
    isObscure.value = !isObscure.value;
  }

  /// Handle Log In
  Future<void> handleLogIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ToastMessageHelper.showToastMessage(
        "Email and password cannot be empty.",
      );
      return;
    }

    logInLoading(true);
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({"email": email.trim(), "password": password.trim()});

    try {
      var response = await ApiClient.postData(
        ApiConstants.signInEndPoint,
        body,
        headers: headers,
      );
      debugPrint(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body['data'];
        if (data != null) {
          try {
            String role = data['user']['role'];
            role.logI();
            await PrefsHelper.setString(AppConstants.role, role);
            await PrefsHelper.setString(
              AppConstants.bearerToken,
              response.body['data']["accessToken"],
            );
            await PrefsHelper.setString(AppConstants.email, email);
            await PrefsHelper.setString(AppConstants.user, data['user']['_id']);
            await PrefsHelper.setString(
              AppConstants.role,
              data['user']['role'],
            );
            final fcmToken = await PrefsHelper.getString(AppConstants.fcmToken);

            if (role == "admin" || role == "user") {
              try {
                FirebaseNotificationService.sendSocketEvent('fcmToken', {
                  'userId': data['user']['_id'],
                  'fcmToken': fcmToken,
                });
              } catch (e) {
                "Error sending fcmToken to socket: $e".logE();
              }
              Get.offAllNamed(AppRoutes.homePage);
            } else {
              ToastMessageHelper.showToastMessage(
                "Unknown role. Contact support.",
              );
            }
          } catch (e) {
            e.toString().logE();
          }
          ToastMessageHelper.showToastMessage("Logged in successfully.");
        } else {
          ToastMessageHelper.showToastMessage("Failed to retrieve user data.");
        }
      } else {
        ToastMessageHelper.showToastMessage(
          response.body['message'] ?? "Login failed.",
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("An error occurred: $e");
    } finally {
      logInLoading(false);
    }
  }
}
