import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnlockCountPage extends StatefulWidget {
  const UnlockCountPage({Key? key}) : super(key: key);

  @override
  _UnlockCountPageState createState() => _UnlockCountPageState();
}

class _UnlockCountPageState extends State<UnlockCountPage> {
  int _unlockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnlockCount();
  }

  Future<void> _loadUnlockCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _unlockCount = prefs.getInt('unlockCount') ?? 0;
    });
  }

  Future<void> _resetUnlockCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unlockCount', 0);
    setState(() {
      _unlockCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phone has been unlocked:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '$_unlockCount times',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _resetUnlockCount,
              child: const Text('Reset Unlock Count'),
            ),
          ],
        ),
      ),
    );
  }
}