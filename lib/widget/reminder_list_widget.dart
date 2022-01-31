import 'package:flutter/material.dart';
import 'package:reminder/model/reminder_model.dart';
import 'package:reminder/widget/reminder_widget.dart';

class ReminderListWidget extends StatelessWidget {
  final List<Reminder> reminderList;
  final Function refreshReminderList;

  const ReminderListWidget(
      {Key? key, required this.reminderList, required this.refreshReminderList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> reminderListInformation = reminderList
        .map((reminder) => ReminderWidget(
              reminder: reminder,
              refreshReminderList: refreshReminderList,
            ))
        .toList();

    return ListView(
      children: reminderListInformation,
    );
  }
}
