import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/models/calender_model.dart';
import 'package:gestionapp/models/reservation_model.dart';
import 'package:gestionapp/utils/app_constants.dart';
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
    var response = await ApiClient.getData(ApiConstants.getPropertyById(id));
    if (response.statusCode == 200) {
      var data = response.body["data"];
      try {
        calenderModel.value = List<CalenderModel>.from(
          data.map((x) => CalenderModel.fromJson(x)),
        );
        "Data converted: fromJson to Model".logW();
      } catch (e) {
        "Something wrong".logE();
      }
      calendarLoading(false);
    } else {
      calendarLoading(false);
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

        "Successfully Converted".logE();
      } catch (e) {
        e.toString().logE();
      }
      reservationLoading(false);
    } else {
      reservationLoading(false);
      ApiChecker.checkApi(response);
    }
  }
}
