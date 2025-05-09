import 'package:flutter/widgets.dart';
import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/models/calender_model.dart';
import 'package:gestionapp/models/reservation_model.dart';
import 'package:gestionapp/utils/app_constants.dart';
import 'package:gestionapp/utils/loading_controller.dart';
import 'package:get/get.dart';

import '../services/api_checker.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class CalendarController extends GetxController {
  RxBool calendarLoading = false.obs;
  RxList<CalenderModel> calenderModel = <CalenderModel>[].obs;
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;
  RxString userRole = 'user'.obs;
  RxInt selectedRoomIndex = 0.obs;

  int fixedYearStart = DateTime.now().subtract(const Duration(days: 30)).year;
  int fixedMonthStart = DateTime.now().subtract(const Duration(days: 30)).month;
  int fixedYearEnd = DateTime.now().add(const Duration(days: 60)).year;
  int fixedMonthEnd = DateTime.now().add(const Duration(days: 60)).month;

  void loadRole() async {
    userRole.value = await PrefsHelper.getString(AppConstants.role);
  }

  //call on init
  @override
  void onInit() {
    loadRole();
    super.onInit();
  }

  calendarReserve({String id = ''}) async {
    calendarLoading(true);
    LoadingController.to.showLoading();
    var response = await ApiClient.getData(ApiConstants.getPropertyById(id));
    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        calenderModel.value = List<CalenderModel>.from(
          data.map((x) => CalenderModel.fromJson(x)),
        );
        debugPrint("Data converted: fromJson to CalenderModel");
      } catch (e) {
        "Something wrong".logE();
      }
      calendarLoading(false);
      LoadingController.to.hideLoading();
    } else {
      LoadingController.to.hideLoading();
      ApiChecker.checkApi(response);
    }
    update();
  }

  RxBool reservationLoading = false.obs;
  RxList<ReservationModel> reservationModel = <ReservationModel>[].obs;
  reservationProperty({
    String id = '',
    String startDate = '',
    String endDate = '',
  }) async {
    reservationLoading(true);
    LoadingController.to.showLoading();
    var response = await ApiClient.getData(
      ApiConstants.reservationProperty(id, startDate, endDate),
    );

    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        //add to first index
        if (reservationModel.isNotEmpty) {
          reservationModel[0] = ReservationModel.fromJson(data);
        } else {
          reservationModel.add(ReservationModel.fromJson(data));
        }

        debugPrint(
          "Log from:reservationProperty func: -> Successfully Converted",
        );
      } catch (e) {
        e.toString().logE();
      }
      reservationLoading(false);
      LoadingController.to.hideLoading();
    } else {
      reservationLoading(false);
      LoadingController.to.hideLoading();
      ApiChecker.checkApi(response);
    }
  }

  RxList<ReservationModel> reservationLogModel = <ReservationModel>[].obs;
  reservationPropertylog({
    String id = '',
    String startDate = '',
    String endDate = '',
  }) async {
    reservationLoading(true);
    LoadingController.to.showLoading();
    var response = await ApiClient.getData(
      ApiConstants.reservationPropertyLog(id, startDate, endDate),
    );

    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        //add to first index
        if (reservationLogModel.isNotEmpty) {
          reservationLogModel[0] = ReservationModel.fromJson(data);
        } else {
          reservationLogModel.add(ReservationModel.fromJson(data));
        }

        debugPrint(
          "Log from: reservationPropertylog func: -> Successfully Converted",
        );
      } catch (e) {
        e.toString().logE();
      }
      reservationLoading(false);
      LoadingController.to.hideLoading();
    } else {
      reservationLoading(false);
      LoadingController.to.hideLoading();
      ApiChecker.checkApi(response);
    }
  }
}
