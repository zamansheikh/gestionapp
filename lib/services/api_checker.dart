import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {

      }
    }
  }
}