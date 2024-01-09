import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_journal/config/app_colors.dart';
import 'package:travel_journal/models/firebase_user_model.dart';
import 'package:travel_journal/pages/Autheticate/authentication.dart';
import 'package:travel_journal/services/auth/auth.dart';

class ProfilePage extends StatefulWidget {
  final UserWithCredentials? userWithCredentials;
  ProfilePage({
    this.userWithCredentials,
    super.key,
  });

  @override
  State<ProfilePage> createState() => _AppSetUpPageState();
}

class _AppSetUpPageState extends State<ProfilePage> {
  bool isEditingEnabled = false;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String _error = '';
  bool _obscureText = true;
  File? _image;
  String? _imagepath;

  void loadData() async {
    // Update TextEditingControllers if userWithCredentials data exists
    if (widget.userWithCredentials != null) {
      username.text = widget.userWithCredentials!.username!;
      email.text = widget.userWithCredentials!.email!;
    }
  }

  @override
  void initState() {
    super.initState();
    LoadImage();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditingEnabled = true;
              });
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
              onPressed: () async {
                await _authService.signOut();
                const Authenticate();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.28,
                  width: width,
                  decoration: const BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 90,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_library,
                                color: AppColors.mainColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      enabled: isEditingEnabled,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        hintText: "User Name",
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.mainColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      // validator: (value) => value?.isEmpty == true
                      //     ? 'Enter your User Name'
                      //     : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        hintText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.mainColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      // validator: (value) => value?.isEmpty == true
                      //     ? 'Enter your User Name'
                      //     : null,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.mainColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.mainColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.8, 60),
                        backgroundColor: AppColors.mainColor),
                    onPressed: () async {},
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imagepath = pickedImage.path;
      });
    }
  }

  Future<void> SaveImage(path) async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString("imagepath", path);
  }

  Future<void> LoadImage() async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveImage.getString("imagepath");
    });
  }
}
