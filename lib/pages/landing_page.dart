import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController callIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners(); // Make sure to remove listeners when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Join a Call',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: callIdController,
                hintText: 'Please enter Call ID',
                icon: Icons.videocam,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: userIdController,
                hintText: 'Please enter User ID',
                icon: Icons.person,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: userNameController,
                hintText: 'Please enter Username',
                icon: Icons.account_circle,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  if (callIdController.text.length < 3) {
                    // Ensure Call ID is valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Call ID must be at least 3 characters long'),
                      ),
                    );
                  } else if (callIdController.text.isNotEmpty &&
                      userIdController.text.isNotEmpty &&
                      userNameController.text.isNotEmpty) {
                    _joinMeeting(
                      callID: callIdController.text,
                      userID: userIdController.text,
                      username: userNameController.text,
                    );
                  }
                },
                child: Text(
                  'Join the Call',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
        style: TextStyle(fontSize: 16),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  // Function to join a meeting using Jitsi Meet
  void _joinMeeting({
    required String callID,
    required String userID,
    required String username,
  }) async {
    try {
      var options = JitsiMeetingOptions(room: callID)
        ..subject = "Audio Call"
        ..userDisplayName = username
        ..userEmail = "$userID@example.com"
        ..audioOnly = true // Enables audio-only mode
        ..audioMuted = false
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options); // Join the meeting

      // Add listeners for the Jitsi Meet instance after joining the meeting
      JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError,
      ));
    } catch (error) {
      print("Error: $error");
    }
  }

  void _onConferenceWillJoin(message) {
    print("Conference will join with message: $message");
  }

  void _onConferenceJoined(message) {
    print("Conference joined with message: $message");
  }

  void _onConferenceTerminated(message) {
    print("Conference terminated with message: $message");
  }

  void _onError(error) {
    print("Error: $error");
  }
}
