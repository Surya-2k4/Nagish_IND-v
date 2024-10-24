import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:nagish/api/speech_api.dart';
import 'package:nagish/widgets/substring_highlighted.dart';
import 'package:nagish/utils.dart';

class VoiceToTextPage extends StatefulWidget {
  @override
  _VoiceToTextPageState createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage> {
  String text = 'Press the button and start speaking';
  bool isListening = false;
  String selectedLanguage = 'English'; // Default to English

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('', textAlign: TextAlign.end, style: TextStyle(fontSize: 10)),
          actions: [
            IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✓   Copied to Clipboard')),
                );
              },
            ),
            // Dropdown to select language
            DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['English','Hindi', 'Tamil', 'Marathi', 'Telugu', 'Malayalam'].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newLanguage) {
                setState(() {
                  selectedLanguage = newLanguage!;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(30).copyWith(bottom: 150),
          child: SubstringHighlight(
            text: text,
            terms: Command.all,
            textStyle: TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            textStyleHighlight: TextStyle(
              fontSize: 32.0,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          glowColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
            child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
            onPressed: toggleRecording,
          ),
        ),
      );

  Future toggleRecording() {
    // Pass the selected language for transcription
    return SpeechApi.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) {
        setState(() => this.isListening = isListening);
        if (!isListening) {
          Future.delayed(Duration(seconds: 1), () {
            Utils.scanText(text);
          });
        }
      },
      language: selectedLanguage, // Pass selected language here
    );
  }
}
