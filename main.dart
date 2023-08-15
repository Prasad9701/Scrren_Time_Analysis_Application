import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'unlock_count_page.dart';
import 'notificationcount.dart';

void main() {
  runApp(const AppUsageApp());
}

class AppUsageApp extends StatelessWidget {
  const AppUsageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Usage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppUsagePage(),
    );
  }
}

class AppUsagePage extends StatefulWidget {
  const AppUsagePage({super.key});

  @override
  AppUsagePageState createState() => AppUsagePageState();
}

class AppUsagePageState extends State<AppUsagePage> {
  List<CustomAppUsageInfo> _appUsageList = [];

  @override
  void initState() {
    super.initState();
    getAppUsageData();
  }

  Future<Uint8List?> _getAppIcon(String packageName) async {
    Application? app = await DeviceApps.getApp(packageName, true);
    return app is ApplicationWithIcon ? app.icon : null;
  }

  void getAppUsageData() async {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime endDate = DateTime.now();

    AppUsage appUsage = AppUsage();
    List<AppUsageInfo> appUsageList =
        await appUsage.getAppUsage(startDate, endDate);

    List<CustomAppUsageInfo> customAppUsageList = [];
    for (AppUsageInfo info in appUsageList) {
      Uint8List? icon = await _getAppIcon(info.packageName);
      Application? app = await DeviceApps.getApp(info.packageName);
      String appName = app != null ? app.appName : info.packageName;
      customAppUsageList.add(
          CustomAppUsageInfo(appUsageInfo: info, icon: icon, name: appName));
    }

    customAppUsageList.sort(
        (a, b) => b.usage.inMilliseconds.compareTo(a.usage.inMilliseconds));

    setState(() {
      _appUsageList = customAppUsageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Time Analysis'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationCountPage()),
          );
        },
        child: const Icon(Icons.assessment),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _appUsageList.length,
                itemBuilder: (context, index) {
                  final app = _appUsageList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: app.icon != null
                          ? MemoryImage(app.icon!)
                          : const AssetImage('assets/images/default_icon.png')
                              as ImageProvider<Object>?,
                    ),
                    title: Text(app.name),
                    subtitle: Text(
                        'Usage: ${app.usage.inHours}:${app.usage.inMinutes.remainder(60)}:${app.usage.inSeconds.remainder(60)}'),
                  );
                },
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnlockCountPage()),
                );
              },
              child: const Text('Show Unlock Count'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppUsageInfo {
  final AppUsageInfo appUsageInfo;
  final Uint8List? icon;
  final String name;

  CustomAppUsageInfo(
      {required this.appUsageInfo, this.icon, required this.name});

  String get packageName => appUsageInfo.packageName;
  Duration get usage => appUsageInfo.usage;
}
