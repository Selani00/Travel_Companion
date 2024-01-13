import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:travel_journal/components/app_colors.dart';
import 'package:travel_journal/models/journey.dart';
import 'package:travel_journal/models/note_model.dart';
import 'package:travel_journal/pages/Plans/plan_update_page.dart';
import 'package:travel_journal/pages/home_navigator.dart';
import 'package:travel_journal/services/journey/journey_services.dart';

class JourneyUpdatePage extends StatefulWidget {
  JourneyUpdatePage({this.note, super.key});
  Note? note;

  @override
  State<JourneyUpdatePage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyUpdatePage> {
  List<String> imagepaths = [];
  JourneyServices? journeyServices;
  List<Journey>? journey;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  bool isEdditingEnabled = false;
  var formKey = GlobalKey<FormState>();

  void loadData() async {
    List<Journey>? fetchedJourney =
        await journeyServices?.getJourneyInsideTheNote();

    setState(() {
      journey = fetchedJourney;
    });

    // Update TextEditingControllers if journey data exists
    if (journey != null && journey!.isNotEmpty) {
      titlecontroller.text = journey![0].title ?? '';
      descriptioncontroller.text = journey![0].journeyDescription ?? '';
      locationcontroller.text = journey![0].journeyLocations ?? '';
    }
    print(journey);
  }

  @override
  void initState() {
    super.initState();
    journeyServices = JourneyServices(note: widget.note);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        elevation: 0.0,
        leading: IconTheme(
          data: IconThemeData(
            color: Colors.white,
            size: 25,
          ),
          child: GestureDetector(
              onTap: () {
                HomeNavigator();
              },
              child: Icon(Icons.arrow_back)),
        ),
        title: Text("Journey Plan",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.normal)),
        actions: [
          IconButton(
              icon: IconTheme(
                  data: IconThemeData(color: Colors.white, size: 25),
                  child: Icon(Icons.menu)),
              onPressed: () {})
        ],
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        width: width,
        height: height,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                height: height * 0.3,
                width: width,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 400.0,
                    autoPlay: true,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    reverse: true,
                    autoPlayInterval: Duration(seconds: 2),
                  ),
                  itemCount: imagepaths.length,
                  itemBuilder: (context, index, realIndex) {
                    final assetsImage = imagepaths[index];

                    return buildImages(imagepaths[index], index);
                  },
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Created Date:${journey?[0].date.day}/${journey?[0].date.month}/${journey?[0].date.year} Created Time:${journey?[0].date.hour}:${journey?[0].date.minute}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Title",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      TextFormField(
                        enabled: isEdditingEnabled,
                        controller: titlecontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Journey Details",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      TextFormField(
                        enabled: isEdditingEnabled,
                        controller: descriptioncontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Saved Locations",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      TextFormField(
                        enabled: isEdditingEnabled,
                        controller: locationcontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEdditingEnabled = true; // Enable text fields
                          });
                        },
                        child: Text('Enable Editing'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          child: ElevatedButton(
                              onPressed: () async {
                                await journeyServices
                                    ?.updateJourneyInsideTheNote(
                                        title: titlecontroller.text,
                                        description: descriptioncontroller.text,
                                        locations: locationcontroller.text);
                                setState(() {
                                  isEdditingEnabled = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.mainColor,
                              ),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.6,
                          child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlanUpdatePage(note: widget.note)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.mainColor,
                              ),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "Make yor Plan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconTheme(
                                      data: IconThemeData(
                                          color: Colors.white, size: 30),
                                      child: Icon(
                                        Icons.arrow_right_alt,
                                      )),
                                  Spacer(),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImages(String imagePath, int index) => Container(
        color: Colors.grey,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      );
}
