import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:reminder/db/reminder_database.dart';
import 'package:reminder/model/reminder_model.dart';

Future<void> sendReminderNotifiction(Reminder reminder) async {
  print('Adding notificaiton remidner');

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: reminder.id != null ? reminder.id : 1,
      channelKey: 'scheduled_channel',
      title: 'You have a new reminder',
      body: reminder.reminderText,
      notificationLayout: NotificationLayout.Default,
    ),
    // actionButtons: [
    //   NotificationActionButton(
    //     key: 'MARK_DONE',
    //     label: 'Mark Done',
    //   ),
    // ],
    schedule: NotificationCalendar(
      year: reminder.reminderDate.year,
      month: reminder.reminderDate.month,
      day: reminder.reminderDate.day,
      hour: reminder.reminderDate.hour,
      minute: reminder.reminderDate.minute,
      second: 0,
      millisecond: 0,
      repeats: false,
    ),
  );
}

Future<void> sendNextReminder(Reminder reminder) async {
  reminder.reminderDate = await reminder.reminderDate
      .add(Duration(hours: reminder.nextNotificaitonHour));
  ReminderDatabase.instance.update(reminder);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: reminder.id != null ? reminder.id : 1,
      channelKey: 'scheduled_channel',
      title: 'You have a new reminder',
      body: reminder.reminderText,
      notificationLayout: NotificationLayout.Default,
    ),
    // actionButtons: [
    //   NotificationActionButton(
    //     key: 'MARK_DONE',
    //     label: 'Mark Done',
    //   ),
    // ],
    schedule: NotificationCalendar(
      year: reminder.reminderDate.year,
      month: reminder.reminderDate.month,
      day: reminder.reminderDate.day,
      hour: reminder.reminderDate.hour,
      minute: reminder.reminderDate.minute,
      second: 0,
      millisecond: 0,
      repeats: false,
    ),
  );
}
