import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _getCounterValue();
  }

  Future<void> _incrementCounter() async {
    final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/increment'));
    if (response.statusCode == 200) {
      print("정상 작동");
    } else {
      print('숫자 증가 실패: ${response.statusCode}');
    }
  }

  Future<void> _getCounterValue() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/value'));
    if (response.statusCode == 200) {
      setState(() {
        _counter = int.parse(response.body);
      });
      print("정상 작동");
    } else {
      print('숫자 불러오기 실패: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MySQL 연동 테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('저장된 데이터: $_counter'),
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
