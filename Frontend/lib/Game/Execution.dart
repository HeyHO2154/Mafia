import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Night.dart'; // Night 페이지로 이동하기 위해 import
import 'Result.dart'; // Result 페이지로 이동하기 위해 import

class Execution extends StatefulWidget {
  @override
  _ExecutionState createState() => _ExecutionState();
}

class _ExecutionState extends State<Execution> {
  int votedPlayer = 99; // 기본값을 99로 설정 (동률인 경우)
  int aliveCitizen = 0; // 시민 수
  int aliveMafia = 0; // 마피아 수
  bool isLoading = true; // 로딩 상태를 위한 플래그

  @override
  void initState() {
    super.initState();
    _fetchExecutionInfo(); // 처형 정보 API 호출
    _fetchAliveInfo();     // Alive 정보 API 호출
  }

  // 처형 정보를 받아오는 함수 (votedPlayer)
  Future<void> _fetchExecutionInfo() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/execution'); // 실제 API URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // userId를 요청 본문에 포함
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          votedPlayer = data['votedPlayer'] ?? 99; // votedPlayer 값 저장
        });
      } else {
        print('처형 정보를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // Alive 정보를 받아오는 함수 (Alive_citizen, Alive_mafia)
  Future<void> _fetchAliveInfo() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/info'); // 실제 API URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // userId를 요청 본문에 포함
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          aliveCitizen = data['Alive_citizen'].length; // aliveCitizen 수 저장
          aliveMafia = data['Alive_mafia'].length; // aliveMafia 수 저장
          isLoading = false; // 로딩 완료
        });
      } else {
        print('Alive 정보를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 조건에 따라 페이지 이동을 결정하는 함수
  void _checkAndNavigate() {
    print('마피아 수: $aliveMafia');
    print('시민 수: $aliveCitizen');
    // 마피아 수가 0이거나 마피아와 시민 수가 같을 경우 Result 페이지로 이동
    if (aliveMafia == 0 || aliveMafia == aliveCitizen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Result(),
        ),
      );
    } else {
      // 그렇지 않으면 Night 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Night()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // 로딩 중일 때 로딩 화면 표시
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // votedPlayer에 따라 다른 메시지 출력
            Text(
              votedPlayer == 99
                  ? '동률로 아무도 처형당하지 않았습니다.'
                  : '$votedPlayer님이 최다 득표로 처형당하였습니다.',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAndNavigate, // 확인 버튼 클릭 시 조건에 따라 페이지 이동
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
