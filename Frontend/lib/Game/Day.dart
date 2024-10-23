import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 데이터를 파싱하기 위해 필요
import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Discussion.dart'; // API URL 접근
import 'Result.dart'; // Result 페이지를 import

class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  int? deadPlayer;
  int aliveCitizen = 0; // 시민 수
  int aliveMafia = 0;   // 마피아 수
  bool isLoading = true; // 데이터를 로딩 중인지 여부

  @override
  void initState() {
    super.initState();
    _fetchDeadPlayer(); // 페이지 로드 시 API 요청
    _fetchAliveInfo();  // 페이지 로드 시 Alive 정보 요청
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

  // Alive 정보를 받아오는 함수 (Alive_citizen, Alive_mafia)
  Future<void> _fetchAliveInfo() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/info'); // 백엔드 API 경로

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // userId를 POST 요청의 바디에 포함
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          aliveCitizen = data['Alive_citizen'].length;
          aliveMafia = data['Alive_mafia'].length;
        });
      } else {
        print('Alive 정보를 불러오는 데 실패했습니다.');
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

  // 조건에 따라 페이지 이동을 결정하는 함수
  void _checkAndNavigate() {
    // 마피아 수가 0이거나 마피아와 시민 수가 같을 경우 Result 페이지로 이동
    if (aliveMafia == 0 || aliveMafia == aliveCitizen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Result(),
        ),
      );
    } else {
      // 조건이 만족하지 않으면 Discussion 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Discussion()), // Discussion 페이지로 이동
      );
    }
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
              onPressed: _checkAndNavigate, // 확인 버튼 클릭 시 실행
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
