import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../zoom/presentation/widgets/join_meeting_screen.dart';
import '../../../domain/entity/live_entity.dart';
import 'recharge_coins.dart';

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
