import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/models/getUserProfileModel.dart';
import 'package:gestionapp/models/room_model.dart';
import 'package:get/get.dart';

import '../services/api_checker.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class GetUserController extends GetxController {
  RxBool getUserLoading = false.obs;
  var isAllUserGetLoading = false.obs;
  Rx<GetUserProfileModel> getUserProfileModel = GetUserProfileModel().obs;
  RxList<GetUserProfileModel> allUserList = <GetUserProfileModel>[].obs;
  RxList<RoomModel> roomList = <RoomModel>[].obs;
  getUserProfile() async {
    getUserLoading(true);
    var response = await ApiClient.getData(ApiConstants.getUserProfileEndPoint);

    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        getUserProfileModel.value = GetUserProfileModel.fromJson(data);
        getUserProfileModel.logD();
        "Successfully Converted".logE();
        getUserLoading(false);
      } catch (e) {
        e.toString().logE();
        getUserLoading(false);
      }
    } else {
      ApiChecker.checkApi(response);
      getUserLoading(false);
    }
  }

  getUserList() async {
    isAllUserGetLoading(true);
    var response = await ApiClient.getData(ApiConstants.getAllUser);

    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        allUserList.value = List<GetUserProfileModel>.from(
          data.map((x) => GetUserProfileModel.fromJson(x)),
        );
        allUserList.refresh();
      } catch (e) {
        // e.toString().logE();
      }
      isAllUserGetLoading(false);
    } else {
      isAllUserGetLoading(false);
      ApiChecker.checkApi(response);
    }
  }

  getAllRoomList() async {
    isAllUserGetLoading(true);
    var response = await ApiClient.getData(ApiConstants.getAllRooms);

    if (response.statusCode == 200) {
      var data = response.body["data"]["data"];
      try {
        roomList.value = List<RoomModel>.from(
          data.map((x) => RoomModel.fromJson(x)),
        );
        roomList.refresh();
      } catch (e) {
        e.toString().logE();
      }
      isAllUserGetLoading(false);
      roomList.length.logE();
    } else {
      isAllUserGetLoading(false);
      ApiChecker.checkApi(response);
    }
  }

  void deleteUser(String id) {
    ApiClient.deleteData(ApiConstants.deleteUser + id).then((response) {
      if (response.statusCode == 200) {
        getUserList();
      } else {
        ApiChecker.checkApi(response);
      }
    });
  }
}
