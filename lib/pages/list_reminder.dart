import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:reminder/db/reminder_database.dart';
import 'package:reminder/model/reminder_model.dart';
import 'package:reminder/widget/refresh_widget.dart';
import 'package:reminder/widget/reminder_list_widget.dart';

class ListReminder extends StatefulWidget {
  const ListReminder({Key? key}) : super(key: key);

  @override
  State<ListReminder> createState() => _ListReminderState();
}

class _ListReminderState extends State<ListReminder> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  late List<Reminder> reminderList;
  bool isLoading = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    refreshReminder();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().displayedStream.listen((event) async {
      if (event.id != null) {
        var reminder = await ReminderDatabase.instance.getReminder(event.id!);
        if (reminder.nextNotificaitonHour != 0) {
        } else {
          reminder.isComplete = true;
          ReminderDatabase.instance.update(reminder);
          refreshReminder();
        }
      }
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
    ReminderDatabase.instance.close();
  }

  Future refreshReminder() async {
    keyRefresh.currentState?.show();
    setState(() => isLoading = true);
    reminderList = _selectedIndex == 0
        ? await ReminderDatabase.instance.getPendingReminder()
        : await ReminderDatabase.instance.getCompletedRemidner();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reminder List',
          style: TextStyle(color: Color(0xFFF0F4C3)),
        ),
        actions: [
          IconButton(
              onPressed: refreshReminder, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: isLoading
            ? const CircularProgressIndicator()
            : RefreshWidget(
                keyRefresh: keyRefresh,
                onRefresh: refreshReminder,
                child: reminderList.isEmpty
                    ? const Center(
                        child: Text(
                          'No Reminder...',
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      )
                    : ReminderListWidget(
                        reminderList: reminderList,
                        refreshReminderList: refreshReminder,
                      )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.lime[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          await Navigator.of(context).pushNamed('/add-reminders');
          refreshReminder();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.green[900],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          refreshReminder();
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Remaning Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
