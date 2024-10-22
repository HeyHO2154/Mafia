import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../MainPage/MainPage.dart';
import '../main.dart';
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
        allVoted = true; // 모든 플레이어가 투표를 완료함
      }
    });
  }

  // 최다 득표자를 계산하는 함수
  int _getTopVotedPlayer() {
    int maxVotes = votes.reduce((curr, next) => curr > next ? curr : next);
    return votes.indexOf(maxVotes);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 중일 때 로딩 화면 표시
      );
    }

    if (allVoted) {
      // 최종 투표 결과를 표시하는 화면
      int topVotedPlayer = _getTopVotedPlayer();
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('최다 득표자는 ${alive[topVotedPlayer]}번입니다.'),
              ElevatedButton(
                onPressed: () {
                  // Night 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Night()),
                  );
                },
                child: Text('확인'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 투표한 대사를 순서대로 표시
          Expanded(
            child: ListView.builder(
              itemCount: voteDialogue.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(voteDialogue[index]),
                );
              },
            ),
          ),
          // 현재 플레이어에게 투표할 대상을 선택하게 함
          if (currentIndex < alive.length)
            Column(
              children: [
                Text('플레이어 ${alive[currentIndex]}의 차례입니다.'),
                Wrap(
                  spacing: 10.0,
                  children: alive.map((playerId) {
                    return ElevatedButton(
                      onPressed: () => _voteForPlayer(alive.indexOf(playerId)),
                      child: Text('$playerId번에게 투표'),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
