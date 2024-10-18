
import 'package:flutter/material.dart';

import 'CounterTest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // 앱 테마 설정
      theme: ThemeData(
        primarySwatch: Colors.teal, // 앱 전체의 기본 색상
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),
          bodyMedium: TextStyle(fontSize: 20, color: Colors.grey[800]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal, // 버튼 배경색
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10), // 버튼 패딩 설정
            textStyle: TextStyle( // 버튼 텍스트 스타일 설정
              fontSize: 15, // 폰트 크기
              fontWeight: FontWeight.bold, // 글꼴 두께
            ),
          ),
        ),
      ),

      home: CounterPage(),
    );
  }
}