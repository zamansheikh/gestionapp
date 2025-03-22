import 'package:gestionapp/views/base/bottom_nav.dart';
import 'package:gestionapp/views/screen/admin/admin_profile_screen.dart';
import 'package:gestionapp/views/screen/admin/newclient_create_screen.dart';
import 'package:gestionapp/views/screen/admin/userlist_screen.dart';
import 'package:gestionapp/views/screen/auth/login/login_screen.dart';
import 'package:gestionapp/views/screen/auth/resetPass/reset_password_screen.dart';
import 'package:gestionapp/views/screen/calendar/calendar_screen.dart';
import 'package:gestionapp/views/screen/profile/change_password.dart';
import 'package:gestionapp/views/screen/profile/personal_information.dart';
import 'package:gestionapp/views/screen/profile/privacy_policy_screen.dart';
import 'package:gestionapp/views/screen/profile/profile_screen.dart';
import 'package:gestionapp/views/screen/profile/settings_screen.dart';
import 'package:gestionapp/views/screen/profile/terms_services.dart';
import 'package:gestionapp/views/screen/reservation/reservation_screen.dart';
import 'package:gestionapp/views/screen/reservation/resgister_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../views/screen/auth/forgetPassword/forget_password_screen.dart';
import '../views/screen/auth/verifyEmail/verify_email_screen.dart';
import '../views/screen/profile/change_language_screen.dart';
import '../views/screen/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = "/SplashScreen.dart";
  static const String signIn = "/SignIn.dart";
  static const String reservationsScreen = "/ReservationsScreen.dart";
  static const String calenderScreen = "/CalenderScreen.dart";
  static const String profileScreen = "/ProfileScreen.dart";
  static const String personalInformation = "/PersonalInformation.dart";
  static const String settingsScreen = "/SettingsScreen.dart";
  static const String changePassword = "/ChangePassword.dart";
  static const String privacyPolicyScreen = "/privacyPolicyScreen.dart";
  static const String termsServicesScreen = "/TermsServicesScreen.dart";
  static const String adminProfileScreen = "/AdminProfileScreen.dart";
  static const String newClientCreateScreen = "/NewClientCreateScreen.dart";
  static const String userListScreen = "/UserListScreen.dart";
  static const String forgotPasswordScreen = "/ForgotPasswordScreen.dart";
  static const String verifyEmailScreen = "/VerifyEmailScreen.dart";
  static const String resetPassScreen = "/ResetPassScreen.dart";
  static String changeLanguageScreen = "/ChangeLanguageScreen";
  static String homePage = "/HomePage";
  static String registerScreen = "/registerScreen";

  static List<GetPage> get routes => [
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: reservationsScreen, page: () => const ReservationsScreen()),
    GetPage(name: calenderScreen, page: () => const CalenderScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(
      name: personalInformation,
      page: () => const PersonalInformationScreen(),
    ),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
    GetPage(name: changePassword, page: () => const ChangePasswordScreen()),
    GetPage(name: privacyPolicyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsServicesScreen, page: () => const TermsServicesScreen()),
    GetPage(name: adminProfileScreen, page: () => const AdminProfileScreen()),
    GetPage(
      name: newClientCreateScreen,
      page: () => const NewClientCreateScreen(),
    ),
    GetPage(name: userListScreen, page: () => const UserListScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmailScreen, page: () => VerifyEmailScreen()),
    GetPage(name: resetPassScreen, page: () => ResetPasswordScreen()),
    GetPage(name: registerScreen, page: () => const RegisterScreen()),
    GetPage(
      name: changeLanguageScreen,
      page: () => const ChangeLanguageScreen(),
      transition: Transition.noTransition,
    ),
  ];
}
