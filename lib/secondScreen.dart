import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondScreen extends StatefulWidget {
  int value;
  int randValue;
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    getValue();
    getRandomNumber();
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

  setValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('value', widget.value + widget.randValue);
  }

  getRandomNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('randValue')) {
      setState(() {
        widget.randValue = prefs.get('randValue');
      });
    } else {
      prefs.setInt('randValue', 0);
      setState(() {
        widget.randValue = prefs.get('randValue');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Текущее значение счетчика:'),
                SizedBox(width: 10),
                Text(widget.value.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Новое значение счетчика:'),
                SizedBox(width: 10),
                Text((widget.value + widget.randValue).toString()),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context,widget.value);
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.red),
                  child: Center(
                    child: Text(
                      'Отмена',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setValue();
                  Navigator.pop(context,widget.value+widget.randValue);
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
