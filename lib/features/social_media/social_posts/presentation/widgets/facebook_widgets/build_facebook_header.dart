import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../../../create_post/domain/entities/activity_entity.dart';
import '../../../../create_post/domain/entities/feeling_entity.dart';
import '../../../data/models/location_model.dart';
import 'build_gradient_border.dart';
import 'image_from_internet.dart';
import '../posts/build_with_users.dart';
import '../../../../twitter/domain/entities/twitter_user_entity.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class BuildFacebookHeader extends StatelessWidget {
  const BuildFacebookHeader(
      {super.key,
      required this.user,
      this.activity,
      this.feeling,
      this.location,
      this.users,
      required this.sinceTime});
  final TwitterUserEntity user;
  final List<TwitterUserEntity>? users;
  final ActivityEntity? activity;
  final FeelingEntity? feeling;
  final LocationModel? location;
  final String sinceTime;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (user != null && user.image != null)
        user.hasStory == true
            ? ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (!context.read<UserCubit>().isLoggedIn) {
                    pleaseLoginDialog(context);
                    return;
                  }
                },
                child: GradientProfileBorder(
                    imageUrl: user.image ?? '',
                    segments: 3,
                    firstChar: user.firstName[0].toUpperCase()),
              )
            : ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (!context.read<UserCubit>().isLoggedIn) {
                    pleaseLoginDialog(context);
                    return;
                  }
                },
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    ImageFromInternet(
                        image: user.image ?? '',
                        isCircle: true,
                        defaultLogo: false,
                        width: 40,
                        height: 40,
                        firstChar: user.firstName[0].toUpperCase(),
                        charPadding: 0),
                  ],
                ),
              ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextColor(context))),
                      if ((activity != null &&
                              (activity?.id.isNotEmpty ?? false)) ||
                          (feeling != null &&
                              (feeling?.id.isNotEmpty ?? false)) ||
                          (location != null &&
                              (location?.place.isNotEmpty ?? false))) ...[
                        const WidgetSpan(child: SizedBox(width: 4)),
                        const TextSpan(
                            text: 'is',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.GREY_DARK_COLOR)),
                        const WidgetSpan(child: SizedBox(width: 4)),
                      ],
                      if (feeling != null && (feeling?.id.isNotEmpty ?? false))
                        TextSpan(
                          children: [
                            WidgetSpan(
                                child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(feeling?.image ?? ''),
                            )),
                            const WidgetSpan(
                                child: SizedBox(
                              width: 5,
                            )),
                            TextSpan(
                                text: LocaleKeys.feeling.localize,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.GREY_DARK_COLOR)),
                            const WidgetSpan(
                                child: SizedBox(
                              width: 5,
                            )),
                            TextSpan(
                                text: context.isArabic
                                    ? feeling?.name ?? ''
                                    : feeling?.nameEn ?? '',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.GREY_DARK_COLOR))
                          ],
                        ),
                      if (activity != null &&
                          (activity?.id.isNotEmpty ?? false))
                        TextSpan(
                          children: [
                            WidgetSpan(
                                child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  activity?.mainActivity?.image ?? ''),
                            )),
                            const WidgetSpan(
                                child: SizedBox(
                              width: 4,
                            )),
                            TextSpan(
                                text: context.isArabic
                                    ? activity?.mainActivity?.name ?? ''
                                    : activity?.mainActivity?.nameEn ?? '',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.GREY_DARK_COLOR)),
                            const WidgetSpan(
                                child: SizedBox(
                              width: 4,
                            )),
                            TextSpan(
                                text: context.isArabic
                                    ? activity?.name ?? ''
                                    : activity?.nameEn ?? '',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.GREY_DARK_COLOR))
                          ],
                        ),
                      if (users != null && (users?.isNotEmpty ?? false))
                        TextSpan(children: [
                          const WidgetSpan(child: Sizer()),
                          TextSpan(
                              text: LocaleKeys.withKey.localize,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.GREY_DARK_COLOR)),
                          const WidgetSpan(child: Sizer()),
                          // TextSpan(text: "${users?.first.firstName??''} ${users?.first.lastName??''}",
                          //     onEnter: (event) {
                          //       context.pushNamed(Routes.OTHERSACCOUNT,
                          //           extra: users?[0].id??'');
                          //     },
                          //     style: const TextStyle(
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w600,
                          //         color: AppColors.PRIMARY_COLOR)),
                          WidgetSpan(
                              child: ClickableWidget(
                            onTap: () {
                              context.pushNamed(Routes.OTHERSACCOUNT,
                                  extra: users?[0].id ?? '');
                            },
                            child: Text(
                                "${users?.first.firstName ?? ''} ${users?.first.lastName ?? ''}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.getTextColor(context))),
                          )),
                          if ((users?.length ?? 0) > 1)
                            TextSpan(children: [
                              const WidgetSpan(
                                  child: SizedBox(
                                width: 4,
                              )),
                              TextSpan(
                                  text: context.isArabic ? 'و' : 'and',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.GREY_DARK_COLOR)),
                              const WidgetSpan(
                                  child: SizedBox(
                                width: 4,
                              )),
                              WidgetSpan(
                                  child: ClickableWidget(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => BuildWithUsers(
                                                  users: users ?? [],
                                                ));
                                        // sheetController.collapse();
                                        // bottomSheet(
                                        //     isScrollControlled: true,
                                        //     context: context,
                                        //     widget: BuildSearchFriends(
                                        //       controller: context.read<CreatePostCubit>(),
                                        //       onSelectUser: (user) => context
                                        //           .read<CreatePostCubit>()
                                        //           .selectUsers(user),
                                        //     ));
                                      },
                                      child: Text(
                                          context.isArabic
                                              ? "${(users?.length ?? 0) - 1} أخرين"
                                              : "${(users?.length ?? 0) - 1} others",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.getTextColor(
                                                  context))))),
                            ])
                        ]),
                      if (location != null &&
                          (location?.place.isNotEmpty ?? false))
                        TextSpan(children: [
                          const WidgetSpan(child: Sizer()),
                          TextSpan(
                              text: context.isArabic ? 'في' : 'at',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.GREY_DARK_COLOR)),
                          const WidgetSpan(child: Sizer()),
                          TextSpan(
                              text: location?.place ?? '',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.getTextColor(context)))
                        ]),
                    ])),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text("${sinceTime ?? ''} .",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.getTextColor(context))),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    Assets.publication,
                    width: 16,
                    height: 12.5,
                    color: context.isDarkMode ? Colors.white : null,
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (!context.read<UserCubit>().isLoggedIn) {
                    pleaseLoginDialog(context);
                    return;
                  }
                },
                child: Icon(
                  Icons.more_horiz_outlined,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                  size: 24,
                )),
            SizedBox(width: 12.0),
            ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (!context.read<UserCubit>().isLoggedIn) {
                    pleaseLoginDialog(context);
                    return;
                  }
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.getRedColor(context),
                  size: 24,
                )),
          ],
        ),
      ],
    );
  }
}
