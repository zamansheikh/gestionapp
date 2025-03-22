import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../controllers/settings_controller.dart';
import '../../base/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings'.tr,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault.w,
          vertical: Dimensions.paddingSizeDefault.h,
        ),
        child: Column(
          children: [
            SizedBox(height: 24.h),

            /// =========================================> Change Password =====================================>
            buildMenuItem(
              title: 'Change Password'.tr,
              iconPath: 'assets/icons/lock.svg',
              onTap: controller.navigateToChangePassword,
            ),
            SizedBox(height: 16.h),

            /// =========================================> Privacy Policy=====================================>
            buildMenuItem(
              title: 'Privacy Policy'.tr,
              iconPath: 'assets/icons/privacy.svg',
              onTap: controller.navigateToPrivacyPolicy,
            ),
            SizedBox(height: 16.h),

            /// =========================================> Terms Services =====================================>
            buildMenuItem(
              title: 'Terms & Conditions'.tr,
              iconPath: 'assets/icons/terms.svg',
              onTap: controller.navigateToTermsOfService,
            ),
            SizedBox(height: 16.h),

            /// =========================================> Terms Services =====================================>
            buildMenuItem(
              title: 'Change Language'.tr,
              iconPath: 'assets/icons/terms.svg',
              onTap: controller.navigateToLanguage,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 367.w,
        height: 60.h,
        margin: EdgeInsets.only(left: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.backcolorsE6E6E6,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  color: AppColors.textColor,
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/icons/chevron.svg',
              color: AppColors.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 367.w,
        height: 60.h,
        margin: EdgeInsets.only(left: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              color: AppColors.backcolorsE6E6E6,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
