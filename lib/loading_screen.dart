import 'package:flutter/material.dart';
import 'dart:async'; // For the delay functionality

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key}); // Added key
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 5 seconds before navigating to the next screen
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        // Check if the widget is still mounted
        // Navigate to MyHomePage
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo (Replace with your actual asset path)
            Image.asset(
              'assets/icons/doctorlogo.png',
              // Ensure your logo image is in the assets folder
              // Adjust height as necessary
            ),

            SizedBox(
                height:
                    20.0), // Adds some spacing between the logo and loading bar

            // Loading bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),

            SizedBox(height: 20.0),

            // Loading text
            Text(
              'loading please wait....',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
