import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/new_client_profile.dart';

class NewClientCreateScreen extends StatefulWidget {
  const NewClientCreateScreen({super.key});

  @override
  State<NewClientCreateScreen> createState() => _NewClientCreateScreenState();
}

class _NewClientCreateScreenState extends State<NewClientCreateScreen> {
  final NewClientCreateController controller =
      Get.put(NewClientCreateController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Client Create".tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 207.h),
              ProTextField(
                controller: nameController,
                label: 'Name'.tr,
                icon: Icons.person,
                isPassword: false,
              ),
              SizedBox(height: 16.h),
              ProTextField(
                controller: emailController,
                label: 'E-mail'.tr,
                icon: Icons.email,
                isPassword: false,
              ),
              SizedBox(height: 16.h),
              ProTextField(
                controller: passController,
                label: 'Password'.tr,
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 40.h),
              GestureDetector(
                onTap: () {
                  if (passController.text.length < 8) {
                    Get.snackbar(
                      'Error',
                      'Password must be at least 8 characters long',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    controller.createClient(
                      email: emailController.text,
                      name: nameController.text,
                      password: passController.text,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      'Create Client'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ProTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  const ProTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.icon,
      required this.isPassword});

  @override
  State<ProTextField> createState() => _ProTextFieldState();
}

class _ProTextFieldState extends State<ProTextField> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: Colors.grey[700],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword ? !isPasswordVisible : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.label,
                hintStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          if (widget.isPassword)
            IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[700],
              ),
            ),
        ],
      ),
    );
  }
}
