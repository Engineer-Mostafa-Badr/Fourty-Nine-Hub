import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../cubit/social_posts_cubit.dart';
import 'image_from_internet.dart';
import 'profile_photos.dart';
import 'profile_posts.dart';
import 'profile_videos.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

import '../../../../../../res/style/const.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookOtherProfile extends StatefulWidget {
  const FacebookOtherProfile({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FacebookOtherProfile> createState() => _FacebookOtherProfileState();
}

class _FacebookOtherProfileState extends State<FacebookOtherProfile> {
  bool _showPosts = true;

  bool _showPhotos = false;

  bool _showVideos = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        Align(alignment: AlignmentDirectional.centerStart,child: IconButton(onPressed: ()=>context.read<PeopleTabCubit>().showList(), icon: Icon(Icons.arrow_back))),
        ProfileHeader(),
        Divider(
          thickness: 6,
          color: AppColors.getFindFillColor(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(spacing: 5, children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
      ManageVibration.vibrate();
                  setState(() {
                    _showPosts = true;
                    if (_showPosts) {
                      _showPhotos = false;
                      _showVideos = false;
                    } else if (!_showPosts) {
                      //context.read<RestaurantsCubit>().loadInitialRestaurantsData('');
                    }
                  });
                },
                child: _tabButton(context, LocaleKeys.posts.localize, _showPosts),
              ),
            ),
            Expanded(
              child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    setState(() {
                      _showPhotos = true;
                      if (_showPhotos) {
                        _showPosts = false;
                        _showVideos = false;
                      } else if (!_showPhotos) {
                        //context.read<RestaurantsCubit>().loadInitialRestaurantsData('');
                      }
                    });
                  },
                  child: _tabButton(
                      context, context.isArabic ? 'صور' : 'Photos', _showPhotos)),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {setState(() {
      ManageVibration.vibrate();
                  _showVideos = true;
                  if (_showVideos) {
                    _showPhotos = false;
                    _showPosts = false;
                  } else if (!_showVideos) {
                    //context.read<RestaurantsCubit>().loadInitialRestaurantsData('');
                  }
                });},
                child: _tabButton(
                    context, context.isArabic ? 'فيديوهات' : 'Videos', _showVideos),
              ),
            ),
          ]),
        ),
        const Sizer(),
        if(_showPosts)ProfilePosts(),
        if(_showPhotos)ProfilePhotos(name: 'Mohamed',),
        if(_showVideos)ProfileVideos(),
      ],
    );
  }

  Widget _tabButton(BuildContext context, String title, bool category) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: category
              ? AppColors.getFacebookFillRedColor(context)
              : Colors.transparent),
      child: Label(
        text: title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: category
                ? AppColors.Facebook_Red_DARK
                : context.isDarkMode
                ? Colors.white.withOpacity(.3)
                : Colors.black.withOpacity(.3)),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool isFriend=false;

@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 380.h,
          child: Stack(
            children: [
              SizedBox(
                height: 270.h,
                child: InkWell(
                  onTap: () {
      ManageVibration.vibrate();
                    // showDialog(
                    //     context: context,
                    //     builder: (context) =>
                    //         ImageDetailsScreen(
                    //           image: user.profileCover ?? '',
                    //           fromPost: true,
                    //           onRemoveImage: () {
                    //             // controller
                    //             //     .removePhoto(images![index]);
                    //             context.pop();
                    //           },
                    //         ));
                  },
                  child: Image.network(
                    // user.profileCover!.isNotEmpty
                    //     ? user.profileCover!
                    //     :
                    UIConst.socialImagePlaceHolder,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
              PositionedDirectional(
                  bottom: 1.h,
                  start: 10,
                  child: GestureDetector(
                    onTap: () {
      ManageVibration.vibrate();
                      // if (context.isUserLoggedIn) {
                      //   context.read<UserCubit>().updateProfileView(
                      //       isProfile: false,
                      //       userId: widget.userId);
                      // }
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => ImageDetailsScreen(
                      //       image: user.profilePicture ?? '',
                      //       fromPost: true,
                      //       onRemoveImage: () {
                      //         // controller
                      //         //     .removePhoto(images![index]);
                      //         context.pop();
                      //       },
                      //     ));
                    },
                    child: CircleAvatar(
                      radius: 120.w,
                      backgroundColor:
                      Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      child: ImageFromInternet(
                        image:
                        //user.profilePicture ??
                        UIConst.profilePlaceHolder,
                        height: 250.h,
                        width: 300.w,
                        isCircle: true,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Sizer(),
              Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          Label(
                              text: 'Mohamed Magdy',
                              //"${user.firstName} ${user.lastName}",
                              style: Styles.headerText(
                                fontWeight: FontWeight.w600,
                              )),
                          const Sizer(
                            width: 5,
                          ),
                          const Icon(
                            Icons.verified,
                            color: AppColors.blueColor,
                            size: 20,
                          )
                        ],
                      )),
                ],
              ),
              Sizer(
                height: 4.h,
              ),
              Row(
                children: [
                  _buildCounter(
                    context,
                    value: '4234',
                    //'${user.friendsCount} ',
                    label: LocaleKeys.friends.localize,
                  ),
                  const Sizer(),
                  _buildCounter(
                    context,
                    value: '324',
                    //'${user.followersCount} ',
                    label: LocaleKeys.follower.localize,
                  ),
                  const Sizer(),
                  _buildCounter(
                    context,
                    value: '435',
                    //'${user.followersCount} ',
                    label: LocaleKeys.views.localize,
                  ),
                ],
              ),
              Sizer(height: 5.h),
              // if (user.bio.isNotEmpty && user.bio != 'Hidden')
              Label(
                text: 'Lorem ipsum dolor sit amet consectetur.'
                    .toArabicNumbers(context),
                //user.bio,
                textDirection: TextDirection.ltr,
                style: Styles.mediumText(),
              ),
              Sizer(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label:
                      isFriend?LocaleKeys.friend.localize :LocaleKeys.addFriend.localize,
                      onPressed: () {
      ManageVibration.vibrate();
                        setState(() {
                          isFriend= !isFriend;
                        });
                      },
                      backColor: AppColors.getFindFillColor(context),
                      color: AppColors.getTextColor(context),
                      textColor: AppColors.getTextColor(context),
                      icon:isFriend?FontAwesomeIcons.userCheck: Icons.person_add_alt_1,
                      iconWidget: Sizer(),
                      radius: 10,
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                    child: AppButton(
                      label: LocaleKeys.message.localize,
                      onPressed: () {

      ManageVibration.vibrate();
                      },
                      backColor: AppColors.getButtonPrimaryWhiteColor(context),
                      color: AppColors.getPrimaryTextColor(context),
                      textColor: AppColors.getPrimaryTextColor(context),
                      icon: FontAwesomeIcons.facebookMessenger,
                      iconWidget: Sizer(),
                      radius: 10,
                    ),
                  ),
                  const Sizer(),
                  AppButton(
                    label: '',
                    onPressed: () {

      ManageVibration.vibrate();
                    },
                    backColor: AppColors.getFindFillColor(context),
                    color: AppColors.getTextColor(context),
                    textColor: AppColors.getTextColor(context),
                    icon: Icons.more_horiz,
                    radius: 10,
                    padding: 30.h,
                  )
                ],
              ),
              const Sizer(),

              /// reference for logic
              // if (user.city.isNotEmpty ||
              //     user.job.isNotEmpty ||
              //     user.country.isNotEmpty ||
              //     user.phone.isNotEmpty)
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 // if (user.city.isNotEmpty && user.city != 'Hidden')
              //                   ...[
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.home_rounded,
              //                         size: 24,
              //                       ),
              //                       const Sizer(
              //                         width: 5,
              //                       ),
              //                       Label(
              //                           text: LocaleKeys.livesIn.localize,
              //                           style: Styles.headerText(
              //                               color: Colors.grey, fontSize: 30)),
              //                       Sizer(
              //                         height: 5.h,
              //                       ),
              //                       Expanded(
              //                         child: Label(
              //                           text:'lsa;dk',
              //                           //user.city,
              //                           style: Styles.headerText(fontSize: 30),
              //                           maxLines: 1,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Sizer(
              //                     height: 5.h,
              //                   ),
              //                 ],
              //                 // if (user.country.isNotEmpty &&
              //                 //     user.country != 'Hidden')
              //                   ...[
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.location_on,
              //                         size: 24,
              //                       ),
              //                       const Sizer(
              //                         width: 5,
              //                       ),
              //                       Label(
              //                           text: LocaleKeys.from.localize,
              //                           style: Styles.headerText(
              //                               color: Colors.grey, fontSize: 30)),
              //                       Sizer(
              //                         height: 5.h,
              //                       ),
              //                       Expanded(
              //                         child: Label(
              //                           text:'egypt',
              //                           //user.country,
              //                           style: Styles.headerText(fontSize: 30),
              //                           maxLines: 1,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Sizer(
              //                     height: 5.h,
              //                   ),
              //                 ],
              //                // if (user.job.isNotEmpty && user.isDocument == true&&user.job!='Hidden') ...[
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.home_repair_service,
              //                         size: 24,
              //                       ),
              //                       const Sizer(
              //                         width: 5,
              //                       ),
              //                       Label(
              //                           text: LocaleKeys.work.localize,
              //                           style: Styles.headerText(
              //                               color: Colors.grey, fontSize: 30)),
              //                       Sizer(
              //                         height: 5.h,
              //                       ),
              //                       Expanded(
              //                         child: Label(
              //                           text:'designer',
              // //user.job,
              //                           style: Styles.headerText(fontSize: 30),
              //                           maxLines: 1,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Sizer(
              //                     height: 5.h,
              //                   ),
              //                 //if (user.phone.isNotEmpty && user.phone != 'Hidden')
              //                   ...[
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.phone_android,
              //                         size: 24,
              //                       ),
              //                       const Sizer(
              //                         width: 5,
              //                       ),
              //                       Label(
              //                           text: LocaleKeys.phone.localize,
              //                           style: Styles.headerText(
              //                               color: Colors.grey, fontSize: 30)),
              //                       const Sizer(),
              //                       Expanded(
              //                         child: Label(
              //                           text:'0110022323',
              //                           //user.phone,
              //                           style: Styles.headerText(fontSize: 30),
              //                           maxLines: 1,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Sizer(
              //                     height: 5.h,
              //                   ),
              //                 ],
              //                 // if (user.maritalStatus.isNotEmpty &&
              //                 //     user.maritalStatus != 'Hidden')
              //                   ...[
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.favorite,
              //                         size: 24,
              //                       ),
              //                       const Sizer(
              //                         width: 5,
              //                       ),
              //                       Expanded(
              //                         child: Label(
              //                           text:'sada',
              //                           //user.maritalStatus,
              //                           style: Styles.headerText(fontSize: 30),
              //                           maxLines: 1,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Sizer(
              //                     height: 5.h,
              //                   ),
              //                 ],
              //               ],
              //             ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(BuildContext context,
      {required String value, required String label}) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: context.isArabic ? convertToArabicNumbers(value) : value,
              style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.color)),
          TextSpan(text: ' '),
          TextSpan(
              text: label,
              style: Styles.mediumText(
                color: Colors.grey,
              )),
        ]));
  }
}