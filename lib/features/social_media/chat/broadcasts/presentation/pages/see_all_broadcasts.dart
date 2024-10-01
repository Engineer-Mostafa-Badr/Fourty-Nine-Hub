import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/widgets/follow_broadcast_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class SeeAllBroadcasts extends StatelessWidget {
  const SeeAllBroadcasts({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the broadcast cards
    final List<Map<String, String>> broadcasts = [
      {
        'title': 'FC Barcelona',
        'iconPath':
            'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg'
      },
      {
        'title': 'BBC News',
        'iconPath':
            'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png'
      },
      {
        'title': 'Real Madrid FC',
        'iconPath': 'https://images.alphacoders.com/116/thumb-1920-1163534.jpg'
      },
      {
        'title': 'FC Barcelona',
        'iconPath':
            'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg'
      },
      {
        'title': 'BBC News',
        'iconPath':
            'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png'
      },
      {
        'title': 'Real Madrid FC',
        'iconPath': 'https://images.alphacoders.com/116/thumb-1920-1163534.jpg'
      },
      {
        'title': 'FC Barcelona',
        'iconPath':
            'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg'
      },
      {
        'title': 'BBC News',
        'iconPath':
            'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png'
      },
      {
        'title': 'Real Madrid FC',
        'iconPath': 'https://images.alphacoders.com/116/thumb-1920-1163534.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR, // Background color
        elevation: 0,
        leadingWidth: 26,
        title: Text(
          LocaleKeys.broadcasts.tr(),
          style: Styles.headerText(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: broadcasts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns in the grid
            mainAxisSpacing: 16, // Vertical space between grid items
            crossAxisSpacing: 16, // Horizontal space between grid items
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final broadcast = broadcasts[index];
            return FollowBroadcastCard(
              broadcast['title']!,
              broadcast['iconPath']!,
            );
          },
        ),
      ),
    );
  }
}
