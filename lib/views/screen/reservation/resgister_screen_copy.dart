// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/controllers/calendar_controller.dart';
import 'package:gestionapp/controllers/cred_controller.dart';
import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/views/screen/reservation/reservation_detail_screen.dart';
import 'package:get/get.dart';
import '../../../helpers/date_utils.dart';
import '../../../helpers/prefs_helper.dart';
import '../../../utils/app_constants.dart';

class RegisterScreenCopy extends StatefulWidget {
  const RegisterScreenCopy({super.key});

  @override
  State<RegisterScreenCopy> createState() => _RegisterScreenCopyState();
}

class _RegisterScreenCopyState extends State<RegisterScreenCopy> {
  final CredController credController = Get.put(CredController());
  RxBool isAnyRoomAvailable = false.obs;
  bool _isLoading = false;
  bool _isRoomLoading = false; // Separate loading indicator for room data

  void resetButton() {
    setState(() {
      controller.selectedRoomIndex.value = 0;
      _isLoading = false;
      _isRoomLoading = false;
      isAnyRoomAvailable.value = false;
    });
  }

  // final RegisterController controller = Get.put(RegisterController());
  late CalendarController controller;
  final DateTime _focusedDay = DateTime.now();
  final List<int> _years = List.generate(50, (index) => 2000 + index);
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CalendarController>()) {
      controller = Get.put(CalendarController());
    } else {
      controller = Get.find<CalendarController>();
    }
    // getCurrectUserId();
  }

  getCurrectUserId() async {
    setState(() {
      _isLoading = true; // Initial load
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    await controller.calendarReserve(id: userID);
    // No role-based difference here, both cases are identical.  Combine them.
    if (controller.calenderModel.isNotEmpty) {
      "Logged in User ID: $userID".logW();
      "RoomID: ${controller.calenderModel.first.id!}".logW();
      await controller.reservationProperty(
        id: controller.calenderModel.first.id!,
        startDate: DateUtilsx.getStartDateOfMonth(),
        endDate: DateUtilsx.getEndDateOfMonth(),
      );
    }
    setState(() {
      _isLoading = false; // Initial loading done
    });
  }

  getCurrectUserIdSpecific(
    int rcvIndex,
    String startDate,
    String endDate,
  ) async {
    setState(() {
      _isRoomLoading =
          true; // Set room-specific loading to true before API call.
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    //No need to call `calendarReserve` again. It's fetched on init, and we use indices.
    // await controller.calendarReserve(id: userID);  //  <-- REMOVE THIS
    if (controller.calenderModel.isNotEmpty) {
      "Logged in User ID: $userID".logW();
      "Room available for ROOM: ${controller.calenderModel[rcvIndex].id!}"
          .logW();
      await controller.reservationProperty(
        id: controller.calenderModel[rcvIndex].id!,
        startDate: startDate,
        endDate: endDate,
      );
      await controller.reservationPropertylog(
        id: controller.calenderModel[rcvIndex].id!,
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        _isRoomLoading = false; // Room-specific loading is done.
      });
    } else {
      setState(() {
        _isRoomLoading =
            false; // Also set to false if no rooms (important for edge cases)
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h), // Adjust height as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Row(
              children: [
                const SizedBox(width: 24),
                Image.asset('assets/images/splash.png', width: 70.w),
                SizedBox(width: 65.w),
                Text('Events'.tr, style: TextStyle(fontSize: 20.sp)),
                Spacer(),
                // IconButton(
                //   onPressed: () {
                //     resetButton();
                //     getCurrectUserId();
                //   },
                //   icon: Icon(Icons.refresh, color: Colors.black),
                // ),
                const SizedBox(width: 24),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (controller.calenderModel.isNotEmpty) {
              //  No need to check role here, the logic is identical
              getCurrectUserIdSpecific(
                controller.selectedRoomIndex.value,
                "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                DateUtilsx.getEndDateFromMonthAndYear(
                  controller.selectedMonth.value,
                  controller.selectedYear.value,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Show during initial load
                    : Column(
                      children: [
                        const SizedBox(height: 10),
                        Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.calenderModel.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            controller.selectedRoomIndex.value =
                                                index;
                                          });

                                          // No role-based difference, simplify!
                                          if (controller
                                              .calenderModel
                                              .isNotEmpty) {
                                            "Room available and found for Room- : ${controller.calenderModel[index].roomName}"
                                                .logW();
                                            getCurrectUserIdSpecific(
                                              index,
                                              "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                                              DateUtilsx.getEndDateFromMonthAndYear(
                                                controller.selectedMonth.value,
                                                controller.selectedYear.value,
                                              ),
                                            );
                                          }
                                        },
                                        child: Obx(() {
                                          return Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color:
                                                  controller
                                                              .selectedRoomIndex
                                                              .value ==
                                                          index
                                                      ? const Color(0xFFD80665)
                                                      : const Color(0xFFE6E6E6),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: .5,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                              child: Center(
                                                child: Text(
                                                  '${controller.calenderModel[index].roomName}',
                                                  style: TextStyle(
                                                    color:
                                                        controller
                                                                    .selectedRoomIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          // Use _isRoomLoading for the room-specific indicator
                          if (_isRoomLoading) {
                            return const Expanded(
                              // Important: Use Expanded here
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (controller.reservationLogModel.isEmpty) {
                            return Expanded(
                              // Important for the empty case too
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.sp),
                                  'You have no reservations. Please contact with admin.'
                                      .tr,
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            // Wrap ListView.builder with Expanded
                            child: Obx(() {
                              return ListView.builder(
                                itemCount:
                                    controller
                                        .reservationLogModel
                                        .first
                                        .reservations
                                        .length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ReservationDetailScreen(
                                          reservation:
                                              controller
                                                  .reservationLogModel
                                                  .first
                                                  .reservations[index],
                                          roomName:
                                              controller
                                                  .reservationLogModel
                                                  .first
                                                  .roomName,
                                        ),
                                      );
                                    },
                                    child: Obx(() {
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6E6E6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Accommodation Name:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " ${controller.reservationLogModel.first.roomName}",
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Booking Status:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " ${controller.reservationLogModel.first.reservations[index].status}",
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Created at:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    " ${controller.reservationLogModel.first.reservations[index].created}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Customer Name:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    " ${controller.reservationLogModel.first.reservations[index].customerName}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Check In:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " ${controller.reservationLogModel.first.reservations[index].rooms.first.dfrom}",
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              children: [
                                                Text(
                                                  'Check Out:'.tr,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " ${controller.reservationLogModel.first.reservations[index].rooms.first.dto}",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                },
                              );
                            }),
                          );
                        }),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
