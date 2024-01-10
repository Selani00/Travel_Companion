import 'package:flutter/material.dart';
import 'package:travel_journal/components/app_colors.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  late DateTime selectedDateTime;
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
              // validator: (value) => value?.isEmpty == true
              //     ? 'Enter your User Name'
              //     : null,
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
            Center(
              child: ElevatedButton(
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
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.mainColor,
                  size: 35,
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
              onPressed: () async {},
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
            _reminders(),
          ],
        ),
      ),
    );
  }

  Widget _reminders() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Reminder 1",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Sechdule date and time",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }
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