import 'package:flutter/material.dart';
import 'package:travel_journal/components/bottom_navigation_bar.dart';
import 'package:travel_journal/models/firebase_user_model.dart';
import 'package:travel_journal/pages/Journey/journey_add_page.dart';
import 'package:travel_journal/pages/Map/map_page.dart';
import 'package:travel_journal/pages/Notes/notes_home.dart';
import 'package:travel_journal/pages/Profile/profile_page.dart';
import 'package:travel_journal/pages/Weather/weather_page.dart';
import 'package:travel_journal/services/auth/auth.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  Menus currentIndex = Menus.home;
  AuthService authService = AuthService();
  late Future<FireStoreUser?> user;

  //getcurrent user detils

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex.index],
      bottomNavigationBar: MyBottonNavigation(
        currentIndex: currentIndex,
        onTap: ((value) {
          setState(() {
            currentIndex = value;
            print(currentIndex);
          });
        }),
      ),
    );
  }

  final pages = [
    NoteHomePage(),
    WeatherPage(),
    JourneyAddPage(),
    MapPage(),
    ProfilePage(),
  ];
}
