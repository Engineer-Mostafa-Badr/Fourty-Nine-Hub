import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import 'font_manager.dart';
class FeedbackWidget extends StatelessWidget {
  const FeedbackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           Text(
            LocaleKeys.howIsYourTripGoing.localize,
            style:const TextStyle(fontSize:  FontSize.s14, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeedbackButton(
                label: LocaleKeys.good.localize,
                color: Colors.green,
                onTap: () {
                },
              ),
              _buildFeedbackButton(
                label: LocaleKeys.reportDriver.localize,
                color: Colors.red,
                onTap: () {

                },
              ),
            ],
          ),
          const SizedBox(height: 8),
           Text(
            LocaleKeys.weWillNotTellTheDriverYourComments.localize,
            style: const TextStyle(fontSize:  FontSize.s12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
      ),
      onPressed: onTap,
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}
