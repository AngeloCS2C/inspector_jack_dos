import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  FeedbackPageState createState() => FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the TextField and update the button state
    _feedbackController.addListener(() {
      setState(() {
        _isButtonEnabled = _feedbackController.text.isNotEmpty;
      });
    });
  }

  // Show a dialog to confirm feedback was sent
  void _showFeedbackSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Sent'),
          content: const Text('Your feedback has been sent. Thank you!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background with Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA8E063),
                  Color(0xFF56AB2F)
                ], // Green gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          Center(
            // Center to vertically center the content
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Doctor logo (doctorlogo.png)
                    Image.asset(
                      'assets/icons/doctorlogo.png',
                      width: screenWidth * 0.8, // Responsive logo width
                    ),

                    SizedBox(height: screenHeight * 0.03), // Responsive spacing

                    // Main Title
                    const Text(
                      'Help us enhance the Jackfruit Health App by sharing your valuable feedback!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02), // Responsive spacing

                    // Feedback TextField (Adjusted padding and maxLines)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller:
                            _feedbackController, // Controller for feedback input
                        maxLines: 1, // Limited to 2 lines of input
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Text here!',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4), // Overall vertical padding
                          // Adding top padding for the placeholder
                          hintStyle: TextStyle(height: 2.0), // Adds top padding
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03), // Responsive spacing

                    // Send Button with dynamic opacity and action
                    ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              _showFeedbackSentDialog();
                              _feedbackController
                                  .clear(); // Clear input after sending
                            }
                          : null, // Disabled when no text is entered
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2, // Responsive padding
                          vertical: 15,
                        ),
                        backgroundColor: _isButtonEnabled
                            ? const Color(0xFF388E3C)
                            : Colors.grey, // Adjust color based on button state
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05), // Responsive spacing

                    // Footer Text
                    const Text(
                      'If you have datasets to contribute or want to get in touch, reach us at\n'
                      'inspectorjackofficial@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03), // Responsive spacing

                    // Footer Year
                    const Text(
                      'inspectorjack 2024.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
