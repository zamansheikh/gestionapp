import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import '../../../../controllers/forget_password_controller.dart';
import '../../../../controllers/verify_email_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../base/custom_text.dart';
import 'innerWidget/pin_code_field.dart';

class VerifyEmailScreen extends StatelessWidget {
  final TextEditingController otpCtrl = TextEditingController();
  final ForgotPasswordController fcontroller = Get.put(
    ForgotPasswordController(),
  );
  final VerifyEmailController controller = Get.put(VerifyEmailController());

  VerifyEmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify".tr,
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
              /// ======================================> Verify Reset text ===============================>
              CustomText(
                text: 'Verify Email'.tr,
                fontWeight: FontWeight.w400,
                fontsize: 23.h,
                top: 40.h,
                bottom: 8.h,
                color: AppColors.textColor,
              ),
              CustomText(
                text:
                    'Please enter the OTP code, We’ve sent you in your mail.'
                        .tr,
                fontWeight: FontWeight.w400,
                fontsize: 16.h,
                maxline: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              /// ===================================== otp  ===================================>
              CustomPinCodeTextField(otpCTE: otpCtrl),
              SizedBox(height: 10.h),

              /// ======================================> Resend ===============================>
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: 16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Didn’t receive the code?'.tr,
                      fontsize: 18.h,
                      color: AppColors.primaryColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        // controller.reSendOtp();
                      },
                      child: CustomText(
                        text: 'Resend'.tr,
                        fontsize: 18.h,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              /// ===================================== Send OTP ===================================>
              CustomButton(
                loading: controller.verifyLoading.value,
                onTap: () {
                  print(fcontroller.enterEmailController.text);
                  String screenType = Get.parameters["screenType"] ?? '';
                  controller.handleOtpVerify(
                    oneTimeCode: otpCtrl.text.trim(),
                    email: fcontroller.enterEmailController.text,
                    screenType: screenType,
                  );
                  otpCtrl.clear();
                },
                text: 'Verify'.tr,
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
