import 'package:flutter/material.dart';
import 'package:untitled/dialog_widget.dart';
import 'package:untitled/local_notification_service.dart';
import 'package:untitled/notification_type.dart';
import 'package:untitled/notifications_screen.dart';

import 'list_title_widet.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await LocalNotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.notifications),
        title: const Text('Flutter Notification') ,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTitleWidget(title:'Instant Notifications',
          onTap: () =>showDialog(
              context: context,
              builder: (BuildContext context) {
                return  const DialogWidget(notificationType: NotificationType.instantNotifications,);
              },
            )),
          const SizedBox(height: 16),
          ListTitleWidget(title:'Scheduled Notifications',
             onTap: () =>showDialog(
                context: context,
                builder: (BuildContext context) {
                  return  const DialogWidget(notificationType: NotificationType.scheduledNotifications,);
                },
              )),

          const SizedBox(height: 16),
          ListTitleWidget(title:'Show Notification',
              onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen()))
          ),
          const SizedBox(height: 16),

          ListTitleWidget(title:'Clear All Notifications',
              color: Colors.redAccent,
              onTap: () =>LocalNotificationService.clearAllNotifications()),

        ],
      ),
    );

  }


}
