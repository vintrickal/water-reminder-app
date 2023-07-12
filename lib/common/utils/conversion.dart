int timestampConversion(DateTime time) {
  var date = DateTime.now();
  return DateTime(
          date.year, date.month, date.day, time.hour, time.minute, time.second)
      .millisecondsSinceEpoch;
}
