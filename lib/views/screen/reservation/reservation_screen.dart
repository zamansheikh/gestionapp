import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/controllers/cred_controller.dart';
import 'package:gestionapp/controllers/reservation_controller.dart';
import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/models/reservation_model.dart';
import 'package:gestionapp/views/screen/reservation/reservation_detail_screen.dart';
import 'package:get/get.dart';
import '../../../helpers/date_utils.dart';
import '../../../helpers/prefs_helper.dart';
import '../../../utils/app_constants.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final CredController credController = Get.put(CredController());
  int _selectedRoomIndex = 0;
  RxBool isAnyRoomAvailable = false.obs;
  bool _isLoading = false;
  final ReservationController controller = Get.put(ReservationController());
  // DateTime _focusedDay = DateTime.now();

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
    getCurrectUserId();
  }

  getCurrectUserId() async {
    setState(() {
      _isLoading = true;
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    await controller.calendarReserve(id: userID);
    if (credController.userRole.value == 'admin') {
      if (controller.calenderModel.isNotEmpty) {
        "Logged in User ID: $userID".logW();
        "RoomID: ${controller.calenderModel.first.id!}".logW();
        await controller.reservationProperty(
          id: controller.calenderModel.first.id!,
          startDate: DateUtilsx.getStartDateOfMonth(),
          endDate: DateUtilsx.getEndDateOfMonth(),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (controller.calenderModel.isNotEmpty) {
        "Logged in User ID: $userID".logW();
        "RoomID: ${controller.calenderModel.first.id!}".logW();
        await controller.reservationProperty(
          id: controller.calenderModel.first.id!,
          startDate: DateUtilsx.getStartDateOfMonth(),
          endDate: DateUtilsx.getEndDateOfMonth(),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  getCurrectUserIdSpecific(
    int rcvIndex,
    String startDate,
    String endDate,
  ) async {
    setState(() {
      _isLoading = true;
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    await controller.calendarReserve(id: userID);
    if (controller.calenderModel.isNotEmpty) {
      "Logged in User ID: $userID".logW();
      "Room available for ROOM: ${controller.calenderModel[rcvIndex].id!}"
          .logW();
      await controller.reservationProperty(
        id: controller.calenderModel[rcvIndex].id!,
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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
                Spacer(),
                Text('Reservation'.tr, style: TextStyle(fontSize: 20.sp)),
                Spacer(),
                const SizedBox(width: 94),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (controller.calenderModel.isNotEmpty) {
              "Room available and found for Room- : ${controller.calenderModel[_selectedRoomIndex].roomName}"
                  .logW();
              if (credController.userRole.value == 'admin') {
                // getCurrectUserIdSpecific(
                //   index,
                //   "01/${controller.fixedMonthStart}/${controller.fixedYearStart}",
                //   DateUtilsx
                //       .getEndDateFromMonthAndYear(
                //           controller.fixedMonthEnd,
                //           controller.fixedYearEnd),
                // );
                getCurrectUserIdSpecific(
                  _selectedRoomIndex,
                  "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                  DateUtilsx.getEndDateFromMonthAndYear(
                    controller.selectedMonth.value,
                    controller.selectedYear.value,
                  ),
                );
              } else {
                getCurrectUserIdSpecific(
                  _selectedRoomIndex,
                  "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                  DateUtilsx.getEndDateFromMonthAndYear(
                    controller.selectedMonth.value,
                    controller.selectedYear.value,
                  ),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                (_isLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        // Year, Month Dropdowns, and Today Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Today Button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  controller.selectedYear.value =
                                      DateTime.now().year;
                                  controller.selectedMonth.value =
                                      DateTime.now().month;
                                });
                                if (controller.calenderModel.isNotEmpty) {
                                  getCurrectUserIdSpecific(
                                    _selectedRoomIndex,
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
                                  border: Border.all(
                                    color: const Color(0xFF333333),
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(child: Text("Today".tr)),
                              ),
                            ),

                            // Year Dropdown
                            Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF333333),
                                ),
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
                                    // _focusedDay = DateTime(
                                    //   controller.selectedYear.value,
                                    //   controller.selectedMonth.value,
                                    // );
                                  });
                                  if (controller.calenderModel.isNotEmpty) {
                                    "Room available and found for Room- : ${controller.calenderModel[_selectedRoomIndex].roomName}"
                                        .logW();
                                    getCurrectUserIdSpecific(
                                      _selectedRoomIndex,
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
                            ),

                            // Month Dropdown
                            Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF333333),
                                ),
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
                                    // _focusedDay = DateTime(
                                    //   controller.selectedYear.value,
                                    //   controller.selectedMonth.value,
                                    // );
                                  });
                                  if (controller.calenderModel.isNotEmpty) {
                                    "Room available: ${controller.calenderModel[_selectedRoomIndex].roomName}"
                                        .logW();
                                    getCurrectUserIdSpecific(
                                      _selectedRoomIndex,
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
                            ),
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
                                        onTap: () {
                                          setState(() {
                                            _selectedRoomIndex = index;
                                          });
                                          //Call API of ROOM HERE

                                          if (controller
                                              .calenderModel
                                              .isNotEmpty) {
                                            "Room available and found for Room- : ${controller.calenderModel[index].roomName}"
                                                .logW();
                                            if (credController.userRole.value ==
                                                'admin') {
                                              // getCurrectUserIdSpecific(
                                              //   index,
                                              //   "01/${controller.fixedMonthStart}/${controller.fixedYearStart}",
                                              //   DateUtilsx
                                              //       .getEndDateFromMonthAndYear(
                                              //           controller.fixedMonthEnd,
                                              //           controller.fixedYearEnd),
                                              // );
                                              getCurrectUserIdSpecific(
                                                index,
                                                "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                                                DateUtilsx.getEndDateFromMonthAndYear(
                                                  controller
                                                      .selectedMonth
                                                      .value,
                                                  controller.selectedYear.value,
                                                ),
                                              );
                                            } else {
                                              getCurrectUserIdSpecific(
                                                index,
                                                "01/${controller.selectedMonth.value}/${controller.selectedYear.value}",
                                                DateUtilsx.getEndDateFromMonthAndYear(
                                                  controller
                                                      .selectedMonth
                                                      .value,
                                                  controller.selectedYear.value,
                                                ),
                                              );
                                            }
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                _selectedRoomIndex == index
                                                    ? const Color(0xFFD80665)
                                                    : const Color(0xFFE6E6E6),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
                                                      _selectedRoomIndex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                          List<Reservation> reservation = [];
                          if (controller.reservationModel.isNotEmpty) {
                            reservation =
                                controller.reservationModel.first.reservations;
                          }

                          if (_isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (reservation.isEmpty) {
                            return Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.sp),
                                'You have no reservations. Please contact with admin.'
                                    .tr,
                              ),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemCount: reservation.length,
                              itemBuilder: (context, index) {
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
                                  return Container();
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
