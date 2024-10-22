import 'package:flutter/material.dart';
import 'recommendations_page.dart';
import 'recommendation_data.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> history;

  const HistoryPage({super.key, required this.history});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  // Method to delete history entries
  void _clearHistory() {
    setState(() {
      widget.history.clear();
    });
  }

  // When a history item is tapped, navigate to the recommendations page
  void _onHistoryItemTapped(int index) {
    final historyItem = widget.history[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationsPage(
          recommendation: recommendations.firstWhere(
            (rec) => rec.name == historyItem['result'],
          ),
          analyzedImage: historyItem['image'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Logic for Clear History button opacity
    double clearHistoryOpacity = widget.history.isEmpty ? 0.5 : 1.0;

    // Get screen size for responsiveness
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background color with transparency option
          Container(
            color: Colors.white
                .withOpacity(0), // White background with opacity option
          ),

          // SafeArea to ensure content doesn't go under status bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo without SafeArea, removing extra padding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/logo.png',
                      ), // Logo
                    ],
                  ),
                  const SizedBox(
                      height: 20), // Space between logo and mother box

                  // Mother box holding the history list and the Clear History button
                  Container(
                    height: screenHeight * 0.6, // Adjusted for responsiveness
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 56, 142, 60),
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
                    child: Stack(
                      children: [
                        // History list content
                        Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Result',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // List of history results
                            Expanded(
                              child: widget.history.isEmpty
                                  ? const Center(
                                      child: Text('No history available'))
                                  : ListView.builder(
                                      itemCount: widget.history.length,
                                      itemBuilder: (context, index) {
                                        final historyItem =
                                            widget.history[index];
                                        return GestureDetector(
                                          onTap: () =>
                                              _onHistoryItemTapped(index),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 12,
                                                  horizontal:
                                                      20), // Added left & right padding
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(historyItem['result']),
                                                  Text(historyItem['date']),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),

                        // Clear History Button placed at the bottom right with opacity
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Opacity(
                            opacity:
                                clearHistoryOpacity, // Opacity based on history status
                            child: ElevatedButton(
                              onPressed: widget.history.isEmpty
                                  ? null // Disable button when there's no history
                                  : _clearHistory,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: const Text(
                                'Clear History',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
