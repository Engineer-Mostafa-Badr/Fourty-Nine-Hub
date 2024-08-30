// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../pages/audio_stream_screen.dart';

class AudioRoomCard extends StatelessWidget {
  final ClubVoiceRoomEntity room;
  const AudioRoomCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ClubVoiceCubit>().joinRoom(room.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: serviceLocator<ClubVoiceCubit>(),
              child: AudioStreamScreen(
                  liveId: room.id, roomSubject: room.subject, isHost: false),
            ),
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(right: 100, top: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xfff0f2ff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ReadMoreLabel(
              style: const TextStyle(color: AppColors.QUANTITY_COLOR),
              text: room.subject,
              trimLines: 2,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      Positioned(
                          child: ProfileImage(
                        accountId: 0,
                      )),
                      Positioned(
                          top: 20,
                          left: 20,
                          child: ProfileImage(
                            accountId: 0,
                            withBorder: true,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListView.separated(
                        itemCount: room.users.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final user = room.users[index];
                          return Row(
                            children: [
                              Label(
                                  color: AppColors.QUANTITY_COLOR,
                                  text: room.hostname,
                                  style: Styles.mediumText()),
                              const Sizer(),
                              const Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Sizer();
                        },
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 14,
                              ),
                              const Sizer(),
                              Label(
                                  text: '144',
                                  style: Styles.mediumText(color: Colors.grey))
                            ],
                          ),
                          const Sizer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
