import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'recommendations_page.dart';
import 'recommendation_data.dart';
import 'history_page.dart';
import 'feedback_page.dart';

final logger = Logger();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Interpreter _interpreter;
  final List<String> _labels = [
    'Algal Leaf Spot of Jackfruit',
    'Black Spot of Jackfruit',
    'Healthy Leaf of Jackfruit',
  ];
  File? _selectedImage;
  final picker = ImagePicker();
  List<Map<String, dynamic>> _results = [];
  bool _classified = false;
  bool _showRecommendationsButton = false;

  // History Data
  final List<Map<String, dynamic>> _history = [];

  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);
  late AnimationController _circleAnimationController;

  @override
  void initState() {
    super.initState();
    _loadModel();

    _circleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _circleAnimationController.forward();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/tmjackfruit.tflite');
      logger.i('Model loaded successfully');
    } catch (e) {
      logger.e('Error loading model: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
      _results.clear();
      _classified = false;
      _showRecommendationsButton = false;
    });
  }

  void _deleteImage() {
    setState(() {
      _selectedImage = null;
      _classified = false;
      _showRecommendationsButton = false;
    });
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null) return;

    try {
      final img.Image image =
          img.decodeImage(await _selectedImage!.readAsBytes())!;
      final img.Image resizedImage =
          img.copyResize(image, width: 224, height: 224);

      final List<List<List<List<double>>>> input = List.generate(
        1,
        (i) => List.generate(
            224, (j) => List.generate(224, (k) => [0.0, 0.0, 0.0])),
      );

      for (int y = 0; y < resizedImage.height; y++) {
        for (int x = 0; x < resizedImage.width; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = img.getRed(pixel) / 255.0;
          input[0][y][x][1] = img.getGreen(pixel) / 255.0;
          input[0][y][x][2] = img.getBlue(pixel) / 255.0;
        }
      }

      final List<List<double>> output =
          List.generate(1, (_) => List.filled(3, 0.0));

      _interpreter.run(input, output);

      List<Map<String, dynamic>> results = [];
      for (int i = 0; i < output[0].length; i++) {
        results.add({
          'label': _labels[i],
          'accuracy': output[0][i],
        });
      }

      setState(() {
        _results = results;
        _classified = true;
        _showRecommendationsButton = true;

        // Store result and date in history
        final bestResult = _results.reduce(
            (curr, next) => curr['accuracy'] > next['accuracy'] ? curr : next);
        _history.add({
          'result': bestResult['label'],
          'date': DateTime.now().toString().substring(0, 10),
        });
      });

      final bestResult = _results.reduce(
          (curr, next) => curr['accuracy'] > next['accuracy'] ? curr : next);
      if (bestResult['label'] == 'Healthy Leaf of Jackfruit') {
        _showHealthyLeafDialog();
      }
    } catch (e) {
      logger.e('Error classifying image: $e');
    }
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
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRecommendation() {
    final bestResult = _results.reduce(
        (curr, next) => curr['accuracy'] > next['accuracy'] ? curr : next);

    final recommendation = recommendations.firstWhere(
      (rec) => rec.name == bestResult['label'],
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
    _interpreter.close();
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Gradient background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA8E063), // Top color
                  Color(0xFF56AB2F), // Bottom color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HistoryPage(history: _history),
                _buildMainPage(),
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
              color: Colors.white, // White nav bar
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 10, // Shadow elevation for lift effect
              kBottomRadius: 28.0,
              notchColor: Colors.white, // Same color as the nav bar
              removeMargins: true, // Removes extra padding
              bottomBarWidth: 500,
              showShadow: true,
              durationInMilliSeconds: 300,
              itemLabelStyle: const TextStyle(fontSize: 10),
              elevation: 10, // Elevation value
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(Icons.history, color: Colors.blueGrey),
                  activeItem: Icon(Icons.history,
                      color: Color.fromARGB(255, 230, 169, 0)),
                ),
                BottomBarItem(
                  inActiveItem:
                      Icon(Icons.qr_code_scanner, color: Colors.blueGrey),
                  activeItem: Icon(Icons.qr_code_scanner,
                      color: Color.fromARGB(255, 230, 169, 0)),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.feedback, color: Colors.blueGrey),
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

  Widget _buildMainPage() {
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
                        width: 350,
                        height: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9).withOpacity(0.3),
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
                                      fontSize: 14,
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
                  const SizedBox(height: 15),
                  Container(
                    width: 380,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 215, 224, 210),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                            color: const Color(0xFFF2F2F2),
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
                              _classified
                                  ? Column(
                                      children: [
                                        for (var result in _results)
                                          Text(
                                            '${result['label']} - ${(result['accuracy'] * 100).toStringAsFixed(2)}%',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
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
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: Image.asset('assets/minicamera.png', width: 30),
                          label: const Text('Start Camera'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 215, 224, 210),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFF388E3C),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: Image.asset('assets/miniupload.png'),
                          label: const Text('Upload Picture'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 215, 224, 210),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFF388E3C),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _selectedImage == null
                              ? null
                              : _showRecommendationsButton
                                  ? _showRecommendation
                                  : _classifyImage,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(240, 55),
                            backgroundColor: const Color(0xFF388E3C),
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 10,
                            shadowColor: Colors.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
