import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';


ThemeData light({Color color = const Color(0xFF039D55)}) => ThemeData(
    fontFamily: 'Assistant',
    iconTheme:  IconThemeData(color: AppColors.primaryColor),
    primaryColor: color,
    secondaryHeaderColor: const Color(0xFF1ED7AA),
    disabledColor: const Color(0xFFBABFC4),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,

    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: AppColors.primaryColor,
    //   elevation: 5,
    // ),
    // textButtonTheme: TextButtonThemeData(
    //     style: TextButton.styleFrom(foregroundColor: color)),
    // colorScheme: ColorScheme.light(primary: color, secondary: color)
    //     .copyWith(background: const Color(0xFFF3F3F3))
    //     .copyWith(error: Color(0xFFE84D4F)),
    appBarTheme:  const AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black), // Set app bar icons color to black
    ),


    datePickerTheme: DatePickerThemeData(
      dayStyle: TextStyle(color: AppColors.primaryColor, fontSize: 14.h),
      weekdayStyle: TextStyle(fontSize: 14.h, color: Colors.black),
    )
);