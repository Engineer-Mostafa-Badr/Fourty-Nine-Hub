import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../res/assets/assets.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/entity/user_star_entity.dart';

class ProfileHeader extends StatefulWidget {
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
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool _isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileHeader - isCurrentUser: ${widget.isCurrentUser}');
    debugPrint('ProfileHeader - profile: ${widget.profile?.channelName}');
    debugPrint('ProfileHeader - user: ${widget.user?.firstName}');

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
          // Subscribe Button Section - إخفاؤه للمستخدم الحالي
          if (!widget.isCurrentUser) ...[
            SizedBox(height: _getResponsiveSpacing(context, 16)),
            _buildSubscribeSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.3;

    final bannerUrl = widget.profile?.channelCover != null
        ? widget.profile!.channelCover!.mediaKey
        : null;

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
    final profileImageUrl =
        widget.isCurrentUser && widget.profile?.channelPicture != null
            ? widget.profile!.channelPicture!.mediaKey
            : widget.user?.image ?? '';

    final displayName = widget.isCurrentUser &&
            widget.profile != null &&
            widget.profile!.channelName.isNotEmpty
        ? widget.profile!.channelName
        : (widget.user != null
            ? "${widget.user!.firstName} ${widget.user!.lastName}".trim()
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
                        ? "${displayName.toLowerCase().replaceAll(' ', '')}@ • ${_getArabicVideosText(widget.videosCount)}"
                        : "@${displayName.toLowerCase().replaceAll(' ', '')} • ${widget.videosCount} videos",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      color: Colors.grey[600],
                    ),
                  ),
                  if (widget.isCurrentUser &&
                      widget.profile?.channelDescription != null &&
                      widget.profile!.channelDescription.isNotEmpty) ...[
                    SizedBox(height: _getResponsiveSpacing(context, 8)),
                    Text(
                      widget.profile!.channelDescription,
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

  Widget _buildSubscribeSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _isSubscribed ? Colors.grey[300] : Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    setState(() {
                      _isSubscribed = !_isSubscribed;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isSubscribed
                              ? (context.isArabic
                                  ? 'تم الاشتراك'
                                  : 'Subscribed')
                              : (context.isArabic
                                  ? 'تم إلغاء الاشتراك'
                                  : 'Unsubscribed'),
                        ),
                        backgroundColor:
                            _isSubscribed ? Colors.green : Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSubscribed ? Icons.check : Icons.add,
                          color: _isSubscribed ? Colors.black : Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _isSubscribed
                              ? (context.isArabic ? 'مشترك' : 'Subscribed')
                              : (context.isArabic ? 'اشتراك' : 'Subscribe'),
                          style: TextStyle(
                            color: _isSubscribed ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!_isSubscribed) ...[
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.grey[700],
                  size: 24,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.isArabic
                            ? 'اشترك أولاً لتفعيل الإشعارات'
                            : 'Subscribe first to enable notifications',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
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
