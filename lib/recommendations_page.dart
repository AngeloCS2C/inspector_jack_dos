import 'package:flutter/material.dart';
import 'recommendation_data.dart';
import 'dart:io';
import 'treatment_page.dart';

class RecommendationsPage extends StatefulWidget {
  final Recommendation recommendation;
  final File? analyzedImage;

  const RecommendationsPage({
    super.key,
    required this.recommendation,
    required this.analyzedImage,
  });

  @override
  RecommendationsPageState createState() => RecommendationsPageState();
}

class RecommendationsPageState extends State<RecommendationsPage> {
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
    String description;
    String symptoms;

    if (currentLanguage == 'en') {
      description = widget.recommendation.descriptionEn;
      symptoms = widget.recommendation.symptomsEn;
    } else if (currentLanguage == 'tl') {
      description = widget.recommendation.descriptionTl;
      symptoms = widget.recommendation.symptomsTl;
    } else {
      description = widget.recommendation.descriptionCb;
      symptoms = widget.recommendation.symptomsCb;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: const Color.fromARGB(
            255, 56, 142, 60), // Header color changed to green
        elevation: 4, // Drop shadow
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildMotherBox(
                child: Column(
                  children: [
                    // Image Display Box
                    if (widget.analyzedImage != null)
                      _buildBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            widget.analyzedImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Result Box
                    _buildResultBox(
                      child: Center(
                        child: Text(
                          widget.recommendation.name, // Removed 'Result:'
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Scrollable Description and Symptoms
                    Expanded(
                      child: _buildBox(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildContentBox(
                                  title: 'Description',
                                  content: description,
                                ),
                                const SizedBox(height: 16),
                                _buildContentBox(
                                  title: 'Symptoms',
                                  content: symptoms,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Buttons at the bottom inside the Mother Box
                    Row(
                      children: [
                        SizedBox(
                          width: 140, // Fixed width for Switch button
                          child: ElevatedButton.icon(
                            onPressed: _switchLanguage,
                            icon: const Icon(Icons.language),
                            label: Text(
                              'Switch: ${currentLanguage == 'en' ? 'Tagalog' : currentLanguage == 'tl' ? 'Cebuano' : 'English'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (widget.recommendation.name !=
                                  'Healthy Leaf of Jackfruit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TreatmentPage(
                                      recommendation: widget.recommendation,
                                    ),
                                  ),
                                );
                              } else {
                                _showHealthyMessage(context);
                              }
                            },
                            icon: const Icon(Icons.medical_services,
                                size: 18, color: Colors.white),
                            label: const Text(
                              'Check Treatment',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white, // Text color set to white
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 56, 142, 60), // Green color
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
          ],
        ),
      ),
    );
  }

  // Mother Box that holds all content
  Widget _buildMotherBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // Mother box color changed to black
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3), // Subtle drop shadow
          ),
        ],
      ),
      child: child,
    );
  }

  // Result Box for displaying the result text
  Widget _buildResultBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow, // Result box color changed to yellow
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // Box that holds individual content sections
  Widget _buildBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Keep as white
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

  // Content Box for displaying text
  Widget _buildContentBox({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 45, 44, 44),
          ),
        ),
      ],
    );
  }

  // Healthy message pop-up
  void _showHealthyMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Healthy Leaf'),
          content: const Text(
              'Your leaf is healthy. No treatments are needed at this time. Continue monitoring to keep it in good health.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
