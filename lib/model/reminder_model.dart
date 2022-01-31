const tableReminder = 'reminder';

class ReminderFields {
  static const List<String> values = [
    '_id',
    'reminderText',
    'reminderDate',
    'isComplete',
    'nextNotificaitonHour'
  ];

  static const String id = '_id';
  static const String reminderText = 'reminderText';
  static const String reminderDate = 'reminderDate';
  static const String isComplete = 'isComplete';
  static const String nextNotificaitonHour = 'nextNotificaitonHour';
}

class Reminder {
  final int? id;
  final String reminderText;
  DateTime reminderDate;
  bool isComplete;
  final int nextNotificaitonHour;

  Reminder({
    this.id,
    required this.reminderText,
    required this.reminderDate,
    required this.isComplete,
    required this.nextNotificaitonHour,
  });

  Reminder copy({
    int? id,
    String? reminderText,
    DateTime? reminderDate,
    bool? isComplete,
    int? nextNotificaitonHour,
  }) =>
      Reminder(
        id: id ?? this.id,
        reminderText: reminderText ?? this.reminderText,
        reminderDate: reminderDate ?? this.reminderDate,
        isComplete: isComplete ?? this.isComplete,
        nextNotificaitonHour: nextNotificaitonHour ?? this.nextNotificaitonHour,
      );

  static Reminder fromJson(Map<String, Object?> json) => Reminder(
        id: json[ReminderFields.id] as int?,
        reminderText: json[ReminderFields.reminderText] as String,
        reminderDate:
            DateTime.parse(json[ReminderFields.reminderDate] as String),
        isComplete: json[ReminderFields.isComplete] == 1,
        nextNotificaitonHour: json[ReminderFields.nextNotificaitonHour] as int,
      );

  Map<String, Object?> toJson() => {
        ReminderFields.id: id,
        ReminderFields.reminderText: reminderText,
        ReminderFields.reminderDate: reminderDate.toIso8601String(),
        ReminderFields.isComplete: isComplete ? 1 : 0,
        ReminderFields.nextNotificaitonHour: nextNotificaitonHour,
      };
}
