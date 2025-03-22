import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:get/get.dart';
import '../../../controllers/localization_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../base/custom_text.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final RxList locale =
      [
        {"name": "English", "locale": const Locale("en", "US")},
        {"name": "Spanish", "locale": const Locale("sp", "SP")},
      ].obs;

  final RxInt selectedLanguage = 0.obs;

  @override
  void initState() {
    PrefsHelper.getInt(AppConstants.language).then((value) {
      selectedLanguage.value = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language'.tr)),
      body: GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AppConstants.languages.length,
                  itemBuilder: (context, index) {
                    var data = AppConstants.languages[index];
                    return GestureDetector(
                      onTap: () {
                        selectedLanguage.value = index;
                        PrefsHelper.setInt(AppConstants.language, index);
                        localizationController.setLanguage(
                          Locale(data.languageCode, data.countryCode),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: AppConstants.languages[index].languageName,
                              top: 16.h,
                              bottom: 16.h,
                              left: 12.w,
                            ),
                            Obx(
                              () => Container(
                                margin: EdgeInsets.only(right: 12.w),
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      selectedLanguage.value == index
                                          ? Border.all(
                                            color: AppColors.primaryColor,
                                            width: 3.r,
                                          )
                                          : Border.all(
                                            color: Colors.black,
                                            width: 1.5.r,
                                          ),
                                  color:
                                      selectedLanguage.value == index
                                          ? Colors.black
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
