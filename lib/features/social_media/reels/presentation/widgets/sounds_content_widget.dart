import 'package:flutter/material.dart';

import 'sound_widget.dart';

class SoundsContentWidget extends StatelessWidget {
  const SoundsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(height: 8),
                const SoundWidget(),
              ],
            ),
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}
