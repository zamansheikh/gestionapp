import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../views/base/custom_text.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final Color? borderColor;
  final VoidCallback? onTap;
  const CustomListTile({
    super.key,
    required this.title,
    this.onTap,
    this.prefixIcon,
    this.sufixIcon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
                border: Border.all(width: 1.w, color: borderColor ?? AppColors.textColor)),
            child: ListTile(
              leading: prefixIcon,
              trailing: sufixIcon,
              horizontalTitleGap: 16.w,
              dense: true,
              title: CustomText(
                textAlign: TextAlign.left,
                text: title,
                maxline: 2,
                fontsize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            )
        ),
      ),
    );
  }
}
