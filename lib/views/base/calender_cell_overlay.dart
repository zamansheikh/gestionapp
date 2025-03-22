import 'package:flutter/material.dart';
import 'package:gestionapp/views/base/calender_cell.dart';

class CalenderCellOverlay extends StatefulWidget {
  final int? dayNumber;
  final bool showBorder;
  final TextStyle? textStyle;
  final BookingStatus status;

  const CalenderCellOverlay({
    super.key,
    this.dayNumber,
    this.showBorder = false,
    this.textStyle,
    this.status = BookingStatus.none,
  });

  @override
  State<CalenderCellOverlay> createState() => _CalenderCellOverlayState();
}

class _CalenderCellOverlayState extends State<CalenderCellOverlay> {
  final Color _pastBookingColor = const Color(0xff5092F9);
  final Color _runningBookingColor = const Color(0xff5092F9);
  final Color _futureBookingColor = const Color(0xff5092F9);
  final Color _todayColors = const Color(0xff5092F9);

  Color _getColor(BookingStatus status, {isSecondColor = false}) {
    switch (status) {
      case BookingStatus.runningStart:
        return isSecondColor ? _runningBookingColor : Colors.transparent;
      case BookingStatus.today:
        return isSecondColor ? _todayColors : _todayColors;
      case BookingStatus.running:
        return _runningBookingColor;
      case BookingStatus.runningCross:
        return _runningBookingColor;
      case BookingStatus.runningEnd:
        return isSecondColor ? Colors.transparent : _runningBookingColor;
      case BookingStatus.futureStart:
        return isSecondColor ? _futureBookingColor : Colors.transparent;
      case BookingStatus.future:
        return _futureBookingColor;
      case BookingStatus.futureCross:
        return _futureBookingColor;
      case BookingStatus.futureEnd:
        return isSecondColor ? Colors.transparent : _futureBookingColor;
      case BookingStatus.pastStart:
        return isSecondColor ? _pastBookingColor : Colors.transparent;
      case BookingStatus.past:
        return _pastBookingColor;
      case BookingStatus.pastCross:
        return _pastBookingColor;
      case BookingStatus.pastEnd:
        return isSecondColor ? Colors.transparent : _pastBookingColor;
      case BookingStatus.pastRunning:
        return isSecondColor ? _runningBookingColor : _pastBookingColor;
      case BookingStatus.pastFuture:
        return isSecondColor ? _futureBookingColor : _pastBookingColor;
      case BookingStatus.runningFuture:
        return isSecondColor ? _futureBookingColor : _runningBookingColor;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xffF2F5F7),
            borderRadius: BorderRadius.circular(5),
            border:
                widget.showBorder
                    ? Border.all(color: Colors.black, width: 1)
                    : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CustomPaint(
              painter:
                  widget.status != BookingStatus.none
                      ? DiagonalSplitPainter(
                        topLeftColor: _getColor(widget.status),
                        bottomRightColor: _getColor(
                          widget.status,
                          isSecondColor: true,
                        ),
                        status: widget.status,
                      )
                      : null,
              child: Center(
                child: Text(
                  widget.dayNumber != null ? '${widget.dayNumber}' : '',
                  style:
                      widget.textStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.status == BookingStatus.none
                                ? Colors.black
                                : Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiagonalSplitPainter extends CustomPainter {
  final Color topLeftColor;
  final Color bottomRightColor;
  final BookingStatus status;

  DiagonalSplitPainter({
    required this.topLeftColor,
    required this.bottomRightColor,
    this.status = BookingStatus.none,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw the top-left triangle
    paint.color = topLeftColor;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    // Draw the bottom-right triangle
    paint.color = bottomRightColor;
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    if (status == BookingStatus.runningStart ||
        status == BookingStatus.runningEnd ||
        status == BookingStatus.runningCross ||
        status == BookingStatus.runningFuture ||
        status == BookingStatus.futureStart ||
        status == BookingStatus.futureEnd ||
        status == BookingStatus.futureCross ||
        status == BookingStatus.pastStart ||
        status == BookingStatus.pastEnd ||
        status == BookingStatus.pastRunning ||
        status == BookingStatus.pastCross) {
      //draw a line between the two triangles
      paint.color = Colors.black;
      paint.strokeWidth = 1.5;
      paint.strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(0 + 1, size.height - 1),
        Offset(size.width - 1, 0 + 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
