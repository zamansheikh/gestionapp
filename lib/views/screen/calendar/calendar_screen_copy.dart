import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestionapp/controllers/calendar_controller.dart';
import 'package:gestionapp/helpers/date_utils.dart';
import 'package:gestionapp/helpers/logger.dart';
import 'package:gestionapp/views/screen/calendar/days_widgets.dart';
import 'package:get/get.dart';
import '../../../helpers/prefs_helper.dart';
import '../../../utils/app_constants.dart';

class CalenderScreenCopy extends StatefulWidget {
  const CalenderScreenCopy({super.key});

  @override
  State<CalenderScreenCopy> createState() => _CalenderScreenCopyState();
}

class _CalenderScreenCopyState extends State<CalenderScreenCopy> {
  int _selectedRoomIndex = 0;
  DateTime _focusedDay = DateTime.now();
  final _currentDate = DateTime.now();
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

  void resetButton() {
    setState(() {
      _selectedRoomIndex = 0;
      _isLoading = false;
      _isRoomLoading = false;
    });
  }

  // final CalendarController controller = Get.put(CalendarController());
  late final CalendarController controller;

  bool _isLoading = false; // Initial load
  bool _isRoomLoading = false; // Room change loading

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CalendarController>()) {
      controller = Get.put(CalendarController());
    } else {
      controller = Get.find<CalendarController>();
    }
    getCurrectUserId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCurrectUserId() async {
    setState(() {
      _isLoading = true;
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    await controller.calendarReserve(id: userID);
    if (controller.calenderModel.isNotEmpty) {
      "Logged in User ID: $userID".logW();
      "Room available and found first ID: ${controller.calenderModel.first.id!}"
          .logW();
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

  getCurrectUserIdSpecific(
    int rcvIndex,
    String startDate,
    String endDate,
  ) async {
    setState(() {
      _isRoomLoading = true; // Room-specific loading starts
    });
    final userID = await PrefsHelper.getString(AppConstants.user);
    // await controller.calendarReserve(id: userID); // No need to call again.
    if (controller.calenderModel.isNotEmpty) {
      "Logged in User ID: $userID".logW();
      "Room available for${controller.calenderModel[rcvIndex].id!}".logW();
      await controller.reservationProperty(
        id: controller.calenderModel[rcvIndex].id!,
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        _isRoomLoading = false; // Room loading finished
      });
    } else {
      setState(() {
        _isRoomLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    return Scaffold(
      backgroundColor: Colors.white,
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
                SizedBox(width: 55.w),
                Text('Calendar'.tr, style: TextStyle(fontSize: 20.sp)),
                Spacer(),
                IconButton(
                  onPressed: () {
                    resetButton();
                    getCurrectUserId();
                  },
                  icon: Icon(Icons.refresh, color: Colors.black),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simplified refresh: just update for the selected room and dates
          if (controller.calenderModel.isNotEmpty) {
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.w),
          child: Obx(() {
            // Initial loading
            if (_isLoading.obs.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle empty state
            if (controller.calenderModel.isEmpty) {
              return Center(
                child: Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                  'You have no reservation! Please contact with admin'.tr,
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.calenderModel.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    _selectedRoomIndex = index;
                                  });

                                  // Only call getCurrectUserIdSpecific, which sets _isRoomLoading.
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
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedRoomIndex == index
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
                                              _selectedRoomIndex == index
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
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // Year, Month Dropdowns, and Today Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Today Button
                    InkWell(
                      onTap: () {
                        setState(() {
                          _focusedDay = DateTime.now();
                          controller.selectedYear.value = DateTime.now().year;
                          controller.selectedMonth.value = DateTime.now().month;
                        });
                        // Call getCurrectUserIdSpecific for updated dates
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
                          border: Border.all(color: const Color(0xFF333333)),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(child: Text("Today".tr)),
                      ),
                    ),

                    // Year Dropdown
                    Container(
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
                            _focusedDay = DateTime(
                              controller.selectedYear.value,
                              controller.selectedMonth.value,
                            );
                          });
                          // Call getCurrectUserIdSpecific for updated year
                          if (controller.calenderModel.isNotEmpty) {
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
                            _focusedDay = DateTime(
                              controller.selectedYear.value,
                              controller.selectedMonth.value,
                            );
                          });
                          // Call getCurrectUserIdSpecific for updated month
                          if (controller.calenderModel.isNotEmpty) {
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
                const SizedBox(height: 8),
                // Days of the week row
                Container(
                  height: 40,
                  decoration: const BoxDecoration(color: Color(0xffF2F5F7)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Mon'.tr,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tue'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Wed'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Thu'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Fri'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sat'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sun'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendar Grid (Use Expanded to fill remaining space)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child:
                        _isRoomLoading // Conditionally show loading indicator
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                              decoration: const BoxDecoration(),
                              child: GridView.count(
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 2.0,
                                crossAxisCount: 7,
                                children: buildCalendarDays(
                                  dateToday: _currentDate,
                                  date: firstDayOfMonth,
                                  controller: controller,
                                  selectedMonth: controller.selectedMonth.value,
                                  selectedYear: controller.selectedYear.value,
                                ),
                              ),
                            ),
                  ),
                ),
                // Events Section
                const SizedBox(height: 8.0),
              ],
            );
          }),
        ),
      ),
    );
  }
}
