import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isLeadingIcon;
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions, this.isLeadingIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isLeadingIcon == false ? const SizedBox() : null,
      centerTitle: true,
      title: CustomText(text: title, color: Colors.white, fontsize: 18.h,fontWeight: FontWeight.w600 ),
      actions: actions,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}