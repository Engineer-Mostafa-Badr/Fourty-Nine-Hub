import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/const.dart';
import '../../data/models/reel_model.dart';
import '../widgets/reel_card.dart';

class ReelView extends StatelessWidget {
  ReelView({super.key});
  final reelsData = [
    ReelModel(
      id: 1,
      userName: 'Mohamed Gamal',
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isVideo: true,
      title: 'bees',
      description: UIConst.placeholderText,
      numberOfLikes: 120,
      numberOfComments: 20,
      numberOfExplores: 15,
      numberOfSaves: 5,
    ),
    ReelModel(
      id: 1,
      userName: 'Farouk Shahin',
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isVideo: true,
      title: 'bees',
      description: 'welcome to 49 hub reels',
      numberOfLikes: 120,
      numberOfComments: 20,
      numberOfExplores: 46,
      numberOfSaves: 20,
    ),
    ReelModel(
      id: 1,
      userName: 'Farouk Shahin',
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isVideo: true,
      title: 'bees',
      description: 'welcome to 49 hub reels',
      numberOfLikes: 120,
      numberOfComments: 20,
      numberOfExplores: 30,
      numberOfSaves: 9,
    ),
    ReelModel(
      id: 1,
      userName: 'Farouk Shahin',
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      isVideo: true,
      title: 'bees',
      description: 'welcome to 49 hub reels',
      numberOfLikes: 120,
      numberOfComments: 20,
      numberOfExplores: 26,
      numberOfSaves: 18,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconAppButton(
            icon: Icons.arrow_back,
            color: Colors.white,
            size: 24,
            onPressed: () => context.pop()),
      ),
      extendBody: true,
      backgroundColor: Colors.black,
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: reelsData.length,
          itemBuilder: (context, index) {
            return ReelCard(
              item: reelsData[index],
            );
          }),
    );
  }
}
