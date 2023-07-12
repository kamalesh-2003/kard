import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Click the button to share URI',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text(
                'Share URI',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                await _shareUri();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareUri() async {
    try {
      final String uri = 'https://example.com'; // Replace with your desired URI

      await FlutterNfcReader.write([NdefMessage([NdefRecord.uri(uri)])]);

      final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
      final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        'channel_description',
        importance: Importance.high,
        priority: Priority.high,
      );
      final platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'URI Shared',
        'The URI has been shared via NFC.',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error sharing URI: $e');
    }
  }
}
