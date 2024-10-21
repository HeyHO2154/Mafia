import 'package:flutter/material.dart';

class Discussion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk Phase'),
      ),
      body: Center(
        child: Text(
          '토론을 통해 마피아를 찾아보세요',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
