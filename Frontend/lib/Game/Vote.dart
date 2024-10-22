import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math'; // 랜덤 투표를 위해 사용
import 'dart:async'; // Timer를 사용하기 위해 import

import '../MainPage/MainPage.dart';
import '../main.dart';
import 'Execution.dart'; // Execution 페이지로 이동하기 위해 import
import 'Night.dart'; // Night 페이지로 이동하기 위해 import

class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  int player = 0; // 플레이어들의 ID 목록
  List<int> job = []; // 각 플레이어의 직업 ID 목록
  List<int> alive = []; // 생존자 정보
  int currentIndex = 0; // 현재 표시할 플레이어 인덱스
  bool isLoading = true;
  List<int> votes = []; // 각 플레이어가 받은 투표 수
  List<String> voteDialogue = []; // 플레이어의 투표 대사
  bool allVoted = false; // 모든 플레이어가 투표를 완료했는지 여부

  @override
  void initState() {
    super.initState();
    _fetchGameInfo(); // API 호출로 데이터를 받아옴
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
          votes = List.filled(alive.length, 0); // 생존자 수만큼 투표 수 배열 초기화
          isLoading = false;
        });
        // 플레이어가 아닌 첫 번째 인덱스부터 자동 투표 시작
        if (currentIndex != player) {
          _randomVoteWithDelay();
        }
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 현재 플레이어가 선택한 사람에게 투표
  void _voteForPlayer(int target) {
    setState(() {
      votes[target]++; // 선택한 플레이어의 투표 수 증가
      voteDialogue.add("플레이어 ${alive[currentIndex]}: 난 ${alive[target]}번에게 투표했어");
      currentIndex++; // 다음 플레이어로 이동

      if (currentIndex >= alive.length) {
        // 모든 투표가 완료된 후 1초 뒤에 최다 득표자 표시
        Future.delayed(Duration(seconds: 1), () {
          _showExecutionPage();
        });
      } else if (currentIndex != player) {
        // 플레이어가 아니라면 랜덤 투표 실행
        _randomVoteWithDelay();
      }
    });
  }

  // 랜덤하게 플레이어가 아닌 사람의 투표를 1초 대기 후 처리하는 함수
  void _randomVoteWithDelay() {
    Future.delayed(Duration(seconds: 1), () {
      _randomVote();
    });
  }

  // 랜덤하게 플레이어가 아닌 사람의 투표를 처리하는 함수
  void _randomVote() {
    final random = Random();
    int target = random.nextInt(alive.length); // 랜덤하게 생존자 중 한 명을 선택
    while (target == currentIndex) {
      // 자신에게 투표하는 것을 방지
      target = random.nextInt(alive.length);
    }

    setState(() {
      votes[target]++; // 선택한 플레이어의 투표 수 증가
      voteDialogue.add("플레이어 ${alive[currentIndex]}: 난 ${alive[target]}번에게 투표했어");
      currentIndex++; // 다음 플레이어로 이동

      if (currentIndex >= alive.length) {
        // 모든 투표가 완료된 후 1초 뒤에 최다 득표자 표시
        Future.delayed(Duration(seconds: 1), () {
          _showExecutionPage();
        });
      } else if (currentIndex != player) {
        // 플레이어가 아니라면 다시 랜덤 투표
        _randomVoteWithDelay();
      }
    });
  }

  // 최다 득표자를 계산하는 함수
  int _getTopVotedPlayer() {
    int maxVotes = votes.reduce((curr, next) => curr > next ? curr : next);
    return votes.indexOf(maxVotes);
  }

  // 투표 결과 페이지로 이동
  void _showExecutionPage() {
    int topVotedPlayer = _getTopVotedPlayer(); // 최다 득표자 계산
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Execution(topVotedPlayer: alive[topVotedPlayer]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 중일 때 로딩 화면 표시
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 플레이어들 아이콘 및 말풍선 표시
          Center(
            child: Wrap(
              spacing: 10.0,        // 각 아이템 사이의 가로 간격 설정
              runSpacing: 30.0,     // 각 줄 사이의 세로 간격 설정
              alignment: WrapAlignment.center,  // 아이템을 중앙 정렬
              children: alive.map((playerId) {
                return Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,  // 각 아이템의 너비를 화면의 절반으로 설정
                  child: Column(
                    children: [
                      // 말풍선 형태로 투표한 결과를 보여줌
                      if (currentIndex > alive.indexOf(playerId))
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            '난 ${alive[votes.indexOf(votes[alive.indexOf(playerId)])]}번에게 투표했어',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      // 플레이어 아이콘 (사람 모양 아이콘 사용)
                      Icon(
                        Icons.person,
                        size: 50,
                        color: currentIndex == alive.indexOf(playerId)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      Text('$playerId번'),
                    ],
                  ),
                );
              }).toList(),
            )
          ),

          // 현재 플레이어에게 투표할 대상을 선택하게 함
          if (currentIndex == player)
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('플레이어 ${alive[currentIndex]}의 차례입니다.'),
                  Wrap(
                    spacing: 10.0,
                    children: alive.map((playerId) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          backgroundColor: Colors.blue, // 심플한 버튼 스타일
                        ),
                        onPressed: () => _voteForPlayer(alive.indexOf(playerId)),
                        child: Text(
                          '$playerId번',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
