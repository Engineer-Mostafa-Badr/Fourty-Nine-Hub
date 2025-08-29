import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../res/style/app_colors.dart';
import '../../domain/entity/profile_entity.dart';

class ProfileSearchResults extends StatelessWidget {
  final List<ProfileEntity> profiles;
  final bool isLoading;

  const ProfileSearchResults({
    super.key,
    required this.profiles,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (profiles.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Text(
              context.isArabic ? 'لا توجد نتائج بحث' : 'No search results found',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final profile = profiles[index];
          return ProfileSearchResultCard(profile: profile);
        },
        childCount: profiles.length,
      ),
    );
  }
}

class ProfileSearchResultCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileSearchResultCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: size.width * 0.08,
            backgroundImage: profile.channelPicture?.mediaKey != null
                ? NetworkImage(profile.channelPicture!.mediaKey)
                : null,
            child: profile.channelPicture?.mediaKey == null
                ? Icon(
                    Icons.person,
                    size: size.width * 0.08,
                    color: Colors.grey,
                  )
                : null,
          ),
          SizedBox(width: size.width * 0.04),
          
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.channelName,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  profile.channelDescription,
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: size.height * 0.005),
                Row(
                  children: [
                    Icon(
                      Icons.video_collection,
                      size: size.width * 0.04,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      '${profile.videosCount} ${context.isArabic ? 'فيديو' : 'videos'}',
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (profile.isWinner) ...[
                      SizedBox(width: size.width * 0.02),
                      Icon(
                        Icons.star,
                        size: size.width * 0.04,
                        color: Colors.amber,
                      ),
                      Text(
                        context.isArabic ? 'فائز' : 'Winner',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          IconButton(
            onPressed: () {
              // Navigate to profile or implement desired action
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.PRIMARY_COLOR,
              size: size.width * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
