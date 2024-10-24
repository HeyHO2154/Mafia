import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainPage/MainPage.dart';
import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //매번 아이피 가져오기 귀찮아서, 이리 설정
  static const String apiUrl = 'http://10.0.2.2:8080';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 마피아',
      home: HomePage(), // 홈 페이지를 초기 화면으로 설정
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    //_resetPreferences(); //디버그용 초기화
  }

  //////////////////////서버 안열려있으면 아예 닫아버리는 구문 추가 필요함

  // SharedPreferences 초기화 함수 -- 디버깅용-- (자동로그인 기능)
  Future<void> _resetPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 로컬 저장소 초기화
    print('로컬 저장소 초기화 완료');
  }


  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id'); // 로컬 저장소에서 아이디 확인

    if (userId != null) {
      // 아이디가 저장되어 있으면 MainPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userId: userId)),
      );
    } else {
      // 아이디가 없으면 LoginPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // 로딩 화면
    );
  }
}
