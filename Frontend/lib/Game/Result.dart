import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../MainPage/MainPage.dart';
import '../main.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int aliveCitizen = 0; // 남은 시민 수
  int aliveMafia = 0; // 남은 마피아 수
  bool isLoading = true; // 로딩 상태를 위한 플래그

  @override
  void initState() {
    super.initState();
    _fetchGameResult(); // 백엔드에서 시민과 마피아 수를 받아옴
  }

  // 백엔드에서 시민과 마피아 수를 받아오는 함수
  Future<void> _fetchGameResult() async {
    final userId = MainPage.currentUserId; // MainPage에서 userId 가져옴
    final url = Uri.parse('${MyApp.apiUrl}/api/info'); // 백엔드 API 경로

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          aliveCitizen = data['Alive_citizen'].length; // 시민 수 받아옴
          aliveMafia = data['Alive_mafia'].length; // 마피아 수 받아옴
          isLoading = false; // 로딩 완료
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 승리 조건에 따라 메시지 출력
  String _getResultMessage() {
    if (aliveMafia == 0) {
      return '시민 승리!';
    } else if (aliveMafia == aliveCitizen) {
      return '마피아 승리!';
    } else {
      return ''; // 이 경우는 발생하지 않겠지만, 안전을 위해 빈 문자열 반환
    }
  }

  // 확인 버튼을 누르면 MainPage로 이동하는 함수
  void _goToMainPage(BuildContext context) {
    final userId = MainPage.currentUserId;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage(userId: userId!)), // userId를 명시적으로 전달
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
      appBar: AppBar(title: Text('게임 결과')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getResultMessage(), // 승리 메시지 출력
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToMainPage(context), // 확인 버튼 클릭 시 MainPage로 이동
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
