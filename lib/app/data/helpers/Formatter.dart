import 'package:intl/intl.dart';

String currencyFormatter(number, {bool absolute = false}) {
  if (number == null || number == '') {
    number = 0;
  }
  if (absolute) number = number.abs();
  return NumberFormat.simpleCurrency(locale: "id ", decimalDigits: 0)
      .format(number);
}

DateTime today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

bool isToday(DateTime? date) {
  if (date is DateTime) {
    return DateTime(date.year, date.month, date.day) == today;
  }
  return false;
}

bool matchDay(DateTime? date1, DateTime? date2) {
  if (date1 is DateTime && date2 is DateTime) {
    return DateTime(date1.year, date1.month, date1.day) ==
        DateTime(date2.year, date2.month, date2.day);
  }
  return false;
}

dateTimeFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y H.m').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return '';
}

dateFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y').format(date);
  } else
    return '';
}
