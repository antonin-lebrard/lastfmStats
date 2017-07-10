library lastFmStats.datetime;
import 'dart:convert';

class DateTimeSerializable extends DateTime {

  DateTimeSerializable(int year,
      [int month = 1, int day = 1, int hour = 0, int minute = 0,
      int second = 0, int millisecond = 0])
      : super(year, month, day, hour, minute, second, millisecond);

  DateTimeSerializable.now() : super.now();

  Map toJson(){
    return {
      "year": year,
      "month": month,
      "day": day,
      "hour": hour,
      "minute": minute,
      "second": second,
      "millisecond": millisecond
    };
  }

  static DateTimeSerializable fromJson(Map json) {
    return new DateTimeSerializable(json["year"],json["month"],json["day"],
                                    json["hour"],json["minute"],json["second"],
                                    json["millisecond"]);
  }


}