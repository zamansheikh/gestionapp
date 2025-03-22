import 'dart:convert';

import 'package:get/get.dart';
import '../helpers/toast_message_helper.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class PropertyController extends GetxController {
  RxBool propertyLoading = false.obs;
  Future<void> property({
    required String owner,
    required String zakRoomId,
  }) async {
    try {
      propertyLoading(true);
      var body = {
        "owner": owner,
        "zakRoomId": zakRoomId,
      };
      var response = await ApiClient.postData(
          ApiConstants.propertyEndPoint, jsonEncode(body));
      print("Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage('Property added successfully');
        Get.back(); // Navigate back
      } else {
        ToastMessageHelper.showToastMessage('Room not found!');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('An error occurred: $e');
    } finally {
      propertyLoading(false);
    }
  }

  Future<void> deleteProperty({
    required String propertyId,
    required String roomName,
  }) async {
    try {
      propertyLoading(true);
      var body = {
        "zakRoomName": roomName,
      };
      var response = await ApiClient.deleteData(
        ApiConstants.deleteProperty + propertyId,
        body: jsonEncode(body),
      );
      print("Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage('Property deleted successfully');
        Get.back(); // Navigate back
      } else {
        ToastMessageHelper.showToastMessage('Room not found!');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('An error occurred: $e');
    } finally {
      propertyLoading(false);
    }
  }
}
