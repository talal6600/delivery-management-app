import 'package:intl/intl.dart';

class DateTimeUtils {
  // Get the start of the week (Sunday)
  static DateTime getWeekStart(DateTime date) {
    // In Saudi Arabia and many Arab countries, the week starts on Sunday
    int daysToSubtract = date.weekday % 7; // Sunday = 0, Monday = 1, etc.
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }
  
  // Get the end of the week (Saturday)
  static DateTime getWeekEnd(DateTime date) {
    DateTime weekStart = getWeekStart(date);
    return weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }
  
  // Check if two dates are in the same week
  static bool isSameWeek(DateTime date1, DateTime date2) {
    DateTime week1Start = getWeekStart(date1);
    DateTime week2Start = getWeekStart(date2);
    return week1Start.isAtSameMomentAs(week2Start);
  }
  
  // Get the start of the month
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  // Get the end of the month
  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
  
  // Check if two dates are in the same month
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }
  
  // Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  // Format date for display (Arabic)
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar').format(date);
  }
  
  // Format date with day name (Arabic)
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, yyyy/MM/dd', 'ar').format(date);
  }
  
  // Get day name in Arabic
  static String getDayName(DateTime date) {
    const arabicDays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return arabicDays[date.weekday - 1];
  }
  
  // Get month name in Arabic
  static String getMonthName(DateTime date) {
    const arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return arabicMonths[date.month - 1];
  }
  
  // Format time
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  // Format currency (SAR)
  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ريال';
  }
  
  // Parse date string
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  // Get week number in the year
  static int getWeekNumber(DateTime date) {
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    int daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }
}
