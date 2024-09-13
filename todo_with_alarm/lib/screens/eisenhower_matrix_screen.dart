import 'package:flutter/material.dart';

class EisenhowerMatrixScreen extends StatelessWidget {
  const EisenhowerMatrixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 아이젠하워 매트릭스 시각화 화면 구현
    return Scaffold(
      appBar: AppBar(
        title: Text('아이젠하워 매트릭스'),
      ),
      body: Center(
        child: Text('아이젠하워 매트릭스 화면입니다.'),
      ),
    );
  }
}