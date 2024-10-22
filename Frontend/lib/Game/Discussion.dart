import 'package:flutter/material.dart';
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위해 추가
import 'package:http/http.dart' as http;

import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Vote.dart'; // Vote 페이지로 이동하기 위한 import

class Discussion extends StatefulWidget {
  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  int player = 0; // 플레이어들의 ID 목록
  List<int> job = []; // 각 플레이어의 직업 ID 목록
  List<int> alive = []; // 생존자 정보
  int currentIndex = 0; // 현재 표시할 플레이어 인덱스
  bool isLoading = true;
  String discussionResult = ""; // 백엔드에서 반환된 대사 문자열 저장

  @override
  void initState() {
    super.initState();
    _fetchGameInfo(); // 초기화 시 데이터 불러오기
  }

  // 백엔드에서 player와 Job[] 데이터를 받아오는 함수
  Future<void> _fetchGameInfo() async {
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
          player = data['player']; // player 정보 저장
          job = List<int>.from(data['Job']); // Job[] 배열 저장
          alive = List<int>.from(data['alive']); // alive[] 배열 저장
          isLoading = false;
          _postDiscussionChoice(alive[currentIndex], 99); // 첫 번째 플레이어에 대해 대사 요청
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 백엔드로 POST 요청 보내기: 현재 플레이어에 대한 대사 요청
  Future<void> _postDiscussionChoice(int PlayerId, int Act) async {
    final userId = MainPage.currentUserId;
    final url = Uri.parse('${MyApp.apiUrl}/api/discussion');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'PlayerId': PlayerId, 'Act': Act}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          discussionResult = data['message']; // 서버에서 받은 대사 저장
        });
      } else {
        print('POST 요청 실패');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 다음 플레이어로 넘어가는 함수
  void _showNextPlayer() {
    setState(() {
      if (currentIndex < alive.length - 1) {
        currentIndex++;
        _postDiscussionChoice(alive[currentIndex], 99); // 다음 플레이어에 대한 대사 요청
      }
    });
  }

  // 모든 플레이어를 순회했는지 확인하는 함수
  bool _isLastPlayer() {
    return currentIndex == alive.length - 1;
  }

  // Vote 페이지로 이동하는 함수
  void _goToVotePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Vote()), // Vote 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // 데이터 로딩 중일 때 로딩 표시
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${alive[currentIndex]} : $discussionResult',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (alive[currentIndex] == player) ...[
              // 현재 플레이어가 "player"일 때 3개의 버튼 표시
              ElevatedButton(
                onPressed: () {
                  _postDiscussionChoice(alive[currentIndex], 1); // Act 1: 의견내기
                  if (_isLastPlayer()) {
                    _goToVotePage(); // 마지막 플레이어일 경우 Vote로 이동
                  } else {
                    _showNextPlayer(); // 그 외엔 다음 플레이어로
                  }
                },
                child: Text('의견내기'),
              ),
              ElevatedButton(
                onPressed: () {
                  _postDiscussionChoice(alive[currentIndex], 2); // Act 2: 직업공개
                  if (_isLastPlayer()) {
                    _goToVotePage(); // 마지막 플레이어일 경우 Vote로 이동
                  } else {
                    _showNextPlayer(); // 그 외엔 다음 플레이어로
                  }
                },
                child: Text('직업공개'),
              ),
              ElevatedButton(
                onPressed: () {
                  _postDiscussionChoice(alive[currentIndex], 3); // Act 3: 가만있기
                  if (_isLastPlayer()) {
                    _goToVotePage(); // 마지막 플레이어일 경우 Vote로 이동
                  } else {
                    _showNextPlayer(); // 그 외엔 다음 플레이어로
                  }
                },
                child: Text('가만있기'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed:
                _isLastPlayer() ? _goToVotePage : _showNextPlayer, // 마지막 사람이면 Vote로 이동
                child: Text(_isLastPlayer() ? '확인' : '다음'), // 마지막이면 "확인" 표시
              ),
            ],
          ],
        ),
      ),
    );
  }
}
