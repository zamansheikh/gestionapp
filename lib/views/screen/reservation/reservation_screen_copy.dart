import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/controllers/calendar_controller.dart';
import 'package:gestionapp/controllers/cred_controller.dart';
import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/models/reservation_model.dart';
import 'package:gestionapp/views/screen/reservation/reservation_detail_screen.dart';
import 'package:get/get.dart';
import '../../../helpers/date_utils.dart';
import '../../../helpers/prefs_helper.dart';
import '../../../utils/app_constants.dart';

class ReservationsScreenCopy extends StatefulWidget {
  const ReservationsScreenCopy({super.key});

  @override
  State<ReservationsScreenCopy> createState() => _ReservationsScreenCopyState();
}

class _ReservationsScreenCopyState extends State<ReservationsScreenCopy> {
  final CredController credController = Get.put(CredController());
  final RxBool isAnyRoomAvailable = false.obs; // No need for this to be RxBool
  bool _isLoading = false; // Initial loading
  bool _isRoomLoading =
      false; // Loading indicator for when changing room selection
  final CalendarController controller = Get.put(CalendarController());

  // DateTime _focusedDay = DateTime.now();  // Not used in this screen
  void resetButton() {
    setState(() {
      controller.selectedRoomIndex.value = 0;
      _isLoading = false;
      _isRoomLoading = false;
      isAnyRoomAvailable.value = false;
    });
  }

  final List<int> _years = List.generate(
    7,
    (index) => DateTime.now().year - 3 + index,
  );
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
    // getCurrectUserId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCurrectUserId() async {
    setState(() {
      _isLoading = true; // Initial load
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    await controller.calendarReserve(id: userID);

    // Simplify: The logic is the same for admin and non-admin users.
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
      _isLoading = false; // Initial loading done.
    });
  }

  getCurrectUserIdSpecific(
    int rcvIndex,
    String startDate,
    String endDate,
  ) async {
    setState(() {
      _isRoomLoading = true; // Room-specific loading starts.
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    // No need to call calendarReserve again. We already have the room data.
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
    }
    setState(() {
      _isRoomLoading =
          false; // Room-specific loading is done (regardless of success/failure)
    });
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
                SizedBox(width: 50.w),
                Text('Reservation'.tr, style: TextStyle(fontSize: 20.sp)),
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
            // Simplified refresh logic: No role check, always refresh for the selected room
            if (controller.calenderModel.isNotEmpty) {
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
            child: Column(
              children: [
                // Year, Month Dropdowns, and Today Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Today Button
                    InkWell(
                      onTap: () {
                        setState(() {
                          // No need for _focusedDay in this screen
                          controller.selectedYear.value = DateTime.now().year;
                          controller.selectedMonth.value = DateTime.now().month;
                        });
                        if (controller.calenderModel.isNotEmpty) {
                          getCurrectUserIdSpecific(
                            controller.selectedRoomIndex.value,
                            DateUtilsx.getStartDateOfMonth(),
                            DateUtilsx.getEndDateOfMonth(),
                          );
                        }
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF333333)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(child: Text("Today".tr)),
                      ),
                    ),

                    // Year Dropdown
                    Obx(() {
                      return Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF333333)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButton<int>(
                          value: controller.selectedYear.value,
                          items:
                              _years.map((year) {
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              controller.selectedYear.value = value!;
                            });
                            if (controller.calenderModel.isNotEmpty) {
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
                          underline: const SizedBox(),
                        ),
                      );
                    }),

                    // Month Dropdown
                    Obx(() {
                      return Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF333333)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButton<int>(
                          value: controller.selectedMonth.value,
                          items: List.generate(_months.length, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(_months[index].tr),
                            );
                          }),
                          onChanged: (value) async {
                            setState(() {
                              controller.selectedMonth.value = value!;
                            });
                            if (controller.calenderModel.isNotEmpty) {
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
                          underline: const SizedBox(),
                        ),
                      );
                    }),
                  ],
                ),

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
                                    controller.selectedRoomIndex.value = index;
                                  });

                                  // No role check needed, logic is the same
                                  if (controller.calenderModel.isNotEmpty) {
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
                                          controller.selectedRoomIndex.value ==
                                                  index
                                              ? const Color(0xFFD80665)
                                              : const Color(0xFFE6E6E6),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: .5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
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
                // Use Obx to react to changes in isLoading, isRoomLoading, and reservationModel
                Obx(() {
                  // Initial loading
                  if (_isLoading.obs.value) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Room-specific loading
                  if (_isRoomLoading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Check if reservation data is available and not empty
                  List<Reservation> reservation = [];
                  if (controller.reservationModel.isNotEmpty) {
                    reservation =
                        controller.reservationModel.first.reservations;
                  }

                  // Handle empty reservations
                  if (reservation.isEmpty) {
                    return Expanded(
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

                  // Display the reservation list
                  return Expanded(
                    child: ListView.builder(
                      itemCount: reservation.length,
                      itemBuilder: (context, index) {
                        // Show only Confirmed reservations
                        if (reservation[index].status == "Confirmed") {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ReservationDetailScreen(
                                  reservation: reservation[index],
                                  roomName:
                                      controller
                                          .reservationModel
                                          .first
                                          .roomName,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6E6),
                                borderRadius: BorderRadius.circular(8),
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
                                        " ${controller.reservationModel.first.roomName}",
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
                                          " ${reservation[index].customerName}",
                                          overflow: TextOverflow.ellipsis,
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
                                        " ${reservation[index].rooms.first.dfrom}",
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
                                        " ${reservation[index].rooms.first.dto}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Important: Use SizedBox.shrink() for efficiency
                        }
                      },
                    ),
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
