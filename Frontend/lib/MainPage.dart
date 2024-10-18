import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'MainPage/MultiPlay.dart';
import 'MainPage/SinglePlay.dart'; // 새로운 파일들 임포트
import 'MainPage/MyInfo.dart';
import 'CounterTest.dart';
import 'MainPage/Guide.dart'; // 게임 설명

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _getCounterValue();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                children: [
                  Text(
                    '포인트: $_counter',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            Text(
              '싱글 마피아 게임',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildMenuButton(context, '혼자 하기', Icons.person, SinglePlay()), // SinglePlay로 이동
                    _buildMenuButton(context, '같이 하기', Icons.group, MultiPlay()), // MultiPlay로 이동
                    _buildMenuButton(context, '내 정보', Icons.account_circle, MyInfo()), // MyInfo로 이동
                    _buildMenuButton(context, '상점', Icons.shopping_cart, CounterTest()), // CounterTest로 이동
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Guide()), // Guide로 이동
                );
              },
              child: Text(
                '게임 설명',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, Widget nextPage) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage), // 해당하는 페이지로 이동
        );
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(16),
        side: BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // 사각형 모양으로 설정
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black), // 원하는 아이콘과 크기, 색상
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
