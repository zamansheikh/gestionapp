import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestionapp/controllers/cred_controller.dart';
import 'package:gestionapp/views/screen/admin/admin_profile_screen.dart';
import 'package:gestionapp/views/screen/calendar/calendar_screen_copy.dart';
// import 'package:gestionapp/views/screen/calendar/calendar_screen.dart';
import 'package:gestionapp/views/screen/profile/profile_screen.dart';
import 'package:gestionapp/views/screen/reservation/reservation_screen_copy.dart';
// import 'package:gestionapp/views/screen/reservation/reservation_screen.dart';
import 'package:gestionapp/views/screen/reservation/resgister_screen_copy.dart';
// import 'package:gestionapp/views/screen/reservation/resgister_screen.dart';
import 'package:get/get.dart';
import '../../utils/app_icons.dart';

class BottomNav extends StatelessWidget {
  final CredController credController;

  const BottomNav(this.credController, {super.key});

  Color colorByIndex(ThemeData theme, int index, int currentIndex) {
    return index == currentIndex ? Colors.white : theme.disabledColor;
  }

  BottomNavigationBarItem getItem(
    String image,
    String title,
    ThemeData theme,
    int index,
    int currentIndex,
  ) {
    return BottomNavigationBarItem(
      label: title,
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SvgPicture.asset(
          image,
          height: 24.0,
          width: 24.0,
          color: colorByIndex(theme, index, currentIndex),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      int currentIndex = credController.navIndex.value;
      List<BottomNavigationBarItem> menuItems = [
        getItem(AppIcons.calenderIcon, 'Calendar'.tr, theme, 0, currentIndex),
        getItem(AppIcons.reserveIcon, 'Reservation'.tr, theme, 1, currentIndex),
        getItem(AppIcons.register, 'Events'.tr, theme, 2, currentIndex),
        getItem(AppIcons.profileIcon, 'Profile'.tr, theme, 3, currentIndex),
      ];

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.black,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            currentIndex: currentIndex,
            onTap: (value) {
              credController.navIndex.value = value;
            },
            items: menuItems,
          ),
        ),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CredController credController = Get.put(CredController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: credController.navIndex.value,
          children: [
            const CalenderScreenCopy(),
            const ReservationsScreenCopy(),
            const RegisterScreenCopy(),
            if (credController.userRole.value == 'admin')
              const AdminProfileScreen(),
            if (credController.userRole.value == 'user') const ProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: BottomNav(credController),
    );
  }
}
