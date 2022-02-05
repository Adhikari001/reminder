import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:reminder/db/reminder_database.dart';
import 'package:reminder/model/reminder_model.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Function refreshReminderList;

  const ReminderWidget(
      {Key? key, required this.reminder, required this.refreshReminderList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Slidable(
        key: Key(reminder.id.toString()),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {
                ReminderDatabase.instance.delete(reminder.id!);
                this.refreshReminderList();
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        // endActionPane: const ActionPane(
        //   motion: ScrollMotion(),
        //   children: [
        //     SlidableAction(
        //       onPressed: null,
        //       backgroundColor: Color(0xFF7BC043),
        //       foregroundColor: Colors.white,
        //       icon: Icons.edit,
        //       label: 'Edit',
        //     ),
        //   ],
        // ),
        child: Container(
          width: double.infinity,
          color: Colors.lime[50],
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reminder.reminderText,
                  style: const TextStyle(fontSize: 20, height: 1.5),
                ),
              ),
              Column(
                children: [
                  Text(DateFormat.yMMMd().format(reminder.reminderDate)),
                  Text(DateFormat.Hm().format(reminder.reminderDate)),
                ],
              )
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 4,
      )
    ]);
  }
}
