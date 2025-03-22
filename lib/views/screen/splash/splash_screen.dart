// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gestionapp/controllers/cred_controller.dart';
import 'package:gestionapp/controllers/localization_controller.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CredController credController = Get.put(CredController());
  final LocalizationController _localizationController =
      Get.find<LocalizationController>();
  final RxList locale =
      [
        {"name": "English", "locale": const Locale("en", "US")},
        {"name": "Spanish", "locale": const Locale("sp", "SP")},
      ].obs;

  void setLanguage() async {
    int index = 0;
    var data = AppConstants.languages[index];
    try {
      index = await PrefsHelper.getInt(AppConstants.language);
      data = AppConstants.languages[(index == -1) ? 0 : index];
    } catch (e) {
      print("Language is not setted yet");
      index = 0;
    } finally {
      _localizationController.setLanguage(
        Locale(data.languageCode, data.countryCode),
      );
    }
  }

  @override
  void initState() {
    setLanguage();
    jump();
    super.initState();
  }

  jump() async {
    Future.delayed(const Duration(seconds: 3), () async {
      //Get Date from shered prefrences
      String loginToken = await PrefsHelper.getString(AppConstants.bearerToken);
      String logInEmail = await PrefsHelper.getString(AppConstants.email);
      if (loginToken.isNotEmpty && logInEmail.isNotEmpty) {
        Get.offAllNamed(AppRoutes.homePage);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Image.asset(
          AppImages.splashBgImage,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
