import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  // A map of supported languages and their locale codes
  static const _supportedLanguages = {
    'English': 'en-IN',
    'Hindi': 'hi-IN',
    'Tamil': 'ta-IN',
    'Marathi': 'mr-IN',
    'Telugu': 'te-IN',
    'Malayalam': 'ml-IN', // Added Malayalam
  };

  static Future toggleRecording({
    required Function(String text) onResult,
    required Function(bool isListening) onListening,
    String? language, // Language should be passed in
  }) async {
    if (_speech.isListening) {
      await _speech.stop();
      onListening(false);
    } else {
      final available = await _speech.initialize(
        onStatus: (status) => onListening(_speech.isListening),
        onError: (e) => print('Error: $e'),
      );

      if (available) {
        // If language is passed, set the appropriate locale, or default to 'en-US'
        String localeId = language != null
            ? _supportedLanguages[language] ?? 'en-US'
            : (await _speech.systemLocale())?.localeId ?? 'en-US';

        // Listen and convert speech to text
        _speech.listen(
          onResult: (result) => onResult(result.recognizedWords),
          localeId: localeId, // Use locale based on language passed in
        );
      }
    }
  }
}
