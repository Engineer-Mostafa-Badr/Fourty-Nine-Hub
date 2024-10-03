// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/club_voice_room_entity.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
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
                liveId: room.id,
                roomSubject: room.subject,
                isHost: false,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.GREY_DARK_COLOR
              : const Color(0xfff0f2ff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ReadMoreLabel(
              style: TextStyle(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.QUANTITY_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp),
              text: room.subject,
              textAlign: TextAlign.center,
              trimLines: 2,
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80.h,
                  child: Stack(
                    children: [
                      Positioned(
                          child: ProfileImage(
                        userId: room.users!.isNotEmpty ? room.users![0].id : '',
                        imageURL: room.users!.isNotEmpty
                            ? room.users![0].profilePicture
                            : null,
                        accountId: 0,
                      )),
                      Positioned(
                          top: 20,
                          left: 20,
                          child: ProfileImage(
                            userId:
                                room.users!.length > 1 ? room.users![1].id : '',
                            accountId: 0,
                            imageURL: room.users!.length > 1
                                ? room.users![1].profilePicture
                                : null,
                            withBorder: true,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListView.separated(
                        itemCount: room.users!.isNotEmpty
                            ? (room.users!.length >= 2 ? 2 : 1)
                            : 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final user = room.users![index];

                          return Row(
                            children: [
                              Expanded(
                                child: Label(
                                    color: AppColors.QUANTITY_COLOR,
                                    text: '${user.firstName} ${user.lastName}',
                                    style: Styles.mediumText(fontSize: 22)),
                              ),
                              // Sizer(),
                              Icon(
                                FontAwesomeIcons.comment,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.grey,
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
                          Icon(
                            Icons.person,
                            color:
                                context.isDarkMode ? Colors.white : Colors.grey,
                            size: 14,
                          ),
                          const Sizer(),
                          Label(
                              text: room.users?.length.toString() ?? '0',
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 20))
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
