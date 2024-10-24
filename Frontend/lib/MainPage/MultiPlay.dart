import 'package:flutter/material.dart';

import 'MainPage.dart';

class MultiPlay extends StatefulWidget {
  @override
  _MultiPlayState createState() => _MultiPlayState();
}

class _MultiPlayState extends State<MultiPlay> {
  bool isPressed = false;
  List<Map<String, dynamic>> messages = []; // 메시지와 내가 보낸 메시지 여부를 저장
  TextEditingController _controller = TextEditingController();
  // 내 아이디를 받아오고, null이거나 빈 값이면 "none"으로 설정
  String myId = (MainPage.currentUserId ?? "none").isNotEmpty
      ? MainPage.currentUserId!
      : "none";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          // 상단에 게임 참여하기 버튼
          ElevatedButton(
            onPressed: () {
              setState(() {
                isPressed = !isPressed; // 버튼 상태 토글
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isPressed ? Colors.green : Colors.red, // 상태에 따른 색상
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: TextStyle(fontSize: 24),
            ),
            child: Text(
              '게임 참여하기 00:00:00',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 50),
          // 채팅 박스
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isMe = messages[index]['isMe'];
                  return Column(
                    crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // 아이디 표시
                      Text(
                        isMe ? myId : "테스트", // 내 메시지 위에는 내 아이디, 상대방은 "테스트"
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.white : Colors.blue[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            messages[index]['text'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // 채팅 입력창
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '메시지를 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        // 내가 보낸 메시지 추가
                        messages.add({'text': _controller.text, 'isMe': true});
                        // 자동 응답 추가
                        messages.add({'text': '테스트 답변', 'isMe': false});
                        _controller.clear(); // 입력 필드 초기화
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
