import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../widgets/liveview/live_card.dart';

class LiveStreamHomeScreen extends StatelessWidget {
  const LiveStreamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLivePages(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.LIVEView,
              extra: ZegoArgs(
                '123',
                true,
              ));
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLivePages() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 3,
      itemBuilder: (context, index) => const LiveCard(),
    );
  }
}
