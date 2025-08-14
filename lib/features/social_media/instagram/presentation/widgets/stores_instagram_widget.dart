import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'my_story_instagram_header_item.dart';
import 'story_instagram_header_item.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';

class StoresInstagramWidget extends StatelessWidget {
  const StoresInstagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: 82,
        child: ListView.builder(
          itemCount: StoryItemEntity.stories.length + 1,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
      ManageVibration.vibrate();
                  // bottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   widget: AddStoryView(),
                  // );
                  context.push(Routes.ADDSTORYINSTAGRAM);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 10.0,
                  ),
                  child: MyStoryInstagramHeaderItem(
                    storyItemEntity: StoryItemEntity(
                      id: 23,
                      userName: 'Yousef Ahmed',
                      imageUrl:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
                      storyCount: 2,
                    ),
                  ),
                ),
              );
            }
            return InkWell(
              onTap: () {

      ManageVibration.vibrate();
              },
              child: StoryInstagramHeaderItem(
                storyItemEntity: StoryItemEntity.stories[index - 1],
              ),
            );
          },
        ),
      ),
    );

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             // const MyStoryInstagramHeaderItem(
//             //   storyCount: 1,
//             // ),
//             const Sizer(),
//             // ...List.generate(
//             //   10,
//             //   (index) {
//             //     return const StoryInstagramHeaderItem(
//             //       imageUrl: '',
//             //       storyCount: 0,
//             //     );
//             //   },
//             // )
//           ],
//         ),
//       ),
//     );
  }
}

class StoryItemEntity {
  final int id;
  final String userName;
  final String imageUrl;
  final int storyCount;
  StoryItemEntity({
    required this.id,
    required this.userName,
    required this.imageUrl,
    required this.storyCount,
  });

  static List<StoryItemEntity> stories = [
    StoryItemEntity(
      id: 1,
      userName: 'Taha',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
      storyCount: 0,
    ),
    StoryItemEntity(
      id: 2,
      userName: 'Ibrahim Ali',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
      storyCount: 1,
    ),
    StoryItemEntity(
      id: 3,
      userName: 'Mohammed',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
      storyCount: 3,
    ),
    StoryItemEntity(
      id: 4,
      userName: 'Mido',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
      storyCount: 7,
    ),
    StoryItemEntity(
      id: 5,
      userName: 'Mohammed Ibrahim',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s',
      storyCount: 14,
    ),
  ];
}