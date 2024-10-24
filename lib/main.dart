import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nagish/pages/landing_page.dart';
import 'package:nagish/pages/voiceToTextPage.dart';
import 'package:nagish/pages/TextToSpeechPage.dart';
import 'package:nagish/pages/ai_section_page.dart'; // Import the new AI section page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nagish',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    LandingPage(),
    VoiceToTextPage(),
    TextToSpeechPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAISection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AISectionPage()), // Navigate to the AI Section Page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indian -v (Nagish)'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: CircleAvatar(
            
              child: Icon(FontAwesomeIcons.robot, color: Colors.black), // AI icon
            ),
            onPressed: _navigateToAISection, // Navigate to AI section
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Caller',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Voice to Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text to Voice',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
