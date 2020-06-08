import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_for_job/secondScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  int value;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  Future onSelectNotification(String payLoad) {
    return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen()))
        .then((value) {
      setState(() {
        widget.value = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializing();
    _showNotificationsAfterSecond();
    getValue();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('icon');

    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notificationAfterSec() async {
    Random random = new Random();
    int value = random.nextInt(100);
    saveRandomValue(value);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        '',
        'Изменить счетчик на ${value.toString()}',
        RepeatInterval.EveryMinute,
        notificationDetails);
  }

  saveRandomValue(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('randValue', value);
    return value;
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('value')) {
      setState(() {
        widget.value = prefs.get('value');
      });
    } else {
      prefs.setInt('value', 0);
      setState(() {
        widget.value = prefs.get('value');
      });
    }
  }

  decrementValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.value--;
    prefs.setInt('value', widget.value);
    setState(() {});
  }

  incrementValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.value++;
    prefs.setInt('value', widget.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => decrementValue(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Center(
                      child: Text(
                        '-',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.value.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
                GestureDetector(
                  onTap: () => incrementValue(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
