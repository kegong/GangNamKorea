import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeHelper {
  static var weeks = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];

  static init() {
    initializeDateFormatting('ko_KR');
    timeago.setLocaleMessages('ko', KoMessages());
  }

  static String timeAgo(DateTime time) {
    final date = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return timeago.format(date, locale: 'ko', allowFromNow: true);
  }

  static String timeToStringYMDHM(DateTime time) {
    return DateFormat("yyyy.MM.dd. hh:mm").format(time);
  }

  static String timeToTodayAgoAfterDayTime(DateTime time, {String? dateFormat}) {
    var now = DateTime.now();
    if (time.month == now.month && time.day == now.day) return timeAgo(time);

    dateFormat ??= "yyyy.MM.dd. hh:mm";

    return DateFormat(dateFormat).format(time);
  }

  static String timeToAge(DateTime date) {
    int day = DateTime.now().difference(date).inDays;

    int year = (day ~/ 365).toInt();
    int month = ((day - year * 365) ~/ 30).toInt();

    if (year <= 0 && month <= 0) return "$day일";

    if (year <= 0) return "$month개월";

    return "$year살 $month개월";
  }

  static String timeToTodayTimeAfterDay(DateTime time, {String? timeFormat, String? dayFormat}) {
    var now = DateTime.now();
    timeFormat ??= "HH:mm";
    dayFormat ??= "yyyy.MM.dd.";

    DateFormat timeDateFormat = DateFormat(timeFormat, 'ko_KR');
    if (time.month == now.month && time.day == now.day) return timeDateFormat.format(time);

    DateFormat dayDateFormat = DateFormat(dayFormat, 'ko_KR');
    return dayDateFormat.format(time);
  }
}

class KoMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '후';
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String aboutAMinute(int minutes) => '방금';
  @override
  String minutes(int minutes) => '$minutes분';
  @override
  String aboutAnHour(int minutes) => '1시간';
  @override
  String hours(int hours) => '$hours시간';
  @override
  String aDay(int hours) => '1일';
  @override
  String days(int days) => '$days일';
  @override
  String aboutAMonth(int days) => '한달';
  @override
  String months(int months) => '$months개월';
  @override
  String aboutAYear(int year) => '1년';
  @override
  String years(int years) => '$years년';
  @override
  String wordSeparator() => ' ';
}
