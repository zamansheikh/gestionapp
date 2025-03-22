// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';
import '../utils/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  RxInt selectedLanguage = 0.obs;

  void loadLanguage() async {
    PrefsHelper.getInt(AppConstants.language).then((value) {
      selectedLanguage.value = value;
    });
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
    AppConstants.languages[0].languageCode,
    AppConstants.languages[0].countryCode,
  );
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'es') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
          AppConstants.languages[0].languageCode,
      sharedPreferences.getString(AppConstants.COUNTRY_CODE) ??
          AppConstants.languages[0].countryCode,
    );
    _isLtr = _locale.languageCode != 'es';
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(
      AppConstants.LANGUAGE_CODE,
      locale.languageCode,
    );
    sharedPreferences.setString(
      AppConstants.COUNTRY_CODE,
      locale.countryCode ?? "",
    );
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      AppConstants.languages.forEach((language) async {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      });
    }
    update();
  }
}
