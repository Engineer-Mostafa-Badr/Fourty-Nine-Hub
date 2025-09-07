import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../res/assets/assets.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/entity/user_star_entity.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity? profile;
  final UserStarEntity? user;
  final bool isCurrentUser;
  final int videosCount;

  const ProfileHeader({
    super.key,
    this.profile,
    this.user,
    this.isCurrentUser = false,
    required this.videosCount,
  });

  @override
  Widget build(BuildContext context) {
    // إضافة debug للتحقق من البيانات
    debugPrint('ProfileHeader - isCurrentUser: $isCurrentUser');
    debugPrint('ProfileHeader - profile: ${profile?.channelName}');
    debugPrint('ProfileHeader - user: ${user?.firstName}');

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context, 20),
      ),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(context),
          SizedBox(height: _getResponsiveSpacing(context, 20)),
          // Profile Info Section
          _buildProfileInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.3;

    final bannerUrl =
        profile?.channelCover != null ? profile!.channelCover!.mediaKey : null;

    log('bannerUrl: $bannerUrl');

    return Container(
      width: double.infinity,
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(_getResponsiveBorderRadius(context, 16)),
        color: Colors.grey[200],
      ),
      child: bannerUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                  _getResponsiveBorderRadius(context, 16)),
              child: CachedNetworkImage(
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return Image.asset(
                    Assets.logo,
                    fit: BoxFit.contain,
                  );
                },
              ),
            )
          : Center(
              child: Icon(
                Icons.image,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
    );
  }

  Widget _buildProfileInfoSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profileSize = screenWidth < 360 ? 60.0 : 80.0;

    // تحسين null safety
    final profileImageUrl = isCurrentUser && profile?.channelPicture != null
        ? profile!.channelPicture!.mediaKey
        : user?.image ?? '';

    final displayName =
        isCurrentUser && profile != null && profile!.channelName.isNotEmpty
            ? profile!.channelName
            : (user != null
                ? "${user!.firstName} ${user!.lastName}".trim()
                : "Unknown User");

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: profileImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: profileSize * 0.5,
                            color: Colors.grey[600],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: profileSize * 0.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: profileSize * 0.5,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ),
            SizedBox(width: _getResponsiveSpacing(context, 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: _getResponsiveSpacing(context, 4)),
                  Text(
                    context.isArabic
                        ? "${displayName.toLowerCase().replaceAll(' ', '')}@ • ${_getArabicVideosText(videosCount)}"
                        : "@${displayName.toLowerCase().replaceAll(' ', '')} • $videosCount videos",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      color: Colors.grey[600],
                    ),
                  ),
                  if (isCurrentUser &&
                      profile?.channelDescription != null &&
                      profile!.channelDescription.isNotEmpty) ...[
                    SizedBox(height: _getResponsiveSpacing(context, 8)),
                    Text(
                      profile!.channelDescription,
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 14),
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods for responsive design
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8;
    }
    return baseRadius;
  }

  String _getArabicVideosText(int count) {
    if (count == 0) {
      return 'لا توجد فيديوهات';
    } else if (count == 1) {
      return 'فيديو واحد';
    } else if (count == 2) {
      return 'فيديوهان';
    } else if (count >= 3 && count <= 10) {
      return '$count فيديوهات';
    } else {
      return '$count فيديو';
    }
  }
}
