import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechPage extends StatefulWidget {
  @override
  _TextToSpeechPageState createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  String _text = '';

  @override
  void dispose() {
    flutterTts.stop(); // Stop TTS if playing when app is closed
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.3); // Set higher pitch for female voice
    await flutterTts.speak(text);
  }

  void _sendText() {
    setState(() {
      _text = _textController.text;  // Capture the input text
    });

    // Speak the text after sending it
    _speak(_text);

    // Clear the text field after sending
    _textController.clear();
  }

  @override
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildTextField(),
            SizedBox(height: 20),
            _buildSendButton(),
            SizedBox(height: 30),
            _buildMessageDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Enter your message',
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: _sendText,
      child: Text(
        'Send',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageDisplay() {
    return Text(
      _text.isNotEmpty ? 'You sent: $_text' : 'No message sent yet',
      style: TextStyle(
        fontSize: 18,
        color: Colors.blueGrey[800],
      ),
      textAlign: TextAlign.center,
    );
  }
}