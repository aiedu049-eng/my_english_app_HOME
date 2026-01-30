import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'data.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  ChatScreen({required this.title});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int scriptMode = 0;
  bool isListening = false;
  SpeechToText _speechToText = SpeechToText();
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
        });
      },
    );
    setState(() => isListening = true);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => isListening = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("인식된 문장: $_wordsSpoken")));
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
            child: Text(
              ['모두보기', '한글만', '숨기기'][scriptMode],
              style: TextStyle(color: Colors.black),
            ),
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
                if (scriptMode == 0)
                  displayText = "${chat['en']}\n${chat['ko']}";
                else if (scriptMode == 1)
                  displayText = chat['ko']!;
                else
                  displayText = "??? (탭하여 확인)";

                return Align(
                  alignment: chat['sender'] == '나'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: chat['sender'] == '나'
                          ? Colors.blue[100]
                          : Colors.grey[200],
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isListening ? Icons.stop : Icons.mic,
              color: isListening ? Colors.blue : Colors.red,
            ),
            onPressed: isListening ? _stopListening : _startListening,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: isListening ? "듣고 있어요..." : "말하거나 입력하세요...",
              ),
              enabled: !isListening,
            ),
          ),
        ],
      ),
    );
  }
} // 이 마지막 중괄호가 꼭 있어야 합니다!
