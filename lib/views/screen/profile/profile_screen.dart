import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestionapp/routes/routes.dart';
import 'package:gestionapp/views/screen/profile/personal_information.dart';
import 'package:get/get.dart';
import '../../../controllers/get_user_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../services/api_constants.dart';
import '../../../utils/app_colors.dart';
import '../../base/custom_page_loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final GetUserController _userController = Get.put(GetUserController());

  @override
  void initState() {
    _userController.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(
        () =>
            _userController.getUserLoading.value
                ? const CustomPageLoading()
                : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 40.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),
                      _profileHeader(),
                      SizedBox(height: 36.h),
                      _profileOption(
                        label: 'Personal Information'.tr,
                        iconPath: 'assets/icons/personal.svg',
                        onTap: () async {
                          await Get.to(() => const PersonalInformationScreen());
                          _userController.getUserProfile();
                        },
                      ),
                      _divider(),
                      _profileOption(
                        label: 'Settings'.tr,
                        iconPath: 'assets/icons/setting.svg',
                        onTap:
                            () =>
                                controller.navigateTo(AppRoutes.settingsScreen),
                      ),
                      _divider(),
                      _profileOption(
                        label: 'Log Out'.tr,
                        iconPath: 'assets/icons/logout.svg',
                        onTap: controller.showLogoutDialog,
                        isLogout: true,
                      ),
                      _divider(),
                    ],
                  ),
                ),
      ),
      // bottomNavigationBar: const BottomMenu(2),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Divider(
        color: AppColors.greyColor.withValues(alpha: .4),
        thickness: 1.1,
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120.w,
               height: 120.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFB3F81),
                    Color(0xFFB749BB),
                    Color(0xFF8C4AEF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: ClipOval(
                  child: Image.network(
                    ApiConstants.imageBaseUrl +
                        _userController.getUserProfileModel.value.image!,
                    fit: BoxFit.cover,
                    width: 120.w,
                    height: 120.w,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          _userController.getUserProfileModel.value.name!.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _profileOption({
    required String label,
    required String iconPath,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 24.w,
                  color: isLogout ? AppColors.redColor : AppColors.textColor,
                ),
                SizedBox(width: 16.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isLogout ? AppColors.redColor : AppColors.textColor,
                    fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (!isLogout)
              SvgPicture.asset(
                'assets/icons/chevron.svg',
                width: 8.w,
                color: AppColors.textColor,
              ),
          ],
        ),
      ),
    );
  }
}
