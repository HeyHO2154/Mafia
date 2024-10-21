import 'package:flutter/material.dart';

class Night extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Night Phase'),
      ),
      body: Center(
        child: Text(
          '밤이 되었습니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
