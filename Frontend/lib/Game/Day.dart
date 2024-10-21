import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 데이터를 파싱하기 위해 필요
import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Discussion.dart'; // API URL 접근

class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  int? deadPlayer;
  bool isLoading = true; // 데이터를 로딩 중인지 여부

  @override
  void initState() {
    super.initState();
    _fetchDeadPlayer(); // 페이지 로드 시 API 요청
  }

  // 죽은 사람 정보를 백엔드에서 받아오는 함수
  Future<void> _fetchDeadPlayer() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/day'); // 백엔드 API 경로

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // userId를 POST 요청의 바디에 포함
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          deadPlayer = data['deadPlayer']; // 죽은 사람 정보 저장
          isLoading = false;
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }



  // 죽은 사람이 없을 경우의 메시지
  String _getDeathMessage() {
    if (deadPlayer == null) {
      return '데이터를 불러오는 중입니다...';
    } else if (deadPlayer == 99) {
      return '아무도 죽지 않았습니다.';
    } else {
      return '$deadPlayer번이 죽었습니다.';
    }
  }

  // 확인 버튼 클릭 시 Discussion 페이지로 이동
  void _goToDiscussion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Discussion()), // Discussion 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // 데이터를 로딩 중일 때
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getDeathMessage(), // 죽은 사람 메시지 출력
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
            ElevatedButton(
              onPressed: _goToDiscussion, // 확인 버튼 클릭 시 실행
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
