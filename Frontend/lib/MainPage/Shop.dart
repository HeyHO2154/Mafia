import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상점')),
      body: Center(
        child: Text(
          '상점 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
