import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';

import '../../../domain/entity/live_entity.dart';

class LiveCard extends StatefulWidget {
  final LiveEntity live;
  const LiveCard({super.key, required this.live});

  @override
  State<LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
  @override
  Widget build(BuildContext context) {
  return LiveStreamView(liveID: widget.live.id, isHost: false);

  }

}
