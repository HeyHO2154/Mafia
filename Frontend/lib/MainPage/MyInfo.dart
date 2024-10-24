import 'package:flutter/material.dart';

class MyInfo extends StatefulWidget {
  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  // 초기 유저 정보
  String userName = "홍길동";
  int userPoints = 1200;
  int userLevel = 10; // 유저 레벨
  double userExp = 0.75; // 경험치 진행도 (0.0 ~ 1.0 사이 값)
  String userTheme = "기본 테마"; // 유저가 보유 중인 테마

  // TextEditingController를 사용해 이름을 수정 가능하도록 설정
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 초기 값 설정
    _nameController.text = userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            // 프로필 사진
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                AssetImage('assets/profile_placeholder.png'), // 임시 이미지
              ),
            ),
            SizedBox(height: 20),
            // 이름 입력 필드 (수정 가능)
            _buildInfoField(
              label: "이름",
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),
            SizedBox(height: 20),
            // 레벨 (수정 불가)
            _buildReadOnlyInfoField(
              label: "레벨",
              value: "$userLevel",
            ),
            SizedBox(height: 20),
            // 경험치 바 (수정 불가)
            Text(
              "경험치",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: userExp, // 진행도
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            SizedBox(height: 5),
            Text(
              "${(userExp * 100).toInt()}%", // 진행도 퍼센트로 표시
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // 보유 중인 테마 (수정 불가)
            _buildReadOnlyInfoField(
              label: "보유 중인 테마",
              value: userTheme,
            ),
            SizedBox(height: 20),
            // 포인트
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '포인트:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$userPoints P', // 포인트 출력
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // 변경 사항 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 변경 사항 저장 동작 구현 가능
                  print('변경 사항 저장');
                },
                child: Text('변경 사항 저장'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이름 입력 필드를 만들어주는 함수 (수정 가능)
  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "$label 입력",
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
      ],
    );
  }

  // 수정 불가능한 정보를 표시하는 함수
  Widget _buildReadOnlyInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[100],
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
