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
          _postDiscussionChoice(alive[currentIndex], 99, 99, 99, false); // 첫 번째 플레이어에 대해 대사 요청
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 백엔드로 POST 요청 보내기: 현재 플레이어에 대한 대사 요청
  Future<void> _postDiscussionChoice(int PlayerId, int Act, int FakeJob, int TargetId, bool IsMafia) async {
    final userId = MainPage.currentUserId;
    final url = Uri.parse('${MyApp.apiUrl}/api/discussion');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'PlayerId': PlayerId, 'Act': Act, 'FakeJob': FakeJob, 'TargetId': TargetId, 'IsMafia': IsMafia}),
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

  // _selectFakeJob 메서드 추가
  Future<int> _selectFakeJob() {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('거짓 직업 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(1); // 경찰 선택
                },
                child: Text('경찰'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(2); // 의사 선택
                },
                child: Text('의사'),
              ),
            ],
          ),
        );
      },
    ).then((value) => value ?? 99); // 아무 것도 선택하지 않으면 기본값 99 반환
  }

  // _selectTargetId 메서드 추가
  Future<int> _selectTargetId() {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('타겟 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: alive.map((id) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(id); // 선택한 생존자의 ID 반환
                },
                child: Text('Player $id'),
              );
            }).toList(),
          ),
        );
      },
    ).then((value) => value ?? 99); // 아무 것도 선택하지 않으면 기본값 99 반환
  }

  // _selectIsMafia 메서드 추가
  Future<bool> _selectIsMafia() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('조사 결과 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 마피아로 선택
                },
                child: Text('마피아'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 마피아가 아니라고 선택
                },
                child: Text('마피아가 아님'),
              ),
            ],
          ),
        );
      },
    ).then((value) => value ?? false); // 선택하지 않으면 기본값으로 false 반환
  }

  // 다음 플레이어로 넘어가는 함수
  void _showNextPlayer() {
    setState(() {
      if (currentIndex < alive.length - 1) {
        currentIndex++;
        _postDiscussionChoice(alive[currentIndex], 99, 99, 99, false); // 다음 플레이어에 대한 대사 요청
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
                onPressed: () async {
                  int fakeJob = 99;
                  int targetId = 99;
                  bool isMafia = false;

                  // 플레이어가 마피아일 경우에만 fakeJob, isMafia 설정
                  if (job[currentIndex] == -1) {  // 마피아 여부 확인
                    fakeJob = await _selectFakeJob();  // 마피아가 선택한 거짓 직업 (1: 경찰, 2: 의사)

                    if (fakeJob == 1 || fakeJob == 2) {
                      targetId = await _selectTargetId();  // 생존자 중에서 타겟 고르기
                    }

                    if (fakeJob == 1) {  // FakeJob이 1인 경우 (경찰 역할)
                      isMafia = await _selectIsMafia();  // 조사 결과가 마피아인지 여부
                    }
                  } else {
                    // 일반 시민이 1번 "의견내기"를 선택한 경우에만 타겟을 선택
                    targetId = await _selectTargetId();
                  }

                  _postDiscussionChoice(alive[currentIndex], 1, fakeJob, targetId, isMafia);  // Act 1: 의견내기
                  if (_isLastPlayer()) {
                    _goToVotePage(); // 마지막 플레이어일 경우 Vote로 이동
                  } else {
                    _showNextPlayer(); // 그 외엔 다음 플레이어로
                  }
                },
                child: Text('의견내기'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int fakeJob = 99;
                  int targetId = 99;
                  bool isMafia = false;

                  if (job[currentIndex] == -1) {
                    fakeJob = await _selectFakeJob();

                    if (fakeJob == 1 || fakeJob == 2) {
                      targetId = await _selectTargetId();
                    }

                    if (fakeJob == 1) {
                      isMafia = await _selectIsMafia();
                    }
                  }

                  _postDiscussionChoice(alive[currentIndex], 2, fakeJob, targetId, isMafia);  // Act 2: 직업공개
                  if (_isLastPlayer()) {
                    _goToVotePage(); // 마지막 플레이어일 경우 Vote로 이동
                  } else {
                    _showNextPlayer(); // 그 외엔 다음 플레이어로
                  }
                },
                child: Text('직업공개'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int fakeJob = 99;
                  int targetId = 99;
                  bool isMafia = false;

                  if (job[currentIndex] == -1) {
                    fakeJob = await _selectFakeJob();

                    if (fakeJob == 1 || fakeJob == 2) {
                      targetId = await _selectTargetId();
                    }

                    if (fakeJob == 1) {
                      isMafia = await _selectIsMafia();
                    }
                  }

                  _postDiscussionChoice(alive[currentIndex], 3, fakeJob, targetId, isMafia);  // Act 3: 가만있기
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
