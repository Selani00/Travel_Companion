import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_journal/models/reminder.dart';

class ReminderServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  


  @pragma("vm:entry-point")
  static Future<void> onNotificationCreateMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceiveMethod(
      ReceivedAction receivedAction) async {}

  static Future<void> scheduleNotification({required Reminder reminder}) async {
    Random random = Random();
    try {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: random.nextInt(100),
            channelKey: 'basic_channel',
            title: 'Reminder',
            body: reminder.description,
            category: NotificationCategory.Reminder,
            notificationLayout: NotificationLayout.BigText,
            locked: true,
            autoDismissible: false,
            fullScreenIntent: true,
            backgroundColor: Colors.transparent,
          ),
          schedule: NotificationCalendar(
            minute: reminder.datetime.minute,
            hour: reminder.datetime.hour,
            day: reminder.datetime.day,
            weekday: reminder.datetime.weekday,
            month: reminder.datetime.month,
            year: reminder.datetime.year,
            preciseAlarm: true,
            allowWhileIdle: true,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'Close',
              label: 'Close Reminder',
              autoDismissible: true,
            )
          ]);
    } catch (e) {
      print(e);
    }
  }

  //creation
  Future<bool> createReminderInReminderCollection(Reminder reminder) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Reminders')
          .add({
        'description': reminder.description,
        'datetime': reminder.datetime,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<Reminder>> getReminderStream() {
    try {
      return _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Reminders')
          .orderBy('datetime', descending: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Reminder> reminders = querySnapshot.docs
            .map((doc) => Reminder(
                  description: doc['description'],
                  datetime: doc['datetime'].toDate(),
                ))
            .toList();
        print(reminders);
        return reminders;
      });
    } catch (e) {
      print(e);
      throw Exception('Error fetching reminders');
    }
  }

  Future<void> autoDeleteReminder() async {
    DateTime currentDate = DateTime.now();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Reminders')
          .where('datetime', isLessThan: currentDate)
          .get();

      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
    } catch (e) {
      print(e);
      throw Exception('Error deleting reminders');
    }
  }  
}
