import 'package:flutter/material.dart';

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      body: Center(
        child: Text(
          '내 정보 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
