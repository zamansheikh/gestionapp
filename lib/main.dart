import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/firebase_options.dart';
import 'package:gestionapp/helpers/firebase_notification_service.dart';
// import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/routes/routes.dart';
import 'package:gestionapp/themes/light_theme.dart';
import 'package:gestionapp/utils/app_constants.dart';
import 'package:gestionapp/utils/message.dart';
import 'package:get/get.dart';
import 'helpers/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationService.initialize();
  // await PrefsHelper.setString(AppConstants.bearerToken, "Demo token");
  // await PrefsHelper.setString(AppConstants.email, "demo@email.com");
  // await PrefsHelper.setString(AppConstants.user, "demoUserId");
  // await PrefsHelper.setString(AppConstants.role, "admin");
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          theme: light(),
          defaultTransition: Transition.topLevel,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(
            AppConstants.languages[0].languageCode,
            AppConstants.languages[0].countryCode,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}
