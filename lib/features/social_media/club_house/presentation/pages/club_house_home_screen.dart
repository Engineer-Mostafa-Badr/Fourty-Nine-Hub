import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_state.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/components/create_voice_room_dialogue.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../widgets/audio_room_card.dart';

class ClubHouseHome extends StatelessWidget {
  const ClubHouseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ClubVoiceCubit, ClubVoiceState>(
      listener: (context, state) {
        if (state.isFailure) {
          showErrorMessage(context, 'Please try again');
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        var cubit = context.read<ClubVoiceCubit>();
        return RefreshIndicator(
          onRefresh: () async => await cubit.getAllRooms(),
          backgroundColor: Colors.white,
          color: AppColors.PRIMARY_COLOR,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label(
                      //   text: 'Club Voice',
                      //   style: Styles.headerText(),
                      // ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).height,
                            maxHeight: double.infinity),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 0),
                          shrinkWrap: true,
                          itemCount: cubit.rooms.length,
                          itemBuilder: (context, index) {
                            print('room length $cubit.rooms.length');
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
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                    heroTag: 'create voice club',
                    backgroundColor: AppColors.SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => showVoiceLiveBottomSheet(
                        context: context, cubit: cubit),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        );
      },
    ));
  }
}

// Map<String, dynamic> dummyData = {
//   "status": true,
//   "data": {
//     "docs": [
//       {
//         "_id": "66a93c9ad1291e239e415866",
//         "userId": "66a4118c8a30f11ecd8f9edd",
//         "members": [],
//         "subject": "sssssss",
//         "createdAt": "2024-07-30T19:18:50.285Z",
//         "updatedAt": "2024-07-30T19:29:11.711Z"
//       },
//       {
//         "_id": "66aa4f3f8e9ee7a824f4585c",
//         "userId": "66a4118c8a30f11ecd8f9edd",
//         "members": ["66a4118c8a30f11ecd8f9edd"],
//         "subject": "Testing Postman",
//         "createdAt": "2024-07-31T14:50:39.648Z",
//         "updatedAt": "2024-08-01T10:48:16.043Z"
//       },
//       {
//         "_id": "66ab67cd4150c7ff841339b4",
//         "userId": "66a4118c8a30f11ecd8f9edd",
//         "members": [],
//         "subject": "Testing Postman",
//         "createdAt": "2024-08-01T10:47:41.210Z",
//         "updatedAt": "2024-08-01T10:47:41.210Z"
//       },
//       {
//         "_id": "66ab8eb8f917cea64d77b54b",
//         "userId": "66a4118c8a30f11ecd8f9edd",
//         "members": [],
//         "subject": "Journey to the center of the Earth",
//         "createdAt": "2024-08-01T13:33:44.205Z",
//         "updatedAt": "2024-08-01T13:33:44.205Z"
//       },
//       {
//         "_id": "66abbab786d93ea294a831cc",
//         "userId": "66a4118c8a30f11ecd8f9edd",
//         "members": [],
//         "subject": "Data Integrity",
//         "createdAt": "2024-08-01T16:41:27.558Z",
//         "updatedAt": "2024-08-01T16:41:27.558Z"
//       }
//     ],
//     "totalDocs": 5,
//     "limit": 10,
//     "totalPages": 1,
//     "page": 1,
//     "pagingCounter": 1,
//     "hasPrevPage": false,
//     "hasNextPage": false,
//     "prevPage": null,
//     "nextPage": null
//   }
// };
