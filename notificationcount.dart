import 'package:flutter/material.dart';

class NotificationCountPage extends StatefulWidget {
  const NotificationCountPage({Key? key}) : super(key: key);

  @override
  NotificationCountPageState createState() => NotificationCountPageState();
}

class NotificationCountPageState extends State<NotificationCountPage> {
  final Map<String, int> _notificationCounts = {
    'WhatsApp': 5,
    'Instagram': 12,
    'Gmail': 3,
    'Photos': 8,
    'Gallery': 6,
    'Extras': 4,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Count'),
      ),
      body: ListView.builder(
        itemCount: _notificationCounts.length,
        itemBuilder: (context, index) {
          final appName = _notificationCounts.keys.elementAt(index);
          final notificationCount = _notificationCounts[appName];

          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.apps),
            ),
            title: Text(appName),
            subtitle: Text('Notification count: $notificationCount'),
          );
        },
      ),
    );
  }
}
