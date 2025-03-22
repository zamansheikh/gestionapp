import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import '../../../../controllers/forget_password_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    controller.enterEmailController.text = Get.parameters['email'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password".tr,
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
              /// ======================================> Forgot text ===============================>
              CustomText(
                text:
                    'Please enter your email address to reset your password.'
                        .tr,
                fontWeight: FontWeight.w400,
                fontsize: 16.h,
                maxline: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              /// ===================================== Email ===================================>
              CustomTextField(
                controller: controller.enterEmailController,
                hintText: 'E-mail'.tr,
                isEmail: true,
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

              /// ===================================== Send OTP ===================================>
              CustomButton(
                loading: controller.forgotLoading.value,
                onTap: () {
                  controller.handleForgot(
                    controller.enterEmailController.text,
                    'forgotPassword',
                  );
                },
                text: 'Send-Otp'.tr,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
