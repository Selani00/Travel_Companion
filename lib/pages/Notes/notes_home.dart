import 'package:flutter/material.dart';
import 'package:travel_journal/config/app_routes.dart';
import 'package:travel_journal/models/note_model.dart';
import 'package:travel_journal/config/app_colors.dart';
import 'package:travel_journal/pages/Journey/journey_update_page.dart';
import 'package:travel_journal/services/notes/note_services.dart';
import 'package:travel_journal/widgets/note.dart';
import 'package:travel_journal/services/auth/auth.dart';

class NoteHomePage extends StatefulWidget {
  const NoteHomePage({super.key});

  @override
  State<NoteHomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NoteHomePage> {
  final AuthService _auth = AuthService();
  NoteServices _noteServices = NoteServices();
  final search = TextEditingController();
  NoteServices noteServices = NoteServices();
  late Future<List<Note>> notesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    notesFuture = _loadNotes();
  }

  Future<List<Note>> _loadNotes() async {
    List<Note> notes = await noteServices.getAllNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          children: [
            Spacer(),
            Text("Your Plans and Journeys",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.reminderspage);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                height: height * 0.05,
                width: height * 0.05,
                child: Icon(Icons.notifications, color: Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: Stack(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2)),
            ),
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: FutureBuilder<List<Note>>(
                future: notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return noteCard(
                              () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => JourneyUpdatePage(
                                          note: snapshot.data![index]))),
                              snapshot.data![index]);
                        });
                  } else {
                    return Center(child: Text("No Documents Yet"));
                  }
                }),
          ),
        ]),
      ]),
    );
  }
}
