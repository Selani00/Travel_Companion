import 'package:flutter/material.dart';
import 'package:travel_journal/pages/Autheticate/accout_setup_page.dart';
import 'package:travel_journal/pages/Autheticate/login_page.dart';

class Authenticate extends StatefulWidget {
  
  const Authenticate({super.key,});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signinPage = true;

  //toggle pages

  void switchPages() {
    setState(() {
      signinPage = !signinPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signinPage == true) {
      return LoginPage(toggle: switchPages);
    } else {
      return AppSetUpPage(toggle: switchPages);
    }
    
  }
}
