import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:travel_journal/config/app_routes.dart';
import 'package:travel_journal/firebase_options.dart';
import 'package:travel_journal/models/note_images.dart';
import 'package:travel_journal/models/user_model.dart';
import 'package:travel_journal/services/Reminder/reminder_services.dart';
import 'package:travel_journal/services/auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        channelGroupKey: 'basic_channel_group',
        importance: NotificationImportance.Max,
        defaultPrivacy: NotificationPrivacy.Public,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        locked: true)
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: 'basic_channel_group',
      channelGroupName: 'Basic notifications',
    )
  ]);

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(NoteImagesAdapter());
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: ReminderServices.onActionReceiveMethod,
      onNotificationCreatedMethod: ReminderServices.onNotificationCreateMethod,
      onDismissActionReceivedMethod:
          ReminderServices.onDismissActionReceivedMethod,
      onNotificationDisplayedMethod:
          ReminderServices.onNotificationDisplayMethod,
    );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
        initialData: UserModel(uid: ''),
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.start,
          routes: AppRoutes.pages,
        ));
  }
}
