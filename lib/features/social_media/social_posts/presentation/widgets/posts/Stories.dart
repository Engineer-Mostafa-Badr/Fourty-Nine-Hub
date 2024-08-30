import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2.5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          const Sizer(),
          _buildYourStory(),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => _buildOthersStories(context),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 1),
          )
        ],
      ),
    );
  }

  Widget _buildOthersStories(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreStories(),
            )),
        child: Container(
          height: kToolbarHeight * 2.5,
          width: kToolbarHeight * 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                UIConst.imagePlaceHolder,
                fit: BoxFit.cover,
              )),
              Positioned.fill(
                  child: Container(
                color: Colors.black.withOpacity(.2),
              )),
              Positioned.fill(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      radius: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(UIConst.profilePlaceHolder),
                      ),
                    ),
                    FittedBox(
                      child: Label(
                          text: capitalizeAndSplit2Only(
                              'mohamed ayman ayman ayman'),
                          textAlign: TextAlign.end,
                          style: Styles.smallText(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourStory() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: kToolbarHeight * 2,
        width: kToolbarHeight * 1.5,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(child: Image.network(UIConst.profilePlaceHolder)),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(text: 'Create Story', style: Styles.smallText())
                    ],
                  ),
                ))
              ],
            )),
            const Positioned.fill(
                child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

enum StoryType { text, image, video }

class StoryData {
  final StoryType type;
  final String content;
  final String? caption;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  StoryData({
    required this.type,
    required this.content,
    this.caption,
    this.backgroundColor,
    this.textStyle,
  });
}

//------------------------------------------------------------------------------------------------
StoryItem createStoryItem(StoryData storyData, StoryController controller) {
  switch (storyData.type) {
    case StoryType.text:
      return StoryItem.text(
        title: storyData.content,
        backgroundColor: storyData.backgroundColor ?? Colors.black,
        textStyle: storyData.textStyle,
      );
    case StoryType.image:
      return StoryItem.pageImage(
        url: storyData.content,
        caption: storyData.caption != null
            ? Text(
                storyData.caption!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
            : null,
        controller: controller,
      );
    case StoryType.video:
      return StoryItem.pageVideo(
        storyData.content,
        caption: storyData.caption != null
            ? Text(
                storyData.caption!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
            : null,
        controller: controller,
      );
    default:
      return StoryItem.text(
        title: "Unknown story type",
        backgroundColor: Colors.red,
      );
  }
}

final List<StoryData> stories = [
  StoryData(
    type: StoryType.text,
    content: "I guess you'd love to see more of our food. That's great.",
    backgroundColor: Colors.blue,
  ),
  StoryData(
    type: StoryType.text,
    content: "Nice!\n\nTap to continue.",
    backgroundColor: Colors.red,
  ),
  StoryData(
    type: StoryType.image,
    content:
        "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
    caption: "Still sampling",
  ),
  StoryData(
    type: StoryType.image,
    content: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
    caption: "Working with gifs",
  ),
  StoryData(
    type: StoryType.image,
    content: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
    caption: "Hello, from the other side",
  ),
  StoryData(
    type: StoryType.image,
    content: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
    caption: "Hello, from the other side2",
  ),
  StoryData(
    type: StoryType.video,
    content:
        "https://videos.pexels.com/video-files/27961886/12274254_1440_2560_50fps.mp4",
    caption: "Hello, from the other side2",
  ),
];

//------------------------------------------------------------------------------------------------
class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final StoryController storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = stories
        .map((storyData) => createStoryItem(storyData, storyController))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 9,
              ),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: StoryView(
        storyItems: storyItems,
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MoreStories()),
          );
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}

// class StoryHome extends StatelessWidget {
//   final StoryController controller = StoryController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Delicious Ghanaian Meals"),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(
//           8,
//         ),
//         child: ListView(
//           children: <Widget>[
//             Container(
//               height: 300,
//               child: StoryView(
//                 controller: controller,
//                 storyItems: [
//                   StoryItem.text(
//                     title:
//                         "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
//                     backgroundColor: Colors.orange,
//                     roundedTop: true,
//                   ),
//                   // StoryItem.inlineImage(
//                   //   NetworkImage(
//                   //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
//                   //   caption: Text(
//                   //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
//                   //     style: TextStyle(
//                   //       color: Colors.white,
//                   //       backgroundColor: Colors.black54,
//                   //       fontSize: 17,
//                   //     ),
//                   //   ),
//                   // ),
//                   StoryItem.inlineImage(
//                     url:
//                         "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
//                     controller: controller,
//                     caption: const Text(
//                       "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
//                       style: TextStyle(
//                         color: Colors.white,
//                         backgroundColor: Colors.black54,
//                         fontSize: 17,
//                       ),
//                     ),
//                   ),
//                   StoryItem.inlineImage(
//                     url:
//                         "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
//                     controller: controller,
//                     caption: const Text(
//                       "Hektas, sektas and skatad",
//                       style: TextStyle(
//                         color: Colors.white,
//                         backgroundColor: Colors.black54,
//                         fontSize: 17,
//                       ),
//                     ),
//                   )
//                 ],
//                 onStoryShow: (storyItem, index) {
//                   print("Showing a story");
//                 },
//                 onComplete: () {
//                   print("Completed a cycle");
//                 },
//                 progressPosition: ProgressPosition.bottom,
//                 repeat: false,
//                 inline: true,
//               ),
//             ),
//             Material(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => MoreStories()));
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius:
//                           BorderRadius.vertical(bottom: Radius.circular(8))),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                       ),
//                       SizedBox(
//                         width: 16,
//                       ),
//                       Text(
//                         "View more stories",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MoreStories extends StatefulWidget {
//   @override
//   _MoreStoriesState createState() => _MoreStoriesState();
// }
//
// class _MoreStoriesState extends State<MoreStories> {
//   final storyController = StoryController();
//
//   @override
//   void dispose() {
//     storyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//             onPressed: () {
//               if (Navigator.canPop(context)) Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//               shadows: <Shadow>[
//                 Shadow(
//                   color: Colors.black, // Shadow color
//                   offset: Offset(2, 2), // Shadow position (x, y)
//                   blurRadius: 9, // Shadow blur radius
//                 ),
//               ],
//             )),
//       ),
//       extendBodyBehindAppBar: true,
//       body: StoryView(
//         storyItems: [
//           StoryItem.text(
//             title: "I guess you'd love to see more of our food. That's great.",
//             backgroundColor: Colors.blue,
//           ),
//           StoryItem.text(
//             title: "Nice!\n\nTap to continue.",
//             backgroundColor: Colors.red,
//             textStyle: const TextStyle(
//               fontFamily: 'Dancing',
//               fontSize: 40,
//             ),
//           ),
//           StoryItem.pageImage(
//             url:
//                 "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
//             caption: const Text(
//               "Still sampling",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             controller: storyController,
//           ),
//           StoryItem.pageImage(
//               url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
//               caption: const Text(
//                 "Working with gifs",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               controller: storyController),
//           StoryItem.pageImage(
//             url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             caption: const Text(
//               "Hello, from the other side",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             controller: storyController,
//           ),
//           StoryItem.pageImage(
//             url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             caption: const Text(
//               "Hello, from the other side2",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             controller: storyController,
//           ),
//           StoryItem.pageVideo(
//             "https://videos.pexels.com/video-files/27961886/12274254_1440_2560_50fps.mp4",
//             caption: const Text(
//               "Hello, from the other side2",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             controller: storyController,
//           ),
//         ],
//         onStoryShow: (storyItem, index) {
//           print("Showing a story");
//         },
//         onComplete: () {
//           print(
//               "Completed a cycle ==================================================================");
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MoreStories(),
//               ));
//         },
//         progressPosition: ProgressPosition.top,
//         repeat: false,
//         controller: storyController,
//       ),
//     );
//   }
// }

//------------------------------------------------------------------------------------------------
