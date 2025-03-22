import 'package:flutter/material.dart';
import 'package:gestionapp/controllers/calendar_controller.dart';
import 'package:gestionapp/helpers/date_utils.dart';
import 'package:gestionapp/views/base/calender_cell.dart';

List<Widget> buildCalendarDays({
  required DateTime dateToday,
  required DateTime date,
  required CalendarController controller,
  required int selectedMonth,
  required int selectedYear,
}) {
  final List<Widget> days = [];
  final firstDayOfMonth = DateTime(date.year, date.month, 1);
  final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
  final firstDayOfWeek = firstDayOfMonth.weekday;
  final totalDays = lastDayOfMonth.day;

  List<String> roomBookStartList = [];
  List<String> roomBookEndList = [];
  String currentDate = DateUtilsx.getFormattedCurrentDate();
  if (controller.reservationModel.isNotEmpty) {
    for (var room in controller.reservationModel.first.reservations) {
      if (room.status == "Confirmed") {
        roomBookStartList.add(room.rooms.first.dfrom);
        roomBookEndList.add(room.rooms.first.dto);
      }
    }
  }

  //! isBookedOrNot Method
  bool isBookedOrNot(int day) {
    bool isFound = false;
    for (int i = 0; i < roomBookStartList.length; i++) {
      String customDate = "$day/$selectedMonth/$selectedYear";
      if (controller.reservationModel.isNotEmpty) {
        if ((roomBookStartList[i].length > 3) &&
            (roomBookEndList[i].length > 3)) {
          if (DateUtilsx.isDateBetween(
            customDate,
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            isFound = true;
          }
        }
      }
    }
    return isFound;
  }

  //! getBookingStatus
  BookingStatus getBookingStatus(int day) {
    String customDate = "$day/$selectedMonth/$selectedYear";
    BookingStatus bstatus = BookingStatus.none;
    for (int i = 0; i < roomBookStartList.length; i++) {
      if (controller.reservationModel.isNotEmpty) {
        //! Check Booking Status
        if (DateUtilsx.areDatesEqual(customDate, roomBookStartList[i])) {
          //! A Date is Matching with [Start Date]

          if (DateUtilsx.isDateBetween(
            currentDate,
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            //! This is Running Confirmed by me!

            if (roomBookStartList.length >= 2 &&
                i != 0 &&
                DateUtilsx.areDatesEqual(
                  roomBookStartList[i],
                  roomBookEndList[i - 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookEndList[i - 1])) {
                bstatus = BookingStatus.pastRunning;
              } else if (DateUtilsx.isDateRunning(
                roomBookEndList[i - 1],
                roomBookStartList[i],
              )) {
                bstatus = BookingStatus.runningCross;
              } else {
                bstatus = BookingStatus.runningFuture;
              }
            } else {
              bstatus = BookingStatus.runningStart;
            }
          } else if (DateUtilsx.isDateFuture(
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            //! Checked this revervation is in [Future Category]

            if (roomBookStartList.length >= 2 &&
                i != 0 &&
                DateUtilsx.areDatesEqual(
                  roomBookStartList[i],
                  roomBookEndList[i - 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookEndList[i - 1])) {
                bstatus = BookingStatus.pastFuture;
              } else if (DateUtilsx.isDateRunning(
                roomBookStartList[i - 1],
                roomBookEndList[i],
              )) {
                bstatus = BookingStatus.runningFuture;
              } else {
                bstatus = BookingStatus.futureCross;
              }
            } else {
              bstatus = BookingStatus.futureStart;
            }
          } else {
            //! Not Runnig not Future then it's PastStart
            if (roomBookStartList.length >= 2 &&
                i != 0 &&
                DateUtilsx.areDatesEqual(
                  roomBookStartList[i],
                  roomBookEndList[i - 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookEndList[i - 1])) {
                bstatus = BookingStatus.pastCross;
              } else if (DateUtilsx.isDateRunning(
                roomBookEndList[i - 1],
                roomBookStartList[i],
              )) {
                bstatus = BookingStatus.pastRunning;
              } else {
                bstatus = BookingStatus.pastFuture;
              }
            } else {
              bstatus = BookingStatus.pastStart;
            }
          }
        } else if (DateUtilsx.areDatesEqual(customDate, roomBookEndList[i])) {
          //! A Date is Matching with the End Date

          if (DateUtilsx.isDateBetween(
            currentDate,
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            //! This is Running Confirmed by me!
            if (roomBookStartList.length > i + 1 &&
                DateUtilsx.areDatesEqual(
                  roomBookEndList[i],
                  roomBookStartList[i + 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookStartList[i + 1])) {
                bstatus = BookingStatus.pastRunning;
              } else if (DateUtilsx.isDateRunning(
                //! TODO: Here some changes are required
                roomBookEndList[i],
                roomBookStartList[i + 1],
              )) {
                bstatus = BookingStatus.runningCross;
              } else {
                bstatus = BookingStatus.runningFuture;
              }
            } else {
              bstatus = BookingStatus.runningEnd;
            }
          } else if (DateUtilsx.isDateFuture(
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            //! Confirmed that this is Future end date

            if (roomBookStartList.length >= 2 &&
                i != 0 &&
                DateUtilsx.areDatesEqual(
                  roomBookStartList[i],
                  roomBookEndList[i - 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookEndList[i - 1])) {
                bstatus = BookingStatus.pastFuture;
              } else if (DateUtilsx.isDateRunning(
                roomBookEndList[i - 1],
                roomBookStartList[i],
              )) {
                bstatus = BookingStatus.runningFuture;
              } else {
                if (roomBookStartList.length > i + 1 &&
                    DateUtilsx.areDatesEqual(
                      roomBookEndList[i],
                      roomBookStartList[i + 1],
                    )) {
                  //! Note: +1 applied to avoid the index out of range error
                  bstatus = BookingStatus.futureCross;
                } else {
                  bstatus = BookingStatus.futureEnd;
                }
              }
            } else {
              bstatus = BookingStatus.futureEnd;
            }
          } else {
            //! Confirm that is is pastEnd
            if (roomBookStartList.length >= 2 &&
                i != 0 &&
                DateUtilsx.areDatesEqual(
                  roomBookStartList[i],
                  roomBookEndList[i - 1],
                )) {
              if (DateUtilsx.isDatePast(roomBookEndList[i - 1])) {
                if (roomBookEndList.length > i &&
                    DateUtilsx.areDatesEqual(
                      roomBookEndList[i],
                      roomBookStartList[i + 1],
                    )) {
                  bstatus = BookingStatus.pastCross;
                } else {
                  bstatus = BookingStatus.pastEnd;
                }
              } else if (DateUtilsx.isDateRunning(
                roomBookEndList[i - 1],
                roomBookStartList[i],
              )) {
                bstatus = BookingStatus.pastRunning;
              } else {
                bstatus = BookingStatus.pastFuture;
              }
            } else {
              bstatus = BookingStatus.pastEnd;
            }
          }
        } else if (DateUtilsx.isDateBetween(
          //! Runnig Dates all the dates between Start and End No work Need Here!
          customDate,
          roomBookStartList[i],
          roomBookEndList[i],
        )) {
          if (DateUtilsx.isDateBetween(
            currentDate,
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            bstatus = BookingStatus.running;
          } else if (DateUtilsx.isDateFuture(
            roomBookStartList[i],
            roomBookEndList[i],
          )) {
            bstatus = BookingStatus.future;
          } else {
            bstatus = BookingStatus.past;
          }
        }
      }
    }
    return bstatus;
  }

  // Add empty cells for the first week
  for (int i = 1; i < firstDayOfWeek; i++) {
    days.add(const SizedBox());
  }

  bool isToday(int day) {
    return dateToday.day == day &&
        dateToday.month == selectedMonth &&
        dateToday.year == selectedYear;
  }

  // Add days of the month
  for (int day = 1; day <= totalDays; day++) {
    // if (false) {
    //   days.add(CalendarCell(status: BookingStatus.today, dayNumber: day));
    // }

    if (isBookedOrNot(day)) {
      days.add(
        Stack(
          children: [
            CalendarCell(status: getBookingStatus(day), dayNumber: day),
            if (isToday(day))
              Opacity(
                opacity: .6,
                child: CalendarCell(
                  status: BookingStatus.today,
                  dayNumber: day,
                ),
              ),
          ],
        ),
      );
    } else {
      days.add(
        Stack(
          children: [
            CalendarCell(status: BookingStatus.none, dayNumber: day),
            if (isToday(day))
              Opacity(
                opacity: .6,
                child: CalendarCell(
                  status: BookingStatus.today,
                  dayNumber: day,
                ),
              ),
          ],
        ),
      );
    }
  }

  return days;
}
