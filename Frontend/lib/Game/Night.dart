import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/MainPage.dart'; // MainPage에서 userId 가져오기
import '../main.dart'; // API URL 접근
import 'Day.dart'; // Day 페이지로 이동하기 위해 import

class Night extends StatefulWidget {
  @override
  _NightState createState() => _NightState();
}

class _NightState extends State<Night> {
  int? player;
  List<int>? job; // Job[] 정보를 담을 리스트
  List<int>? alive; // alive[] 정보를 담을 리스트
  int? selectedTarget; // 선택된 대상
  bool isLoading = true; // 데이터 로딩 여부
  bool hasSelected = false; // 플레이어가 대상자를 선택했는지 여부

  @override
  void initState() {
    super.initState();
    _fetchGameInfo(); // 화면이 로드될 때 API 호출
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
          alive = List<int>.from(data['alive']); // Job[] 배열 저장
          isLoading = false;
        });
      } else {
        print('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  // 행동 선택 후 백엔드로 POST 전송
  Future<void> _submitAction() async {
    if (job![player!] == 1) { // 경찰인 경우
      // 마피아 여부 확인
      bool isMafia = job![selectedTarget!] == -1;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('조사 결과'),
            content: Text(isMafia ? '선택한 대상은 마피아입니다.' : '선택한 대상은 마피아가 아닙니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  _submitActionToBackend(); // 결과를 백엔드에 전송하고 Day 페이지로 이동
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      _submitActionToBackend(); // 의사나 마피아인 경우 바로 백엔드로 전송
    }
  }

  // 백엔드에 선택된 결과 전송
  Future<void> _submitActionToBackend() async {
    final userId = MainPage.currentUserId;
    final url = Uri.parse('${MyApp.apiUrl}/api/night');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'target': selectedTarget,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 전송되었으면 Day 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Day()),
      );
    } else {
      print('행동 전송 실패');
    }
  }

  // 대상자를 선택하는 UI
  Widget _buildTargetSelector(String actionText, List<int> aliveList) {
    return Column(
      children: [
        Text('$actionText', style: TextStyle(fontSize: 24)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: aliveList.map((index) {
            return ChoiceChip(
              label: Text('$index'),
              selected: selectedTarget == index,
              onSelected: (bool selected) {
                setState(() {
                  selectedTarget = selected ? index : null;
                  hasSelected = true;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: hasSelected ? _submitAction : null, // 대상자가 선택되었을 때만 활성화
          child: Text('확인'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // 데이터 로딩 중 표시
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (job![player!] == 2)
              _buildTargetSelector('${player} 당신은 의사입니다. 누구를 치료하시겠습니까?', alive!),
            // alive 배열에서 선택
            if (job![player!] == 1)
              _buildTargetSelector('${player} 당신은 경찰입니다. 누구를 조사하시겠습니까?', alive!),
            // alive 배열에서 선택
            if (job![player!] == 0) // 시민일 때
              Column(
                children: [
                  Text('${player} 당신은 시민입니다. 잠을 잡니다.', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      selectedTarget = 99; // 시민의 경우 target을 99로 설정
                      _submitAction();     // 그 후에 Day 페이지로 이동하는 함수 호출
                    },
                    child: Text('확인'),
                  ),
                ],
              ),
            if (job![player!] == -1)
              _buildTargetSelector('${player} 당신은 마피아입니다. 누구를 죽이시겠습니까?', alive!),
            // alive 배열에서 선택
          ],
        ),
      ),
    );
  }
}
