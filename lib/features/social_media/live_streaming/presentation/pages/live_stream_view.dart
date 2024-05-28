import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';

import '../widgets/liveview/live_card.dart';

class LiveStreamView extends StatelessWidget {
  const LiveStreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildLivePages();
  }

  Widget _buildLivePages() {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 15,
        itemBuilder: (context, index) => const LiveCard());
  }
}
