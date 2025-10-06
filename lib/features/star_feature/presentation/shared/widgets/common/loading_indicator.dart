import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class StarLoadingIndicator extends StatelessWidget {
  final String? message;
  final double? progress;

  const StarLoadingIndicator({
    super.key,
    this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (progress != null)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              )
            else
              const CustomCircularProgressIndicator(),
            if (message != null) ...[
              SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (progress != null) ...[
              SizedBox(height: 8),
              Text(
                '${(progress! * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
