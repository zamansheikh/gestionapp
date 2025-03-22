import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/controllers/get_user_controller.dart';
import 'package:gestionapp/views/base/custom_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/profile_controller.dart';
import '../../../services/api_constants.dart';
import '../../../utils/app_colors.dart';
import '../../base/custom_loader.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  PersonalInformationScreenState createState() =>
      PersonalInformationScreenState();
}

class PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());
  final GetUserController controller = Get.put(GetUserController());
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        profileController.imageUpDateProfile(
          image: File(_selectedImage!.path),
          data: {
            "phone": phoneController.text.trim(),
            "name": nameController.text.trim(),
          },
        );
        debugPrint('+++++++++++++++++++$_selectedImage');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from the controller
    nameController.text = controller.getUserProfileModel.value.name ?? '';
    phoneController.text =
        controller.getUserProfileModel.value.phone ?? 'Not Available';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Information".tr,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        if (controller.getUserLoading.value) {
          return const Center(child: CustomLoader());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120.w, // Set width and height to be the same
                          height:
                              120.w, // Make height equal to width to keep it circular
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFB3F81),
                                Color(0xFFB749BB),
                                Color(0xFF8C4AEF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: ClipOval(
                              child:
                                  _selectedImage != null
                                      ? Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: 120.w,
                                        height:
                                            120.w, // Ensure this is a perfect circle
                                      )
                                      : Image.network(
                                        ApiConstants.imageBaseUrl +
                                            controller
                                                .getUserProfileModel
                                                .value
                                                .image!,
                                        fit: BoxFit.cover,
                                        width: 120.w,
                                        height:
                                            120.w, // Ensure this is a perfect circle
                                      ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.w, // Ensure this is also circular
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textColor,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),

                SizedBox(height: 16.h),

                /// Name
                _buildEditableField(
                  label: 'Name'.tr,
                  controller: nameController,
                  onChanged: (value) {
                    debugPrint('Name updated to: $value');
                  },
                ),
                SizedBox(height: 12.h),

                /// Email
                _buildInfoField(
                  label: 'Email'.tr,
                  value: '${controller.getUserProfileModel.value.email}',
                ),
                SizedBox(height: 12.h),

                /// Phone Number
                _buildEditableField(
                  label: 'Phone Number'.tr,
                  controller: phoneController,
                  onChanged: (value) {
                    debugPrint('Phone Number updated to: $value');
                  },
                ),
                SizedBox(height: 40.h),
                Center(
                  child: CustomButton(
                    onTap: () {
                      profileController.imageUpDateProfile(
                        image: _selectedImage,
                        data: {
                          "phone": phoneController.text.trim(),
                          "name": nameController.text.trim(),
                        },
                      );
                    },
                    text: 'Update'.tr,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.shadowColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),
            filled: true,
            fillColor: AppColors.backcolorsE6E6E6,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.subTextColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.subTextColor, width: 1),
            ),
          ),
          style: TextStyle(fontSize: 12.sp, color: AppColors.textColor),
        ),
      ],
    );
  }

  /// Helper to Build Info Fields
  Widget _buildInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.shadowColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backcolorsE6E6E6,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.subTextColor, width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textColor),
          ),
        ),
      ],
    );
  }
}
