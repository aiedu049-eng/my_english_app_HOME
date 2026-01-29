import 'package:flutter/material.dart';
import 'data.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  ChatScreen({required this.title});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int scriptMode = 0; // 0:모두보기, 1:한글만, 2:숨기기
  bool isListening = false;

  void _toggleListening() {
    setState(() => isListening = !isListening);
    if (isListening) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => isListening = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = conversationData[widget.title] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => setState(() => scriptMode = (scriptMode + 1) % 3),
            child: Text(['모두보기', '한글만', '숨기기'][scriptMode], style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: dialogs.length,
              itemBuilder: (context, index) {
                final chat = dialogs[index];
                String displayText = "";
                if (scriptMode == 0) displayText = "${chat['en']}\n${chat['ko']}";
                else if (scriptMode == 1) displayText = chat['ko']!;
                else displayText = "??? (탭하여 확인)";

                return Align(
                  alignment: chat['sender'] == '나' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: chat['sender'] == '나' ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(displayText),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isListening ? Icons.stop : Icons.mic, color: isListening ? Colors.blue : Colors.red),
            onPressed: _toggleListening,
          ),
          Expanded(child: TextField(decoration: InputDecoration(hintText: isListening ? "듣고 있어요..." : "말하거나 입력하세요..."))),
        ],
      ),
    );
  }
}