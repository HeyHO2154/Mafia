import 'package:flutter/material.dart';

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote Phase'),
      ),
      body: Center(
        child: Text(
          'Players are voting!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
