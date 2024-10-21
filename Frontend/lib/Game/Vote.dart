import 'package:flutter/material.dart';

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '투표를 시작합니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
