import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoading extends StatelessWidget {
  final double? top;
  const CustomLoading({super.key, this.top});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(top: top ?? 0),
      child: SizedBox(
        height:  20.h,
        width: 20.h,
        child: const CircularProgressIndicator(color: Colors.pink,),
      ),
    );
  }
}
