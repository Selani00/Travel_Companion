import 'package:flutter/material.dart';
import 'package:travel_journal/models/reminder.dart';
import 'package:travel_journal/services/Reminder/reminder_services.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.black),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Schedule details',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  child: Text('Send Notification'),
                  onPressed: () {
                    ReminderServices.scheduleNotification(
                            reminder: Reminder(
                                description: _controller.text.trim(),
                                datetime:
                                    now.add(const Duration(seconds: 120))))
                        .then((_) {
                      setState(() {
                        _controller.clear();
                      });
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
