import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import '../../../controllers/change_password_controller.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'.tr, style: TextStyle(fontSize: 16.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //====================================> Current Password Text Field <=========================
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Current Password'.tr,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.currentPasswordCTRl,
                      hintText: 'Enter your password'.tr,
                      isPassword: true,
                      contentPaddingHorizontal: 20.w,
                      contentPaddingVertical: 18.h,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password".tr;
                        } else if (value.length < 8) {
                          return "Password must have 8 characters.".tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                //====================================> New Password Text Field <=========================
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'New Password'.tr,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.newPasswordCTRl,
                      hintText: 'Enter new password'.tr,
                      isPassword: true,
                      contentPaddingHorizontal: 20.w,
                      contentPaddingVertical: 18.h,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password".tr;
                        } else if (value.length < 8) {
                          return "Password must have 8 characters.".tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
                //====================================> Conform Password Text Field <=========================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Confirm Password'.tr,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.conformPasswordCTRl,
                      hintText: 'Enter Confirm Password'.tr,
                      isPassword: true,
                      contentPaddingHorizontal: 20.w,
                      contentPaddingVertical: 18.h,
                      validator: (value) {
                        if (value != controller.conformPasswordCTRl.text) {
                          return "Password do not match".tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
                SizedBox(height: 230.h),
                //===============================> Update Button <===============================
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.changePassword(
                        controller.currentPasswordCTRl.text.trim(),
                        controller.newPasswordCTRl.text.trim(),
                        controller.conformPasswordCTRl.text.trim(),
                      );
                    }
                  },
                  text: 'Update'.tr,
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
