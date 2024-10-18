import 'package:flutter/material.dart';

class SinglePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('혼자 하기')),
      body: Center(
        child: Text(
          '혼자 하기 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
