import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'loading_screen.dart'; // Import the loading screen
import 'intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspector Jack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/loading', // Set loading screen as the initial route
      routes: {
        '/loading': (context) =>
            const LoadingScreen(), // Define the loading screen route
        '/home': (context) => const IntroScreen(), // Home route after loading
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _pageController =
      PageController(initialPage: 1); // Default to the center (Scan page)
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1); // Default to the center (Scan page)

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const HistoryPage(),
      const ScanPage(),
      const FeedbackPage(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= 3)
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return AnimatedNotchBottomBar(
                  notchBottomBarController: _controller,
                  color: Colors.white,
                  showLabel: true,
                  textOverflow: TextOverflow.visible,
                  maxLine: 1,
                  shadowElevation: 5,
                  kBottomRadius: 28.0,
                  notchColor: Colors.black87,
                  removeMargins: false,
                  bottomBarWidth: 500,
                  showShadow: false,
                  durationInMilliSeconds: 300,
                  itemLabelStyle: const TextStyle(fontSize: 10),
                  elevation: 1,
                  bottomBarItems: const [
                    BottomBarItem(
                      inActiveItem: Icon(Icons.history, color: Colors.blueGrey),
                      activeItem: Icon(Icons.history, color: Colors.blueAccent),
                      itemLabel: 'History',
                    ),
                    BottomBarItem(
                      inActiveItem:
                          Icon(Icons.qr_code_scanner, color: Colors.blueGrey),
                      activeItem:
                          Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
                      itemLabel: 'Scan',
                    ),
                    BottomBarItem(
                      inActiveItem:
                          Icon(Icons.feedback, color: Colors.blueGrey),
                      activeItem:
                          Icon(Icons.feedback, color: Colors.blueAccent),
                      itemLabel: 'Feedback',
                    ),
                  ],
                  onTap: _onItemTapped,
                  kIconSize: 24.0 * _animation.value,
                );
              },
            )
          : null,
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: const Center(child: Text('History Page')),
    );
  }
}

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Center(child: Text('Scan Page')),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(child: Text('Feedback Page')),
    );
  }
}
