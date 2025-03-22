import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestionapp/routes/routes.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import '../../../../controllers/login_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  final TextEditingController enterEmailController = TextEditingController();
  final TextEditingController enterPasswordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 301.h),
              CustomText(
                text: 'Sign in'.tr,
                fontsize: 25.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
              SizedBox(height: 37.h),

              /// ===================================== Email ===================================>
              CustomTextField(
                controller: enterEmailController,
                hintText: 'E-mail'.tr,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 14.w),
                  child: SvgPicture.asset(
                    'assets/icons/mail.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                isEmail: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email".tr;
                  }
                  return null;
                },
                contentPaddingHorizontal: 20.w,
                contentPaddingVertical: 18.h,
              ),
              SizedBox(height: 12.h),

              /// ===================================== Enter Password ===================================>
              CustomTextField(
                controller: enterPasswordController,
                hintText: 'Password'.tr,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 14.w),
                  child: SvgPicture.asset(
                    'assets/icons/lock.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
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
              SizedBox(height: 8.h),

              /// ======================================> forgot password email ===============================>
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.forgotPasswordScreen,
                        parameters: {'email': enterEmailController.text},
                      );
                    },
                    child: CustomText(
                      text: 'Forgot Password'.tr,
                      fontsize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColors,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              /// =====================================> Lets go Button ===================================>
              Obx(() {
                return CustomButton(
                  loading: controller.logInLoading.value,
                  indicatorColor: Colors.white,
                  onTap: () {
                    if (!controller.logInLoading.value) {
                      controller.handleLogIn(
                        enterEmailController.text.trim(),
                        enterPasswordController.text.trim(),
                      );
                    }
                  },
                  text: 'Sign in'.tr,
                );
              }),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
