import 'package:intl/intl.dart';

String currencyFormatter(number, {bool absolute = false}) {
  if (number == null || number == '') {
    number = 0;
  }
  if (absolute) number = number.abs();
  return NumberFormat.simpleCurrency(locale: "id ", decimalDigits: 0)
      .format(number);
}

dateTimeFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y H.m').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return '';
}
