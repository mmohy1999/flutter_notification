import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled/local_notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<PendingNotificationRequest> _pendingNotifications = [];
  List<ActiveNotification> _activeNotifications = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingNotifications();
    _fetchActiveNotifications();
  }
  Future<void> _fetchPendingNotifications() async {
    final pendingNotifications =
    await LocalNotificationService.getPendingNotifications();
    setState(() {
      _pendingNotifications = pendingNotifications;
    });
  }
  Future<void> _fetchActiveNotifications() async {
    final activeNotifications =
    await LocalNotificationService.getActiveNotifications();
    setState(() {
      _activeNotifications = activeNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Active Notification:'),
                if (_activeNotifications.isEmpty) const Center(child: Text('No Active Notifications')) else ListView.builder(
                  itemCount: _activeNotifications.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = _activeNotifications[index];
                    if(notification.title!=null) {
                      return ListTile(
                      title: Text('Title: ${notification.title!}'),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Body: ${notification.body!}'),
                          Text('ID: ${notification.id}'),
                        ],
                      ),
                      trailing: IconButton(onPressed: () {
                        LocalNotificationService.clearNotificationById(notification.id!);
                        setState(() {
                          _activeNotifications.remove(notification);
                        });
                      }, icon: const Icon(Icons.delete,color: Colors.redAccent,)),
                    );
                    }else{
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const Divider(color: Colors.grey,),

                const Text('Pending Notification:'),
                const SizedBox(height: 10),
                _pendingNotifications.isEmpty
                    ? const Center(child: Text('No Pending Notifications'))
                    : ListView.builder(
                  itemCount: _pendingNotifications.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = _pendingNotifications[index];
                    return ListTile(
                      title: Text('Title: ${notification.title!}'),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Body: ${notification.body!}'),
                          Text('ID: ${notification.id}'),
                        ],
                      ),
                      trailing: IconButton(onPressed: () {
                        LocalNotificationService.clearNotificationById(notification.id);
                        setState(() {
                          _pendingNotifications.remove(notification);
                        });
                      }, icon: const Icon(Icons.delete,color: Colors.redAccent,)),

                    );
                  },
                ),

              ],
            ),
          ),
        ),
      )
    );
  }
}
