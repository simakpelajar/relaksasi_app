import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    // Menggunakan format bahasa Indonesia dengan konfigurasi locale
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatAlarmTime(String time, String date) {
    return '$time, $date';
  }

  static String formatDay(DateTime date) {
    return DateFormat('E, d MMM', 'id_ID').format(date);
  }
  
  // Format khusus untuk alarm yang menyertakan tahun
  static String formatAlarmDate(DateTime date) {
    return DateFormat('E, d MMM yyyy', 'id_ID').format(date);
  }
}