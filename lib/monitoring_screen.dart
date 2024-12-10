import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import MainScreen for navigation on Skip
import 'ready.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Top color
              Color.fromARGB(255, 253, 253, 253), // Bottom color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Box behind the picture
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 480,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.36),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 160,
                left: 15,
                right: 0,
                child: Transform.rotate(
                  angle: 0, // No rotation for the monitoring image
                  child: SizedBox(
                    child: Image.asset(
                      'assets/icons/doctor.png', // Replace with your asset
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 560),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Monitor and Manage Effortlessly',
                          style: TextStyle(
                            fontSize: 37,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF252A70),
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(66, 9, 9, 9),
                                offset: Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Track your tree\'s health and receive expert advice\non managing diseases.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(179, 3, 3, 3),
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Buttons: "Skip" and "Next"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to MainScreen when "Skip" is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(130, 50),
                          backgroundColor: const Color(0xFF69966B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(39.0),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to Next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ReadyToBeginScreen(), // Update this as needed
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(130, 50),
                          backgroundColor: const Color(0xFF388E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(39.0),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Pagination indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildDot(isActive: false),
                      const SizedBox(width: 8),
                      _buildDot(isActive: true),
                      const SizedBox(width: 8),
                      _buildDot(isActive: false),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the dots for pagination indicator
  Widget _buildDot({required bool isActive}) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}
