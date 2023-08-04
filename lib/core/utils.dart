
import 'package:intl/intl.dart';

extension DateFormatextention on DateTime {
  String getTime() {
    return DateFormat('HH:mm').format(this);
  }

  String getWeekDay() {
    return DateFormat('EEEE').format(this);
  }

  String getDate() {
    return DateFormat('d MMMM yyyy').format(this);
  }
}

extension IntToMinutesSeconds on int {
  String toMinutesSecondsString() {
    int totalSeconds = this ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}



