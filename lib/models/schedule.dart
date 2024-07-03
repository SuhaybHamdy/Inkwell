
// lib/schedule.dart

class Schedule {
  final RepeatOption repeatOption;
  final CustomInterval? customInterval;
  final int? customIntervalValue;
  final List<WeekDay>? customWeekDays;
  final List<int>? customDates;
   DateTime? startDate;
   DateTime? endDate;

   Schedule({
    required this.repeatOption,
    this.customInterval,
    this.customIntervalValue,
    this.customWeekDays,
    this.customDates,
    this.startDate,
    this.endDate,
  });

  factory Schedule.never() =>  Schedule(repeatOption: RepeatOption.never);

  factory Schedule.daily() =>  Schedule(repeatOption: RepeatOption.daily);

  factory Schedule.weekly() =>  Schedule(repeatOption: RepeatOption.weekly);

  factory Schedule.monthlyByDay() =>
       Schedule(repeatOption: RepeatOption.monthlyByDay);

  factory Schedule.monthlyByDate() =>
       Schedule(repeatOption: RepeatOption.monthlyByDate);

  factory Schedule.yearly() =>  Schedule(repeatOption: RepeatOption.yearly);

  factory Schedule.custom({
    required CustomInterval interval,
    required int intervalValue,
    List<WeekDay>? weekDays,
    List<int>? dates,
    DateTime? start,
    DateTime? end,
  }) =>
      Schedule(
        repeatOption: RepeatOption.custom,
        customInterval: interval,
        customIntervalValue: intervalValue,
        customWeekDays: weekDays,
        customDates: dates,
        startDate: start,
        endDate: end,
      );

  DateTime? getNextOccurrence(DateTime from) {
    if (startDate == null) return null;
    DateTime nextDate = startDate!;

    while (nextDate.isBefore(from)) {
      nextDate = _incrementDate(nextDate);
    }

    return nextDate.isBefore(endDate ?? DateTime(9999, 12, 31)) ? nextDate : null;
  }

  DateTime _incrementDate(DateTime date) {
    switch (repeatOption) {
      case RepeatOption.never:
        return date;
      case RepeatOption.daily:
        return date.add(Duration(days: 1));
      case RepeatOption.weekly:
        return date.add(Duration(days: 7));
      case RepeatOption.monthlyByDay:
      case RepeatOption.monthlyByDate:
        return DateTime(date.year, date.month + 1, date.day);
      case RepeatOption.yearly:
        return DateTime(date.year + 1, date.month, date.day);
      case RepeatOption.custom:
        if (customInterval == null || customIntervalValue == null) {
          return date;
        }
        return _incrementCustomDate(date);
    }
  }

  DateTime _incrementCustomDate(DateTime date) {
    switch (customInterval) {
      case CustomInterval.day:
        return date.add(Duration(days: customIntervalValue!));
      case CustomInterval.week:
        return date.add(Duration(days: customIntervalValue! * 7));
      case CustomInterval.monthDay:
      case CustomInterval.monthDate:
        return DateTime(date.year, date.month + customIntervalValue!, date.day);
      case CustomInterval.year:
        return DateTime(date.year + customIntervalValue!, date.month, date.day);
      default:
        throw ArgumentError("Invalid custom interval");
    }
  }

  // Convert a Schedule instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'repeatOption': repeatOption.toString().split('.').last,
      'customInterval': customInterval?.toString().split('.').last,
      'customIntervalValue': customIntervalValue,
      'customWeekDays': customWeekDays?.map((day) => day.toString().split('.').last).toList(),
      'customDates': customDates,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  // Create a Schedule instance from a JSON object
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      repeatOption: RepeatOption.values.firstWhere((e) => e.toString().split('.').last == json['repeatOption']),
      customInterval: json['customInterval'] != null
          ? CustomInterval.values.firstWhere((e) => e.toString().split('.').last == json['customInterval'])
          : null,
      customIntervalValue: json['customIntervalValue'],
      customWeekDays: json['customWeekDays'] != null
          ? (json['customWeekDays'] as List).map((day) => WeekDay.values.firstWhere((e) => e.toString().split('.').last == day)).toList()
          : null,
      customDates: json['customDates'] != null ? List<int>.from(json['customDates']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}

enum RepeatOption {
  never,
  daily,
  weekly,
  monthlyByDay,
  monthlyByDate,
  yearly,
  custom,
}

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

enum CustomInterval {
  day,
  week,
  monthDay,
  monthDate,
  year,
}
