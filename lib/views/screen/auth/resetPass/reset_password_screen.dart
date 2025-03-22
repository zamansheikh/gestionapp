import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import '../../../../controllers/reset_pass_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../base/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController enterPasswordController = TextEditingController();
  final TextEditingController reenterPasswordController =
      TextEditingController();
  final ResetForgetController controller = Get.put(ResetForgetController());

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password".tr,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textColors),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 35.h),
              SizedBox(height: 121.h),

              /// ===================================== Enter Password  ===================================>
              CustomTextField(
                controller: enterPasswordController,
                hintText: 'Enter Password'.tr,
                // prefixIcon: 'assets/icons/key.svg',
                isObscureText: true,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password".tr;
                  }
                  return null;
                },

                contentPaddingHorizontal: 20.w,
                contentPaddingVertical: 18.h,
              ),
              SizedBox(height: 24.h),

              /// ===================================== Re-Enter Password  ===================================>
              CustomTextField(
                controller: reenterPasswordController,
                hintText: 'Re-enter Password'.tr,
                // prefixIcon: 'assets/icons/key.svg',
                isObscureText: true,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Re-enter your password".tr;
                  }
                  return null;
                },

                contentPaddingHorizontal: 20.w,
                contentPaddingVertical: 18.h,
              ),
              SizedBox(height: 34.h),

              /// ===================================== Conform Button ===================================>
              CustomButton(
                onTap: () {
                  controller.setPassword(
                    enterPasswordController.text,
                    reenterPasswordController.text,
                    "resetPassword",
                  );
                },
                text: 'Confirm'.tr,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
