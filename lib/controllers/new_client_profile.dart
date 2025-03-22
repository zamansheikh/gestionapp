// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import '../helpers/toast_message_helper.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class NewClientCreateController extends GetxController {
  RxBool createLoading = false.obs;

  Future<void> createClient({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      createLoading(true);
      var body = {"name": name, "email": email, "password": password};
      var response = await ApiClient.postData(
        ApiConstants.createClientEndPoint,
        jsonEncode(body),
      );
      print("Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage('Client created successfully');
        Get.back(); // Navigate back
      } else {
        ToastMessageHelper.showToastMessage('Failed to create client');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('An error occurred: $e');
    } finally {
      createLoading(false);
    }
  }
}
