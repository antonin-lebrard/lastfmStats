library lastFmStats.datetime;

class DateTimeSerializable extends DateTime {

  DateTimeSerializable(int year,
      [int month = 1, int day = 1, int hour = 0, int minute = 0,
      int second = 0, int millisecond = 0, int microsecond = 0])
      : super(year, month, day, hour, minute, second, millisecond, microsecond);

  DateTimeSerializable.now() : super.now();

}