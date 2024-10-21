import 'package:flutter/material.dart';

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Players are voting!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
