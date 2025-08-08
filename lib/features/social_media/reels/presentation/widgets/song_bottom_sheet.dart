import 'package:flutter/material.dart';
import 'original_sound_widget.dart';
import 'sound_title_widget.dart';

class SongBottomSheet extends StatelessWidget {
  const SongBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoundTitleWidget(),
          const Divider(),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => const OriginalSoundWidget(),
            itemCount: 10,
          ),
        ],
      ),
    );
  }
}
