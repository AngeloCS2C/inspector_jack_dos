import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

final logger = Logger();

class MLService {
  Interpreter? _interpreter;
  Interpreter? _leafDetectorInterpreter;
  List<String> _labels = [];
  List<String> _leafDetectorLabels = [];
  bool _modelsLoaded = false;

  bool get modelsLoaded => _modelsLoaded;

  Future<void> loadModels() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/tmjackfruit.tflite');
      logger.i('Main model loaded successfully');
    } catch (e) {
      logger.e('Error loading main model: $e');
    }

    try {
      _leafDetectorInterpreter = await Interpreter.fromAsset(
          'assets/objectDetector/jackfruitleaf.tflite');
      logger.i('Leaf detector model loaded successfully');
    } catch (e) {
      logger.e('Error loading leaf detector model: $e');
    }

    try {
      // Load classification labels
      String labelsData =
          await rootBundle.loadString('assets/labels.txt'); // Adjust the path
      _labels = labelsData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
      logger.i('Classification labels loaded successfully: $_labels');
    } catch (e) {
      logger.e('Error loading classification labels: $e');
    }

    try {
      // Load leaf detector labels
      String labelsData =
          await rootBundle.loadString('assets/objectDetector/labels.txt');
      _leafDetectorLabels = labelsData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
      logger
          .i('Leaf detector labels loaded successfully: $_leafDetectorLabels');
    } catch (e) {
      logger.e('Error loading leaf detector labels: $e');
    }

    _modelsLoaded = true;
  }

  List<List<List<List<double>>>> _reshape(
      List<double> input, int batch, int height, int width, int channels) {
    return List.generate(batch, (b) {
      return List.generate(height, (h) {
        return List.generate(width, (w) {
          return List.generate(channels, (c) {
            return input[(b * height * width * channels) +
                (h * width * channels) +
                (w * channels) +
                c];
          });
        });
      });
    });
  }

  Future<bool> detectLeaf(File imageFile) async {
    try {
      logger.i('Starting leaf detection...');
      final img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
      final img.Image resizedImage =
          img.copyResize(image, width: 224, height: 224);

      // Prepare the input tensor
      var input = List<double>.filled(1 * 224 * 224 * 3, 0.0);
      int pixelIndex = 0;

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = img.getRed(pixel) / 255.0;
          input[pixelIndex++] = img.getGreen(pixel) / 255.0;
          input[pixelIndex++] = img.getBlue(pixel) / 255.0;
        }
      }

      // Reshape the input
      var reshapedInput = _reshape(input, 1, 224, 224, 3);

      // Log input tensor shape
      logger.i(
          'Leaf detector input shape: ${reshapedInput.length} x ${reshapedInput[0].length} x ${reshapedInput[0][0].length} x ${reshapedInput[0][0][0].length}');

      // Output buffer
      var output =
          List.generate(1, (_) => List.filled(_leafDetectorLabels.length, 0.0));

      // Run inference
      _leafDetectorInterpreter!.run(reshapedInput, output);

      // Log output buffer
      logger.i('Leaf detector output: $output');

      // Find the label with the highest probability
      var probabilities = output[0];
      int maxIndex = 0;
      double maxProb = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      String detectedLabel = _leafDetectorLabels[maxIndex];

      logger.i('Leaf detector result: $detectedLabel with confidence $maxProb');

      return detectedLabel == 'jackfruit_leaf';
    } catch (e, stacktrace) {
      logger.e('Error detecting leaf: $e\n$stacktrace');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> classifyImage(File imageFile) async {
    try {
      logger.i('Starting image classification...');
      final img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
      final img.Image resizedImage =
          img.copyResize(image, width: 224, height: 224);

      // Prepare the input tensor
      var input = List<double>.filled(1 * 224 * 224 * 3, 0.0);
      int pixelIndex = 0;

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = img.getRed(pixel) / 255.0;
          input[pixelIndex++] = img.getGreen(pixel) / 255.0;
          input[pixelIndex++] = img.getBlue(pixel) / 255.0;
        }
      }

      // Reshape the input
      var reshapedInput = _reshape(input, 1, 224, 224, 3);

      // Log input tensor shape
      logger.i(
          'Classifier input shape: ${reshapedInput.length} x ${reshapedInput[0].length} x ${reshapedInput[0][0].length} x ${reshapedInput[0][0][0].length}');

      // Output buffer
      var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

      // Run inference
      _interpreter!.run(reshapedInput, output);

      // Log output buffer
      logger.i('Classifier output: $output');

      // Process output
      var probabilities = output[0];

      // Log probabilities
      logger.i('Classifier probabilities: $probabilities');

      List<Map<String, dynamic>> results = [];
      for (int i = 0; i < probabilities.length; i++) {
        results.add({
          'label': _labels[i],
          'accuracy': probabilities[i],
        });
      }

      // Log classification results
      logger.i('Classification results: $results');

      return results;
    } catch (e, stacktrace) {
      logger.e('Error classifying image: $e\n$stacktrace');
      return [];
    }
  }

  void dispose() {
    _interpreter?.close();
    _leafDetectorInterpreter?.close();
  }
}
