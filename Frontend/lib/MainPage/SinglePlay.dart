import 'package:flutter/material.dart';
import '../Game/Night.dart';

class SinglePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '혼자 하기 페이지',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
            ElevatedButton(
              onPressed: () {
                // Night 페이지로 이동하고 네비게이션 스택을 모두 제거
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Night()),
                      (Route<dynamic> route) => false, // 스택을 모두 제거
                );
              },
              child: Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
