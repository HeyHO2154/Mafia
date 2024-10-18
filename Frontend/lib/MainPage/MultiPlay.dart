import 'package:flutter/material.dart';

class MultiPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('같이 하기')),
      body: Center(
        child: Text(
          '같이 하기 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
