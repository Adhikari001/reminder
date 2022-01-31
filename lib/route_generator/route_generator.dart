import 'package:flutter/material.dart';
import 'package:reminder/pages/add_reminders.dart';
import 'package:reminder/pages/list_reminder.dart';

class RouteGeneartor {
  static Route<Route> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ListReminder());
      case '/second':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => const ListReminder());
        }
        return _errorRoute();
      case '/add-reminders':
        return MaterialPageRoute(builder: (_) => const AddReminders());
      default:
        return _errorRoute();
    }
  }

  static Route<Route> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
