import 'package:flutter/material.dart';
import 'package:reminder/forms/add_reminder.dart';

class AddReminders extends StatelessWidget {
  const AddReminders({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: const Text('Add Reminders')),
      body: const Center(
        child: AddReminderForm()
      ),
    );
  }
}