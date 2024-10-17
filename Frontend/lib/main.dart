import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/increment'));
    if (response.statusCode == 200) {
      _getCounterValue();
    } else {
      print('Failed to increment counter. Status code: ${response.statusCode}');
    }
  }

  Future<void> _getCounterValue() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/value'));
    if (response.statusCode == 200) {
      setState(() {
        _counter = int.parse(response.body);
      });
    } else {
      print('Failed to get counter value. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Counter Value: $_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('A 버튼 (숫자 증가)'),
            ),
            ElevatedButton(
              onPressed: _getCounterValue,
              child: Text('B 버튼 (숫자 조회)'),
            ),
          ],
        ),
      ),
    );
  }
}
