import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      this.maxline,
      this.textOverflow,
      this.fontName,
      this.textAlign = TextAlign.center,
      this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0,
      this.softWrap = true,
      this.fontsize,
      this.textHeight,
      this.fontWeight = FontWeight.w400,
      this.color,
      this.text = ""});

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double? fontsize;
  final FontWeight fontWeight;
  final Color? color;
  final String text;
  final TextAlign textAlign;
  final int? maxline;
  final String? fontName;
  final double? textHeight;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        textAlign: textAlign,
        text.tr,
        maxLines: maxline,
        overflow: textOverflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontsize ?? 14.h,
          decorationColor: AppColors.backgroundColor,
          fontFamily: fontName ?? "Assistant",
          fontWeight: fontWeight,
          color: color ?? AppColors.shadowColor,
          height: textHeight,
        ),
      ),
    );
  }
}
