import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension StringParser on String {
  bool toBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }

  int toInt() {
    int? retVal = int.tryParse(this);

    if (retVal != null) return retVal;

    throw '"$this" can not be parsed to int.';
  }

  DateTime toDateTime() {
    DateTime? retVal = DateTime.tryParse(this);

    if (retVal != null) return retVal;

    throw '"$this" can not be parsed to DateTime.';
  }
}

extension IntParser on int {
  String toCommaString() {
    var f = NumberFormat("###,###,###,###");

    return f.format(this);
  }
}

extension DynamicParser on dynamic {
  bool toBool() {
    if (toString().toLowerCase() == 'true') {
      return true;
    } else if (toString().toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }

  int toInt() {
    int? retVal = int.tryParse(toString());

    if (retVal != null) return retVal;

    throw '"$this" can not be parsed to int.';
  }

  DateTime toDateTime() {
    DateTime? retVal = DateTime.tryParse(toString());

    if (retVal != null) return retVal;

    throw '"$this" can not be parsed to DateTime.';
  }
}

class Parser {
  static int toInt(String str) {
    return str.toInt();
  }

  static bool toBool(String str) {
    if (str == "true" || str == "1") return true;
    return false;
  }

  static DateTime toDateTime(String str) {
    return str.toDateTime();
  }

  static T toEnum<T>(List<T> enumValues, String str) {
    return EnumToString.fromString(enumValues, str)!;
  }

  static String toCommaString(int number) {
    return number.toCommaString();
  }

  static String toEnumSgring(Object enumEntry) {
    return describeEnum(enumEntry);
  }
}
