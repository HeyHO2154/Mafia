import 'package:flutter/material.dart';

class SinglePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('혼자 하기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '혼자 하기 페이지',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '1. 베팅할 포인트',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '2. 참여할 캐릭터',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '3. 테마선택(ex. 우주, 서부시대)',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '죽더라도 관전으로\n추리해서 포인트 획득 가능',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
