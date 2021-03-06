const _months = [
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

String formatDate(DateTime date, {bool short = false}) {
  final int day = date.day;
  final int month = date.month;

  String daySuffix;
  switch (day) {
    case 1:
    case 21:
    case 31:
      daySuffix = 'st';
      break;
    case 2:
    case 22:
      daySuffix = 'nd';
      break;
    case 3:
    case 23:
      daySuffix = 'rd';
      break;
    default:
      daySuffix = 'th';
      break;
  }

  if (short) {
    return '${_months[month - 1].substring(0, 3)} $day$daySuffix';
  } else {
    return '${_months[month - 1]} $day$daySuffix';
  }
}
