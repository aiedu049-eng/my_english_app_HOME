import 'package:flutter/material.dart';
import 'chat_screen.dart'; // 곧 만들 파일입니다.

void main() => runApp(EnglishApp());

class EnglishApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {'title': '공항에서 기념품 사기', 'icon': 'airplanemode_active'},
    {'title': '호텔 체크인하기', 'icon': 'hotel'},
    {'title': '식당에서 주문하기', 'icon': 'restaurant'},
    {'title': '길 묻고 답하기', 'icon': 'map'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상황별 영어 회화'), centerTitle: true),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: Colors.blue),
              title: Text(topics[index]['title']!),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(title: topics[index]['title']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}