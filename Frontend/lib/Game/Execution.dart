import 'package:flutter/material.dart';
import 'Night.dart'; // Night 페이지를 import

class Execution extends StatelessWidget {
  final int topVotedPlayer; // 최다 득표자를 받는 변수

  Execution({required this.topVotedPlayer}); // 생성자에서 값을 받아옴

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('최다 득표자는 ${topVotedPlayer}번입니다.'),
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
}
