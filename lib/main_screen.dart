// main_screen.dart

import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'recommendations_page.dart';
import 'recommendation_data.dart';
import 'history_page.dart';
import 'feedback_page.dart';
import 'ml_service.dart'; // Import the MLService

final logger = Logger();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final MLService _mlService = MLService(); // Instantiate MLService
  File? _selectedImage;
  final picker = ImagePicker();
  List<Map<String, dynamic>> _results = [];
  bool _classified = false;
  bool _showRecommendationsButton = false;
  bool _modelsLoaded = false; // Flag to indicate if models are loaded
  bool _isLoadingModels = true; // Flag for loading indicator
  Map<String, dynamic>? _bestResult; // State variable for best result

  // History Data
  final List<Map<String, dynamic>> _history = [];

  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);
  late AnimationController _circleAnimationController;

  @override
  void initState() {
    super.initState();
    _loadModels();

    _circleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _circleAnimationController.forward();
  }

  Future<void> _loadModels() async {
    setState(() {
      _isLoadingModels = true;
    });

    await _mlService.loadModels();

    setState(() {
      _modelsLoaded = _mlService.modelsLoaded;
      _isLoadingModels = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_modelsLoaded) {
      _showLoadingModelsDialog();
      return;
    }

    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
      _results.clear();
      _classified = false;
      _showRecommendationsButton = false;
      _bestResult = null;
    });
  }

  void _deleteImage() {
    setState(() {
      _selectedImage = null;
      _classified = false;
      _showRecommendationsButton = false;
      _bestResult = null;
    });
  }

  Future<void> _classifyImage() async {
    if (!_modelsLoaded) {
      _showLoadingModelsDialog();
      return;
    }

    if (_selectedImage == null) return;

    try {
      bool isJackfruitLeaf = await _mlService.detectLeaf(_selectedImage!);
      logger.d('Is Jackfruit Leaf: $isJackfruitLeaf');

      if (!isJackfruitLeaf) {
        _showNotJackfruitLeafDialog();
        return;
      }

      List<Map<String, dynamic>> results =
          await _mlService.classifyImage(_selectedImage!);

      if (results.isEmpty) {
        // Handle error in classification
        logger.e('Classification results are empty.');
        return;
      }

      final bestResult = results.reduce(
          (curr, next) => curr['accuracy'] > next['accuracy'] ? curr : next);

      setState(() {
        _results = results;
        _classified = true;
        _showRecommendationsButton = true;
        _bestResult = bestResult; // Store best result

        // Store result and date in history
        _history.add({
          'result': bestResult['label'],
          'date': DateTime.now().toString().substring(0, 10),
        });
      });

      if (bestResult['label'] == 'Healthy Leaf of Jackfruit') {
        _showHealthyLeafDialog();
      }
    } catch (e) {
      logger.e('Error during classification: $e');
      _showErrorDialog(
          'An error occurred during classification. Please try again.');
    }
  }

  void _showNotJackfruitLeafDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not a Jackfruit Leaf'),
          content: const Text(
              'The image does not appear to be a jackfruit leaf. Please capture an image of a jackfruit leaf.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showHealthyLeafDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'Your jackfruit leaf looks healthy! Keep up with good plant care practices. Thanks for using Inspector Jack!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingModelsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Loading Models'),
          content: const Text('Please wait while the models are loading...'),
          actions: <Widget>[
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRecommendation() {
    final bestResult = _bestResult;

    final recommendation = recommendations.firstWhere(
      (rec) => rec.name == bestResult?['label'],
      orElse: () => Recommendation(
        name: 'Unknown',
        descriptionEn: 'No recommendations available.',
        symptomsEn: 'No symptoms available.',
        descriptionTl: 'Walang rekomendasyon na magagamit.',
        symptomsTl: 'Walang sintomas na magagamit.',
        descriptionCb: 'Walay rekomendasyon nga magamit.',
        symptomsCb: 'Walay sintomas nga magamit.',
        treatment: Treatment(
          culturalEn: '',
          mechanicalEn: '',
          chemicalEn: '',
          culturalTl: '',
          mechanicalTl: '',
          chemicalTl: '',
          culturalCb: '',
          mechanicalCb: '',
          chemicalCb: '',
        ),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationsPage(
          recommendation: recommendation,
          analyzedImage: _selectedImage,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mlService.dispose();
    _circleAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.jumpToPage(index);
      _circleAnimationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Gradient background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255), // Top color
                  Color.fromARGB(255, 255, 255, 255), // Bottom color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: _isLoadingModels
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          'Loading models, please wait...',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      HistoryPage(history: _history),
                      _buildMainPage(screenWidth, screenHeight),
                      const FeedbackPage(),
                    ],
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: const Color.fromARGB(255, 255, 255, 255), // White nav bar
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 10, // Shadow elevation for lift effect
              kBottomRadius: 28.0,
              notchColor: const Color.fromARGB(
                  255, 36, 39, 36), // Same color as the nav bar
              removeMargins: true, // Removes extra padding
              bottomBarWidth: 500,
              showShadow: true,
              durationInMilliSeconds: 300,
              itemLabelStyle: const TextStyle(fontSize: 10),
              elevation: 10, // Elevation value
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(Icons.history, color: Colors.black),
                  activeItem: Icon(Icons.history,
                      color: Color.fromARGB(255, 230, 169, 0)),
                ),
                BottomBarItem(
                  inActiveItem:
                      Icon(Icons.qr_code_scanner, color: Colors.black),
                  activeItem: Icon(Icons.qr_code_scanner,
                      color: Color.fromARGB(255, 230, 169, 0)),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.feedback, color: Colors.black),
                  activeItem: Icon(Icons.feedback,
                      color: Color.fromARGB(255, 230, 169, 0)),
                ),
              ],
              onTap: _onItemTapped,
              kIconSize: 24.0, // Set to a fixed value for centered icons
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPage(double screenWidth, double screenHeight) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  'assets/icons/logo.png',
                ),
              ),
            ],
          ),
          const SizedBox(height: 0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth * 0.9, // 90% of screen width
                        height: _selectedImage != null
                            ? screenHeight *
                                0.5 // Increase height when image is present
                            : screenHeight *
                                0.35, // Default height when no image
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 246, 246, 246)
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 176, 173, 173)
                                  .withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/bigcam.png'),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Press the buttons below to add a picture',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                      ),
                      if (_selectedImage != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _deleteImage,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10), // Reduced space
                  Container(
                    width: screenWidth * 0.95, // 95% of screen width
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Mother box color set to white
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 235, 14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF388E3C),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Classification Result:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _classified && _bestResult != null
                                  ? Text(
                                      _bestResult!['label'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // Set text color to black
                                      ),
                                    )
                                  : const Text(
                                      'No result yet.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // Reduced space
                        if (_selectedImage == null) ...[
                          ElevatedButton.icon(
                            onPressed: _modelsLoaded
                                ? () => _pickImage(ImageSource.camera)
                                : null,
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white),
                            label: const Text(
                              'Start Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.7, 50), // Adjusted width
                              backgroundColor: Colors
                                  .black, // Buttons background color set to black
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                // Removed border color
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _modelsLoaded
                                ? () => _pickImage(ImageSource.gallery)
                                : null,
                            icon: const Icon(Icons.photo_library,
                                color: Colors.white),
                            label: const Text(
                              'Upload Picture',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.7, 50), // Adjusted width
                              backgroundColor: Colors
                                  .black, // Buttons background color set to black
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                // Removed border color
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 6), // Reduced space
                        ElevatedButton(
                          onPressed: _selectedImage == null
                              ? null
                              : _showRecommendationsButton
                                  ? _showRecommendation
                                  : _classifyImage,
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(screenWidth * 0.8, 50), // Adjusted width
                            backgroundColor: const Color(
                                0xFF388E3C), // Same as previous border color
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 10,
                            shadowColor: const Color.fromARGB(255, 2, 97, 18)
                                .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              // Removed border color
                            ),
                          ),
                          child: Text(
                            _showRecommendationsButton
                                ? 'Check Recommendations'
                                : 'Classify',
                            style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
