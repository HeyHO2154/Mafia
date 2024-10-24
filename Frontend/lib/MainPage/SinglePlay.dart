import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 파싱을 위해 필요
import '../Game/Night.dart';
import '../MainPage/MainPage.dart';
import '../main.dart'; // MainPage에 접근하기 위해 import

class SinglePlay extends StatefulWidget {
  @override
  _SinglePlayState createState() => _SinglePlayState();
}

class _SinglePlayState extends State<SinglePlay> {
  int currentPoints = 1000; // 유저가 보유한 포인트 (예시로 1000포인트 설정)
  int bettingPoints = 0; // 베팅할 포인트

  Future<void> _startGame(BuildContext context) async {
    // MainPage의 static 변수로부터 userId를 가져옴
    final userId = MainPage.currentUserId;

    if (userId == null) {
      print('User ID가 존재하지 않습니다.');
      return;
    }

    final url = Uri.parse('${MyApp.apiUrl}/api/start_game'); // 백엔드 API 주소

    // 백엔드로 POST 요청을 보내서 게임 데이터를 생성
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'bettingPoints': bettingPoints}), // 베팅 포인트도 함께 보냄
    );

    if (response.statusCode == 200) {
      // Night 페이지로 이동하고 네비게이션 스택을 모두 제거
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => Night()),
            (Route<dynamic> route) => false, // 스택을 모두 제거
      );
    } else {
      // 오류 처리
      print('게임 데이터를 불러오는 데 실패했습니다.');
    }
  }

  void _setBettingPoints(int points) {
    setState(() {
      bettingPoints = points; // 베팅할 포인트 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${MainPage.currentUserId}님 혼자 하기 페이지', // 문자열 보간을 사용하여 userId를 출력
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
            Text(
              '보유 포인트: ${currentPoints}p', // 현재 보유 포인트를 표시
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '베팅할 포인트:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setBettingPoints(100); // 100p 선택
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bettingPoints == 100 ? Colors.green : null, // 선택된 버튼은 초록색
                  ),
                  child: Text('100p'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _setBettingPoints(500); // 500p 선택
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bettingPoints == 500 ? Colors.green : null, // 선택된 버튼은 초록색
                  ),
                  child: Text('500p'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _setBettingPoints(1000); // 1000p 선택
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bettingPoints == 1000 ? Colors.green : null, // 선택된 버튼은 초록색
                  ),
                  child: Text('1000p'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: bettingPoints > 0 ? () {
                _startGame(context); // API를 호출하여 게임을 시작
              } : null, // 베팅 금액을 선택해야 확인 버튼이 활성화됨
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
