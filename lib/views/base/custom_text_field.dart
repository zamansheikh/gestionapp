import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged; // Added onChanged callback

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscure = '*',
    this.filColor,
    this.labelText,
    this.isPassword = false,
    this.onChanged, this.readOnly, this.onTap, // Initialize onChanged
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure!,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ??
              (value) {
            if (widget.isEmail == null) {
              if (value!.isEmpty) {
                return "Please enter ${widget.hintText!.toLowerCase()}";
              } else if (widget.isPassword) {
                bool data = AppConstants.passwordValidator.hasMatch(value);
                if (value.isEmpty) {
                  return "Please enter ${widget.hintText!.toLowerCase()}";
                } else if (!data) {
                  return "Insecure password detected.";
                }
              }
            } else {
              bool data = AppConstants.emailValidator.hasMatch(value!);
              if (value.isEmpty) {
                return "Please enter ${widget.hintText!.toLowerCase()}";
              } else if (!data) {
                return "Please check your email!";
              }
            }
            return null;
          },
      cursorColor: AppColors.black,
      obscureText: widget.isPassword ? obscureText : false, // Only obscure text if it's a password field
      style: TextStyle(color: AppColors.shadowColor, fontSize: 16.sp),
      onChanged: widget.onChanged, // Pass the onChanged callback to the TextFormField
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.filColor ?? const Color(0xFFE6E6E6),
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 20.w,
          vertical: widget.contentPaddingVertical ?? 20.w,
        ),
        // fillColor: widget.filColor,
        prefixIcon: widget.prefixIcon,
        focusedBorder: focusedBorder(),
        enabledBorder: enabledBorder(),
        errorBorder: errorBorder(),
        border: focusedBorder(),
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: toggle,
          child: _suffixIcon(
              obscureText ? Icons.visibility_off : Icons.visibility),
        )
            : widget.suffixIcon,
        prefixIconConstraints: BoxConstraints(minHeight: 24.w, minWidth: 24.w),
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
    );
  }

  _suffixIcon(IconData icon) {
    return Padding(padding: const EdgeInsets.all(12.0), child: Icon(icon));
  }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.r),
      borderSide: BorderSide(color: AppColors.shadowColor),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.r),
      borderSide: BorderSide(color: AppColors.shadowColor),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.r),
      borderSide: const BorderSide(color: Colors.red, width: 0.5),
    );
  }
}



