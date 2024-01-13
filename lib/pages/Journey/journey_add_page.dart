import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_journal/components/app_colors.dart';
import 'package:travel_journal/models/note_model.dart';

import 'package:travel_journal/pages/Plans/plan_add_page.dart';
import 'package:travel_journal/pages/home_navigator.dart';
import 'package:travel_journal/services/images/image_services.dart';
import 'package:travel_journal/services/journey/journey_services.dart';
import 'package:travel_journal/services/notes/note_services.dart';

class JourneyAddPage extends StatefulWidget {
  JourneyAddPage({
    super.key,
  });

  @override
  State<JourneyAddPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyAddPage> {
  List<XFile>? pickedFiles;
  List<String> imagesList = [];
  List<String> downloadURLs = [];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  bool addingFinish = true;
  String journeyCreated = "";
  var formKey = GlobalKey<FormState>();
  JourneyServices journeyServices = JourneyServices();
  NoteServices noteServices = NoteServices();

  late Note note;

  @override
  void initState() {
    super.initState();
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
            child: ListView(children: [
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
                  itemCount: imagesList.length,
                  itemBuilder: (context, index, realIndex) {
                    final assetsImage = imagesList[index];

                    return buildImages(assetsImage, index);
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  pickImages();
                  if (pickedFiles != null && pickedFiles!.isNotEmpty) {
                    // Wait for the completion of uploadImages
                    downloadURLs = await ImageServices()
                        .uploadImages(pickedFiles!, note.noteId);

                    // Now you have the downloadURLs, and you can proceed with other logic
                    // ...
                    setState(() {
                      imagesList =
                          pickedFiles!.map((file) => file.path).toList();
                    });
                  } else {
                    print('No images selected');
                  }
                },
                child: Icon(Icons.add),
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
                        "Data and time",
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
                        enabled: addingFinish,
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
                        enabled: addingFinish,
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
                        enabled: addingFinish,
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
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          child: ElevatedButton(
                              onPressed: () async {
                                journeyCreated = await journeyServices
                                    .createJourneyInJourneyCollection(
                                        titlecontroller.text,
                                        descriptioncontroller.text,
                                        locationcontroller.text,
                                        downloadURLs);
                                note = await noteServices
                                    .getOneNote(journeyCreated);
                                if (journeyCreated.isNotEmpty) {
                                  setState(() {
                                    addingFinish = false;
                                    imagesList = [];
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Journey Added Successfully"),
                                      duration: Duration(
                                          seconds:
                                              3), // Adjust the duration as needed
                                    ),
                                  );
                                }
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
                                      builder: (context) => PlanAddPage(
                                            note: note,
                                          )),
                                );
                                print(note);
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
            ]),
          ),
        ));
  }

  Widget buildImages(String imagePath, int index) => Container(
        color: Colors.grey,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      );
  //save image path in hive with the note id
  Future<List<File>?> pickImages() async {
    pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 50, // Adjust the image quality as needed
    );
    setState(() {
      imagesList = pickedFiles!.map((file) => file.path).toList();
    });
    return pickedFiles?.map((file) => File(file.path)).toList();
  }
}
