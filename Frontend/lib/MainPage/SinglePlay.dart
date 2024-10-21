import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 파싱을 위해 필요
import '../Game/Night.dart';
import '../MainPage/MainPage.dart';
import '../main.dart'; // MainPage에 접근하기 위해 import

class SinglePlay extends StatelessWidget {
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
      body: jsonEncode({'userId': userId}),
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
            ElevatedButton(
              onPressed: () {
                _startGame(context); // API를 호출하여 게임을 시작
              },
              child: Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
