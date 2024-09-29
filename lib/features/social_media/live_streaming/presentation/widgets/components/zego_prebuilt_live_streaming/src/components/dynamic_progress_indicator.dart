import 'package:flutter/material.dart';

class DynamicProgressIndicator extends StatelessWidget {
  final String
      responseValue; // e.g., "2/5" from the backend (could be any values)

  const DynamicProgressIndicator({super.key, required this.responseValue});

  @override
  Widget build(BuildContext context) {
    // Split the responseValue "2/5" to get current and max values
    List<String> parts = responseValue.split('/');
    int currentValue = int.parse(parts[0]); // Current progress value
    int maxValue = int.parse(parts[1]); // Maximum value

    // Calculate the progress value (between 0.0 and 1.0)
    double progress = currentValue / maxValue;

    return LinearProgressIndicator(
      value: progress, // The dynamic progress value
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(
        getColorBasedOnValue(
            currentValue, maxValue), // Change color dynamically
      ),
    );
  }

  // Function to get the color based on the current and max values
  Color getColorBasedOnValue(int currentValue, int maxValue) {
    // Calculate a percentage to scale color logic (current / max)
    double percentage = currentValue / maxValue;

    if (percentage == 0) {
      return Colors.red; // No progress
    } else if (percentage <= 0.2) {
      return Colors.orange;
    } else if (percentage <= 0.4) {
      return Colors.yellow;
    } else if (percentage <= 0.6) {
      return Colors.green;
    } else if (percentage <= 0.8) {
      return Colors.lightBlue;
    } else {
      return Colors.blue; // Full or high progress
    }
  }
}
