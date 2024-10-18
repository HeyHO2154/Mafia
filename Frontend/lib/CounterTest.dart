import 'package:flutter/material.dart';
import 'package:frontend/MainPage/MainPage.dart';
import 'package:http/http.dart' as http;

class CounterTest extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterTest> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _getCounterValue();
  }

  Future<void> _incrementCounter() async {
    http.post(Uri.parse('http://10.0.2.2:8080/api/increment'));
  }

  Future<void> _getCounterValue() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/value'));
    if (response.statusCode == 200) {
      setState(() {
        _counter = int.parse(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('포인트: $_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('포인트 획득하기'),
            ),
            ElevatedButton(
              onPressed: () { // 중괄호를 추가하여 함수로 감싸줌
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text('뒤로가기'),
            ),
          ],
        ),
      ),
    );
  }
}
