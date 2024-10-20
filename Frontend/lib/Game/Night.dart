import 'package:flutter/material.dart';

class Night extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'It\'s nighttime! Special roles act now.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
