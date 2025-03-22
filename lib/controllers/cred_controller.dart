import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/utils/app_constants.dart';
import 'package:get/get.dart';

class CredController extends GetxController {
  RxString userRole = 'user'.obs;
  RxInt navIndex = 0.obs;
  RxInt selectedIndex = 0.obs;

  void loadRole() async {
    userRole.value = await PrefsHelper.getString(AppConstants.role);
  }

  //call on init
  @override
  void onInit() {
    loadRole();
    super.onInit();
  }
}
