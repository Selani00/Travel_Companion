import 'package:flutter/material.dart';
import 'package:travel_journal/config/app_colors.dart';
import 'package:travel_journal/config/app_images.dart';
import 'package:travel_journal/config/app_routes.dart';
import 'package:travel_journal/services/auth/auth.dart';

class AppSetUpPage extends StatefulWidget {
  final Function toggle;
  
  const AppSetUpPage({super.key, required this.toggle,});

  @override
  State<AppSetUpPage> createState() => _AppSetUpPageState();
}

class _AppSetUpPageState extends State<AppSetUpPage> {
  final bool _isSigning = false;
  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      AppImages.setupback,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 35,
                  right: 35,
                ),
                height: height * 0.92,
                width: width,
                decoration: BoxDecoration(
                    color: AppColors.mainColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const Spacer(),
                        Center(
                          child: const Text(
                            'Account SetUp',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: width * 0.4,
                                  height: width * 0.4,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(AppImages.onetimefirst),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Action when edit icon is tapped
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.buttonColor,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.edit,
                                      color: AppColors.mainColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            validator: (value) => value?.isEmpty == true
                                ? 'Enter your User Name'
                                : null,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.buttonColor,
                                errorStyle: TextStyle(color: Colors.white),
                                hintText: "User Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            validator: (value) => value?.isEmpty == true
                                ? 'Enter your Email'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.buttonColor,
                                errorStyle: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            obscureText: true,
                            validator: (value) =>
                                value!.length < 6 ? 'Weak Password' : null,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.buttonColor,
                                errorStyle: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          _error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () async {
                            dynamic result =
                                await _authService.registerWithEmailAndPassword(
                                    _email, _password);
                            if (result == null) {
                              setState(() {
                                _error = 'Registration Failed';
                              });
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.homenavigation);
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 49, 75, 59),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: _isSigning
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Create",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Already Have an account?",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: const Text(
                            "Or sign up with",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.google,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    " Continue with Google",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
