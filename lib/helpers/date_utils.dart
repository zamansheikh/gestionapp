import 'package:intl/intl.dart';

class DateUtilsx {
  static String getStartDateOfMonth() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    return DateFormat('dd/MM/yyyy').format(startOfMonth);
  }

  static String getEndDateOfMonth() {
    DateTime now = DateTime.now();
    DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime endOfMonth = startOfNextMonth.subtract(const Duration(days: 1));
    return DateFormat('dd/MM/yyyy').format(endOfMonth);
  }

  static String getFormattedCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now);
  }

  static String getEndDateFromMonthAndYear(int month, int year) {
    // Handle invalid month values (1-12)
    if (month < 1 || month > 12) {
      throw ArgumentError(
        'Invalid month value. Please provide a value between 1 (January) and 12 (December).',
      );
    }

    // Calculate the last day of the month by creating a DateTime for the next month, then subtracting one day
    DateTime startOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    DateTime lastDayOfMonth = startOfNextMonth.subtract(
      const Duration(days: 1),
    );

    return DateFormat('dd/MM/yyyy').format(lastDayOfMonth);
  }

  static bool areDatesEqual(String date1, String date2) {
    // Function to normalize date format
    String normalizeDate(String date) {
      List<String> parts = date.split('/');
      if (parts.length == 3) {
        // Remove leading zeros from day and month
        String day = int.parse(parts[0]).toString();
        String month = int.parse(parts[1]).toString();
        String year = parts[2]; // Year remains unchanged
        return "$day/$month/$year";
      }
      throw const FormatException("Invalid date format");
    }

    // Normalize both dates
    String normalizedDate1 = normalizeDate(date1);
    String normalizedDate2 = normalizeDate(date2);

    // Compare the normalized dates
    return normalizedDate1 == normalizedDate2;
  }

  // Check two date and compare another
  static bool isDateBetween(
    String middleDate,
    String startDate,
    String endDate,
  ) {
    // Normalize date format to remove leading zeros
    DateTime normalizeAndParseDate(String date) {
      List<String> parts = date.split('/');
      if (parts.length == 3) {
        // Convert day, month, and year to integers and create a DateTime object
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      throw const FormatException("Invalid date format");
    }

    // Parse and normalize all dates
    DateTime middle = normalizeAndParseDate(middleDate);
    DateTime start = normalizeAndParseDate(startDate);
    DateTime end = normalizeAndParseDate(endDate);

    // Check if middleDate is within the range (inclusive)
    return middle.isAfter(start) && middle.isBefore(end) ||
        middle.isAtSameMomentAs(start) ||
        middle.isAtSameMomentAs(end);
  }

  static bool isDatePast(String endDate) {
    DateTime normalizeAndParseDate(String date) {
      List<String> parts = date.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      throw const FormatException("Invalid date format");
    }

    DateTime end = normalizeAndParseDate(endDate);
    DateTime current = DateTime.now();
    // Normalize both dates to remove time component
    end = DateTime(end.year, end.month, end.day);
    current = DateTime(current.year, current.month, current.day);

    // Now compare only the date
    return current.isAfter(end);
  }

  static bool isDateRunning(String startDate, String endDate) {
    DateTime normalizeAndParseDate(String date) {
      List<String> parts = date.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      throw const FormatException("Invalid date format");
    }

    DateTime start = normalizeAndParseDate(startDate);
    DateTime end = normalizeAndParseDate(endDate);
    DateTime current = DateTime.now();
    current = DateTime(current.year, current.month, current.day);
    // Check if current date is between start and end dates (inclusive)
    return (current.isAfter(start) && current.isBefore(end)) ||
        current.isAtSameMomentAs(start) ||
        current.isAtSameMomentAs(end);
  }

  static bool isDateFuture(String startDate, String endDate) {
    DateTime normalizeAndParseDate(String date) {
      List<String> parts = date.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      throw const FormatException("Invalid date format");
    }

    DateTime start = normalizeAndParseDate(startDate);
    DateTime end = normalizeAndParseDate(endDate);
    DateTime current = DateTime.now();
    current = DateTime(current.year, current.month, current.day);

    // Check if current date is before start date or not in between start and end dates
    if (current.isBefore(start)) {
      return true;
    } else if (current.isAfter(start) && current.isBefore(end)) {
      return false;
    } else {
      return false;
    }
  }
}
