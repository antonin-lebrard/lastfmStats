library lastFmStats.datetime;
import 'dart:convert';

class DateTimeSerializable extends DateTime {

  DateTimeSerializable(int year,
      [int month = 1, int day = 1, int hour = 0, int minute = 0,
      int second = 0, int millisecond = 0])
      : super(year, month, day, hour, minute, second, millisecond);

  DateTimeSerializable.now() : super.now();

  String toJson(){
    return JSON.encode({
      "year": year,
      "month": month,
      "day": day,
      "hour": hour,
      "minute": minute,
      "second": second,
      "millisecond": millisecond
    });
  }

  static DateTimeSerializable fromJson(String json) {
    Map m = JSON.decode(json);
    return new DateTimeSerializable(m["year"],m["month"],m["day"],
                                    m["hour"],m["minute"],m["second"],
                                    m["millisecond"]);
  }


}