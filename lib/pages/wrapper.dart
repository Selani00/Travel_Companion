import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_journal/models/user_model.dart';
import 'package:travel_journal/pages/Autheticate/authentication.dart';
import 'package:travel_journal/pages/home_navigator.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomeNavigator();
    }
  }
}
