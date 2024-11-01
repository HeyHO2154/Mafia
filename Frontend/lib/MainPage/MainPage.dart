import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 데이터를 파싱하기 위해 필요

import '../main.dart';
import 'MultiPlay.dart';
import 'MyInfo.dart';
import 'Shop.dart';
import 'SinglePlay.dart';

class MainPage extends StatefulWidget {
  final String userId; // 사용자 아이디를 받을 필드
  static String? currentUserId; // 다른 곳에서 접근할 수 있도록 static 변수 선언

  MainPage({required this.userId}) {
    currentUserId = userId; // 현재 사용자의 ID를 static 변수에 저장
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _point = 0; // point 값을 저장할 변수

  @override
  void initState() {
    super.initState();
    _getPointValue(); // 초기화할 때 포인트 값을 가져옴
  }

  // userId에 맞는 포인트 데이터를 백엔드에서 가져옴
  Future<void> _getPointValue() async {
    final response = await http.get(Uri.parse('${MyApp.apiUrl}/api/points?userId=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        _point = jsonDecode(response.body)['point']; // JSON에서 point 값을 추출하여 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                children: [
                  Text(
                    '포인트: $_point', // point 값을 출력
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            Text(
              'AI 마피아',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1.0, // 정사각형 비율
                              child: _buildMenuButton(context, '혼자 하기', Icons.person, SinglePlay()),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1.0, // 정사각형 비율
                              child: _buildMenuButton(context, '같이 하기', Icons.group, MultiPlay()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1.0, // 정사각형 비율
                              child: _buildMenuButton(context, '내 저장고', Icons.book, MyInfo()),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1.0, // 정사각형 비율
                              child: _buildMenuButton(context, '상점', Icons.card_giftcard, Shop()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴 버튼 빌드 메서드
  Widget _buildMenuButton(BuildContext context, String text, IconData icon, Widget nextPage) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage), // 해당하는 페이지로 이동
        );
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(16),
        side: BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // 사각형 모양으로 설정
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black), // 원하는 아이콘과 크기, 색상
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
