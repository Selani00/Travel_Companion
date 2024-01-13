import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_journal/components/app_colors.dart';
import 'package:travel_journal/models/reminder.dart';
import 'package:travel_journal/services/Reminder/reminder_services.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime selectedDateTime;
  late List<Reminder> reminders;  

  //add reminders
  Future<void> saveReminder(Reminder reminder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reminderStrings = reminders.map((reminder) {
      return 'description:${reminder.description}|dateTime:${reminder.datetime}';
    }).toList();

    prefs.setStringList('reminders', reminderStrings);
  }

  //load reminders
  Future<void> loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? reminderStrings = prefs.getStringList('reminders');

    if (reminderStrings != null) {
      setState(() {
        reminders = reminderStrings.map((reminder) {
          Map<String, dynamic> reminderMap = Map<String, dynamic>.from(
            Map<String, dynamic>.fromIterable(
              reminder.split('|'),
              key: (item) => item.split(':')[0],
              value: (item) => item.split(':')[1],
            ),
          );

          return Reminder(
            description: reminderMap['description']!,
            datetime: DateTime.parse(reminderMap['dateTime']!),
          );
        }).toList();
      });
    }
  }

  void removeExpiredReminders() {
    DateTime currentDateTime = DateTime.now();

    setState(() {
      reminders.removeWhere(
          (reminder) => reminder.datetime.isBefore(currentDateTime));
    });

    saveRemindersList();
  }

  Future<void> saveRemindersList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reminderStrings = reminders.map((reminder) {
      return 'description:${reminder.description}|dateTime:${reminder.datetime.toIso8601String()}';
    }).toList();

    prefs.setStringList('reminders', reminderStrings);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check and remove expired reminders every time the page loads
    removeExpiredReminders();
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    reminders = [];
    loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
            Expanded(
              child: Center(
                child: const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.white),
                hintText: "Reminder Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: dateController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.white),
                prefixIcon: GestureDetector(
                    onTap: () async {
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
                            dateController.text = DateFormat('yyyy-MM-dd HH:mm')
                                .format(pickedDateTime);
                          });
                        }
                      }
                    },
                    child: Icon(Icons.calendar_month_rounded)),
                hintText: "Data and Time",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(width, 50),
                  backgroundColor: AppColors.mainColor),
              onPressed: () async {
                Reminder newReminder = Reminder(
                    description: descriptionController.text.trim(),
                    datetime: selectedDateTime);
                reminders.add(newReminder);
                await saveReminder(newReminder);
                await ReminderServices.scheduleNotification(
                        reminder: newReminder)
                    .then((_) {
                  setState(() {
                    descriptionController.clear();
                    dateController.clear();
                    print("Reminder Added Succefully");
                  });
                });
              },
              child: Center(
                child: Text(
                  "Set Reminder",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Upcomming Reminders",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            Container(
              height: 1,
              width: width,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  Reminder reminder = reminders[index];
                  return ListTile(
                    title: Text(reminder.description),
                    subtitle: Text(
                      'Date and Time: ${reminder.datetime.toLocal()}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _reminders() {
  //   return Container(
  //     height: 60,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 2,
  //           blurRadius: 10,
  //           offset: Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           "Reminder 1",
  //           style: TextStyle(color: Colors.black, fontSize: 15),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           "Sechdule date and time",
  //           style: TextStyle(color: Colors.black, fontSize: 15),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


/*onPressed: () {
                    ReminderServices.scheduleNotification(
                            reminder: Reminder(
                                description: _controller.text.trim(),
                                datetime:
                                    now.add(const Duration(seconds: 120))))
                        .then((_) {
                      setState(() {
                        _controller.clear();
                      });
                    });*/