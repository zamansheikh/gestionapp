import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../helpers/toast_message_helper.dart';
import '../routes/routes.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';
import 'get_user_controller.dart';

class ProfileController extends GetxController {
  final GetUserController _userController = Get.put(GetUserController());

  void navigateTo(String route) {
    Get.toNamed(route);
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: 'Log Out'.tr,
      titleStyle: TextStyle(
        color: AppColors.textColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      titlePadding: EdgeInsets.only(top: 20.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: AppColors.backgroundColor,
      radius: 12.r,
      barrierDismissible: false,
      content: SizedBox(
        width: Get.width * 0.8,
        height: 180.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Divider(
              color: AppColors.greyColor.withOpacity(0.5),
              thickness: 1.h,
              indent: 20.w,
              endIndent: 20.w,
            ),
            SizedBox(height: 10.h),
            Text(
              'Are you sure you want to log out of your account?'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: AppColors.textColors),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dialogButton('Cancel'.tr, AppColors.borderColor, () {
                  Get.back();
                }),
                SizedBox(width: 10.w),
                _dialogButton('Log Out'.tr, AppColors.redColor, () {
                  PrefsHelper.clearAll();
                  Get.offAllNamed(AppRoutes.signIn);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: AppColors.backgroundColor,
        fixedSize: Size(120.w, 50.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16.sp)),
    );
  }

  RxBool imageUpdateLoading = false.obs;

  Future<void> imageUpDateProfile({
    File? image,
    Map<String, String>? data,
  }) async {
    imageUpdateLoading(true);
    List<MultipartBody> multipartBody =
        image == null ? [] : [MultipartBody("image", image)];
    var body = {"data": jsonEncode(data)};
    var response = await ApiClient.putMultipartData(
      ApiConstants.updateProfileEndPoint,
      body,
      multipartBody: multipartBody,
    );
    print("=======> ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      _userController.getUserProfile();
      ToastMessageHelper.showToastMessage("Profile Update Successful!");
    }
    update();
    imageUpdateLoading(false);
  }
}
