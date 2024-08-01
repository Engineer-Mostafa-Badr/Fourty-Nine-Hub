import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_state.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/components/create_voice_room_dialogue.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../widgets/audio_room_card.dart';

class ClubHouseHome extends StatelessWidget {
  const ClubHouseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 3,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: 'Club Voice',
                      style: Styles.headerText(),
                    ),
                    BlocBuilder<ClubVoiceCubit, ClubVoiceState>(
                      builder: (context, state) {
                        var cubit = context.read<ClubVoiceCubit>();
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.sizeOf(context).height,
                              maxHeight: double.infinity),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 0),
                            shrinkWrap: true,
                            itemCount: cubit.rooms.length,
                            itemBuilder: (context, index) {
                              final room = cubit.rooms[index];
                              return AudioRoomCard(
                                room: room,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                heroTag: 'create voice club',
                onPressed: () => showVoiceLiveDialogue(context: context),
                child: SvgPicture.asset(
                  Assets.voiceLive,
                  height: 150,
                ),
              ),
            ),
          ],
        ));
  }
}
