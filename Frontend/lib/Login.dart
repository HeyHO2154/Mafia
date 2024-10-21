import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'MainPage/MainPage.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _loginOrRegister() async {
    final userId = idController.text;
    final password = passwordController.text;

    if (userId.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('아이디와 비밀번호를 모두 입력해주세요!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${MyApp.apiUrl}/api/login_or_register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'password': password}),
    );

    if (response.statusCode == 200) {
      // 회원가입 성공 시 아이디를 로컬 저장소에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);

      // 로그인 또는 회원가입 성공 시 MainPage로 이동(pushReplacement 덕분에 뒤로가기 기록 삭제)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userId: userId)),
      );
    } else if (response.statusCode == 401) {
      // 비밀번호 불일치
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인 실패'),
            content: Text('비밀번호가 틀립니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      print("로그인 또는 회원가입 실패");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '싱글 마피아 게임',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Text(
              '최초 접속시에 뜨는 창입니다. 이후 자동 로그인 됩니다.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: '닉네임을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true, // 비밀번호 마스킹 처리
              decoration: InputDecoration(
                labelText: '비밀번호를 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _loginOrRegister,
              child: Text('입장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
