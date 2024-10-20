import 'package:flutter/material.dart';

class Execution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Execution Phase'),
      ),
      body: Center(
        child: Text(
          'Time for an execution vote!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
