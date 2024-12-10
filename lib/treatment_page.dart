import 'package:flutter/material.dart';
import 'recommendation_data.dart';
import 'main_screen.dart'; // Import MainScreen for navigation

class TreatmentPage extends StatefulWidget {
  final Recommendation recommendation;

  const TreatmentPage({super.key, required this.recommendation});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  String currentLanguage = 'en';

  void _switchLanguage() {
    setState(() {
      if (currentLanguage == 'en') {
        currentLanguage = 'tl';
      } else if (currentLanguage == 'tl') {
        currentLanguage = 'cb';
      } else {
        currentLanguage = 'en';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String culturalPractices;
    String mechanicalRemoval;
    String chemicalTreatments;

    if (currentLanguage == 'en') {
      culturalPractices = widget.recommendation.treatment.culturalEn;
      mechanicalRemoval = widget.recommendation.treatment.mechanicalEn;
      chemicalTreatments = widget.recommendation.treatment.chemicalEn;
    } else if (currentLanguage == 'tl') {
      culturalPractices = widget.recommendation.treatment.culturalTl;
      mechanicalRemoval = widget.recommendation.treatment.mechanicalTl;
      chemicalTreatments = widget.recommendation.treatment.chemicalTl;
    } else {
      culturalPractices = widget.recommendation.treatment.culturalCb;
      mechanicalRemoval = widget.recommendation.treatment.mechanicalCb;
      chemicalTreatments = widget.recommendation.treatment.chemicalCb;
    }

    final bool isHealthyLeaf =
        widget.recommendation.name == 'Healthy Leaf of Jackfruit';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment and Remedies'),
        backgroundColor: Colors.yellow, // App bar color changed to yellow
        elevation: 4, // Adds a subtle shadow to the app bar
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: Container(
        color: Colors.white, // White background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildMotherBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBox(
                  child: const Text(
                    'How to Control and Prevent?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  child: Column(
                    children: [
                      const Icon(Icons.play_circle_fill, size: 50),
                      const SizedBox(height: 10),
                      const Text('No video available for now, stay tuned!',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: isHealthyLeaf
                          ? _buildHealthyMessage()
                          : Column(
                              children: [
                                _buildStepBox(
                                  title: 'Cultural Practices',
                                  content: culturalPractices,
                                ),
                                const SizedBox(height: 16),
                                _buildStepBox(
                                  title: 'Mechanical Removal',
                                  content: mechanicalRemoval,
                                ),
                                const SizedBox(height: 16),
                                _buildStepBox(
                                  title: 'Chemical Treatments',
                                  content: chemicalTreatments,
                                ),
                                const SizedBox(
                                    height: 16), // Space before the button
                                // Adjusted Open Source Link button
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Placeholder for open source link function
                                    },
                                    icon: const Icon(Icons.link, size: 18),
                                    label: const Text(
                                      'Open Source Link',
                                      style: TextStyle(
                                        fontSize: 12, // Adjust font size
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Switch Language Button with customized font size
                    SizedBox(
                      width: 140, // Fixed width for consistency
                      child: ElevatedButton.icon(
                        onPressed: _switchLanguage,
                        icon: const Icon(Icons.language),
                        label: Text(
                          'Switch: ${currentLanguage == 'en' ? 'Tagalog' : currentLanguage == 'tl' ? 'Cebuano' : 'English'}',
                          style: const TextStyle(
                            fontSize: 12, // Adjust font size
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Space between buttons
                    // Return to Home Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate back to MainScreen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.home,
                            size: 18, color: Colors.black),
                        label: const Text(
                          'Return to Home',
                          style: TextStyle(
                            fontSize: 12, // Adjust font size
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .yellow, // Button background color set to yellow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMotherBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black, // Mother box color changed to black
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Boxes color changed back to white
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStepBox({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Boxes color changed back to white
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthyMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed back to white for consistency
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        'Your leaf is healthy. No treatments are needed at this time. Continue monitoring to keep it in good health.',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
