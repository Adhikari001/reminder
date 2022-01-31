import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reminder/db/reminder_database.dart';
import 'package:reminder/model/reminder_model.dart';

class AddReminderForm extends StatefulWidget {
  const AddReminderForm({Key? key}) : super(key: key);

  @override
  _AddReminderFormState createState() => _AddReminderFormState();
}

class _AddReminderFormState extends State<AddReminderForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    String _reminderText = "";
    DateTime _reminderData = DateTime.now();
    int _nextNotificaitonHour = 0;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Reminder Text',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                _reminderText = value;
                return null;
              },
            ),
            SizedBox(
              height: 12,
            ),
            DateTimeField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Date and time of reminder.',
              ),
              format: DateFormat("yyyy-MM-dd HH:mm"),
              validator: (value) {
                if (value == null) {
                  return 'Please select date.';
                }
                _reminderData = value;
                return null;
              },
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: currentDate,
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(currentDate.year + 100, currentDate.month,
                      currentDate.day),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ??
                        DateTime.now().add(const Duration(minutes: 1))),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hours between each reminder',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  _nextNotificaitonHour = 0;
                } else {
                  _nextNotificaitonHour = int.parse(value);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 30, 70, 10),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ReminderDatabase.instance.create(Reminder(
                        reminderText: _reminderText,
                        reminderDate: _reminderData,
                        isComplete: false,
                        nextNotificaitonHour: _nextNotificaitonHour));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data Added Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
