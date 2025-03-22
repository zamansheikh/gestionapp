import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController otpCTE;

  const CustomPinCodeTextField({
    super.key,
    required this.otpCTE,
  });

  static Color borderColor = const Color(0xFF8D4AED);
  static Color textColor = const Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      autoDisposeControllers: false,
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryColor,
      controller: otpCTE,
      textStyle: TextStyle(color: textColor),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderRadius: BorderRadius.circular(8),
        selectedColor: borderColor,
        activeFillColor: borderColor,
        selectedFillColor: borderColor,
        inactiveFillColor: AppColors.primaryColor,
        fieldHeight: 65.h,
        fieldWidth: 50.w,
        activeBorderWidth: 0.5,
        inactiveBorderWidth: 0.5,
        selectedBorderWidth: 0.5,
        inactiveColor: borderColor,
        activeColor: AppColors.primaryColor,
      ),
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        print("----value: $value");
      },
    );
  }
}
