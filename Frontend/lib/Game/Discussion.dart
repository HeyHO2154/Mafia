import 'package:flutter/material.dart';

class Talk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk Phase'),
      ),
      body: Center(
        child: Text(
          'Players are discussing during the talk phase.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
