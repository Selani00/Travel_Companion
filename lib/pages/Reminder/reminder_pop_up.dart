import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:travel_journal/models/reminder.dart';
import 'package:travel_journal/services/Reminder/reminder_services.dart';

class InputPopup extends StatefulWidget {
  @override
  _InputPopupState createState() => _InputPopupState();
}

class _InputPopupState extends State<InputPopup> {
  late TextEditingController descriptionController;
  late DateTime selectedDateTime;
  bool isEdditing = true;
  bool addedReminder = false;
  DateTime now = DateTime.now();



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ReminderServices reminderServices = ReminderServices();
    return AlertDialog(
      backgroundColor: Colors.teal[900],
      title: Text(
        'Reminder',
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        height: height * 0.3,
        width: width * 0.7,
        decoration: BoxDecoration(),
        child: Column(
          children: [
            TextField(
              enabled: isEdditing,
              controller: descriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Show date and time picker
                DateTime? pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: selectedDateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDateTime != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                  );

                  if (pickedTime != null) {
                    pickedDateTime = DateTime(
                      pickedDateTime.year,
                      pickedDateTime.month,
                      pickedDateTime.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    setState(() {
                      selectedDateTime = pickedDateTime!;
                    });
                  }
                }
              },
              child: Text('Pick Date and Time'),
            ),
            SizedBox(height: 16),
            Text(
              'Selected Date and Time: ${selectedDateTime.toString()}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            

            // Close the popup
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  
}
