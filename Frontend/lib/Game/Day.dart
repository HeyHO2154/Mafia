import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '낮이 밝았습니다!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
