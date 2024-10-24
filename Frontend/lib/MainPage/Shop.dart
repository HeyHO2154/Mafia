import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  // 현재 보유 중인 포인트
  final int currentPoints = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              // 현재 보유 중인 포인트 상단 우측에 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '포인트: $currentPoints',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // 포인트 밑에 약간의 공간 추가
              _buildSectionHeader('포인트 충전', context),
              SizedBox(height: 10),
              _buildPointChargeRow(context), // 포인트 충전은 가로 배열
              _buildDivider(),
              _buildSectionHeader('테마 구매', context),
              SizedBox(height: 10),
              _buildThemeColumn(context), // 테마는 세로 배열
              _buildDivider(),
              _buildSectionHeader('아이템 구매', context),
              SizedBox(height: 10),
              _buildItemColumn(context), // 아이템은 세로 배열
            ],
          ),
        ),
      ),
    );
  }

  // 섹션 헤더
  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // 포인트 충전 섹션 (가로 배열)
  Widget _buildPointChargeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinimalPointChargeTile('500포인트', '5,000원', null, context),
        _buildMinimalPointChargeTile('1100포인트', '10,000원', '+100p', context), // 세일 표시
        _buildMinimalPointChargeTile('6000포인트', '50,000원', '+1000p', context), // 세일 표시
      ],
    );
  }

  // 테마 구매 섹션 (세로 배열)
  Widget _buildThemeColumn(BuildContext context) {
    return Column(
      children: [
        _buildMinimalThemeTile('어두운 테마', '1,000 P', context),
        _buildMinimalThemeTile('밝은 테마', '2,500 P', context),
        _buildMinimalThemeTile('클래식 테마', '5,000 P', context),
      ],
    );
  }

  // 아이템 구매 섹션 (세로 배열)
  Widget _buildItemColumn(BuildContext context) {
    return Column(
      children: [
        _buildMinimalItemTile('파워업', '10 P', context),
        _buildMinimalItemTile('보호막', '250 P', context),
        _buildMinimalItemTile('속도 증가', '500 P', context),
      ],
    );
  }

  // 포인트 충전 타일 (+세일 표시를 오른쪽 상단에 꼬리표 스타일로 표시)
  Widget _buildMinimalPointChargeTile(String pointText, String priceText, String? saleText, BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none, // 세일 꼬리표가 박스 밖으로 나갈 수 있게 허용
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pointText,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  print('$pointText 충전');
                },
                child: Text(priceText),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  side: BorderSide(color: Colors.black), // 기본 흑백 스타일
                ),
              ),
            ],
          ),
          if (saleText != null)
            Positioned(
              right: 0, // 더 왼쪽으로 이동
              top: -25, // 더 위로 이동
              child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.red, // 꼬리표 색상
                child: Text(
                  saleText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 테마 구매 타일
  Widget _buildMinimalThemeTile(String themeName, String priceText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            themeName,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          OutlinedButton(
            onPressed: () {
              print('$themeName 구매');
            },
            child: Text(priceText),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: Colors.black), // 기본 흑백 스타일
            ),
          ),
        ],
      ),
    );
  }

  // 아이템 구매 타일
  Widget _buildMinimalItemTile(String itemName, String priceText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          OutlinedButton(
            onPressed: () {
              print('$itemName 구매');
            },
            child: Text(priceText),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: Colors.black), // 기본 흑백 스타일
            ),
          ),
        ],
      ),
    );
  }

  // 구분선
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Divider(
        color: Colors.grey[400],
        thickness: 1,
      ),
    );
  }
}
