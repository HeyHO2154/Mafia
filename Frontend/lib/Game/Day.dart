import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Phase'),
      ),
      body: Center(
        child: Text(
          'It\'s daytime! Players discuss strategies.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
