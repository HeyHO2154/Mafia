import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Night.dart'; // Night 페이지로 이동하기 위해 import

class Execution extends StatefulWidget {
  @override
  _ExecutionState createState() => _ExecutionState();
}

class _ExecutionState extends State<Execution> {
  int votedPlayer = 99; // 기본값을 99로 설정 (동률인 경우)
  bool isLoading = true; // 로딩 상태를 위한 플래그

  @override
  void initState() {
    super.initState();
    _fetchExecutionInfo(); // 백엔드에서 처형 정보를 받아옴
  }

  // 백엔드에서 처형 정보를 받아오는 함수
  Future<void> _fetchExecutionInfo() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/execution'); // 실제 API URL로 교체

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // userId를 요청 본문에 포함
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          votedPlayer = data['votedPlayer']; // votedPlayer 값 저장
          isLoading = false; // 로딩 완료
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }


  // 확인 버튼을 누르면 Night 페이지로 이동하는 함수
  void _goToNightPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Night()), // Night 페이지로 이동
    );
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
              onPressed: _goToNightPage, // 확인 버튼 클릭 시 Night 페이지로 이동
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
