import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/animations/create_custom_transition.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/messages/messages.dart';
import '../controller/club_voice_bloc.dart';
import '../controller/club_voice_state.dart';
import '../widgets/components/create_voice_room_sheet.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/club_voice_room_entity.dart';
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
          onRefresh: () async => cubit.refreshRooms(),
          backgroundColor: Colors.white,
          color: AppColors.PRIMARY_COLOR,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height,
                      maxHeight: double.infinity),
                  child: _pagedRooms(cubit),
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
                    onPressed: () => Navigator.of(context).push(
                        createCustomTransitionRoute(
                            BlocProvider.value(
                                value: serviceLocator<ClubVoiceCubit>(),
                                child: const CreateRoomScreen()),
                            TransitionType.bottomToTop)),
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

  PagedListView<int, ClubVoiceRoomEntity?> _pagedRooms(ClubVoiceCubit cubit) {
    return PagedListView<int, ClubVoiceRoomEntity>.separated(
      pagingController: cubit.roomsPagingController,
      builderDelegate: PagedChildBuilderDelegate<ClubVoiceRoomEntity>(
          noItemsFoundIndicatorBuilder: (context) {
            print(cubit.roomsPagingController.itemList?.length);
            return Center(
              child: Label(
                text: LocaleKeys.noRooms.localize,
                style: Styles.headerText(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            );
          },
          itemBuilder: (context, item, index) {
            return AudioRoomCard(
              room: item,
            );
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.only(top: 150),
              child: const CupertinoActivityIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10.h,
        );
      },
    );
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
