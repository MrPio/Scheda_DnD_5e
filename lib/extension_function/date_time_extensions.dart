import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDateStr([day = true]) =>
      DateFormat(day ? 'dd MMM yyyy' : 'MMM yyyy').format(this);

  String toShortDateStr() => DateFormat('dd MMM').format(this);
  String toShortDateHourStr() => DateFormat('dd MMM HH:mm').format(this);

  String toTimeStr() => DateFormat('HH:mm').format(this);

  String toConceptualStr() =>
      DateTime
          .now()
          .difference(this)
          .inHours < 24 ? toTimeStr() : toDateStr();

  String toPostStr() {
    final seconds = DateTime
        .now()
        .difference(this)
        .inSeconds;
    if (seconds < 60) {
      return 'Alcuni sec fa';
    } else if (seconds < 3600) {
      return '${seconds ~/ 60} min fa';
    } else if (seconds < 3600 * 24) {
      return '${seconds ~/ 3600} ore fa';
    } else if (seconds < 3600 * 24 * 7) {
      // return DateFormat('EEEE').format(this);
      return '${seconds ~/ (24*3600)} gg fa';
    } else if (seconds < 3600 * 24 * 60) {
      return toShortDateStr();
    } else {
      return toDateStr();
    }
  }
}
