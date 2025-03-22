import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../routes/routes.dart';

class SettingsController extends GetxController {
  void navigateToChangePassword() {
    Get.toNamed(AppRoutes.changePassword);
  }

  void navigateToPrivacyPolicy() {
    Get.toNamed(AppRoutes.privacyPolicyScreen);
  }

  void navigateToTermsOfService() {
    Get.toNamed(AppRoutes.termsServicesScreen);
  }

  void navigateToLanguage() {
    Get.toNamed(AppRoutes.changeLanguageScreen);
  }

  void showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Delete Account',
      titleStyle: TextStyle(
          color: AppColors.redColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold),
      titlePadding: EdgeInsets.only(top: 20.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: AppColors.backgroundColor,
      radius: 12.r,
      barrierDismissible: false,
      content: Column(
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
            'Are you sure you want to delete your Account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.subTextColor,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    backgroundColor: AppColors.backgroundColor,
                    fixedSize: Size(130.5.w, 60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide.none,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.backgroundColor,
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(130.5.w, 60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide.none,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                  ),
                  child: Text(
                    'Yes,Delete',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
