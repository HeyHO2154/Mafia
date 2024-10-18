import 'package:flutter/material.dart';

class Guide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게임 설명')),
      body: Center(
        child: Text(
          '게임 설명 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
