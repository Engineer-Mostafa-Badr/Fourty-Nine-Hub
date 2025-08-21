import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helpers/manage_vibration.dart';
import '../../stateless/buttons/iconAppButton.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  bool? isFavorite;
  final double? fontSize;
  final bool removeFavorite;
  final bool? fromHome;
  final bool? fromFavorite;

  MainCategoryBanner({
    super.key,
    this.canRegister = false,
    this.fromHome = true,
    this.onRegister,
    this.fontSize,
    required this.category,
    this.removeFavorite = false,
    this.fromFavorite = false,
    required this.onFavorite,
    this.isFavorite,
  });

  @override
  State<MainCategoryBanner> createState() => _MainCategoryBannerState();
}

class _MainCategoryBannerState extends State<MainCategoryBanner> {
  // late bool _isFavorite;

  @override
  void initState() {
    if (widget.fromFavorite ?? false) {
      widget.isFavorite = true;
      widget.category.isFavorite = true;
    } else {
      widget.isFavorite = widget.category.isFavorite ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fromHome == true
        ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CachedNetworkImage(
        width: double.infinity,
        // imageUrl: 'https://images.google.com/images/branding/googlelogo/2x/googlelogo_light_color_272x92dp.png',
        imageUrl: widget.category.banner,
        height: MediaQuery.sizeOf(context).height * 0.1,
        imageBuilder: (context, i) => Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: widget.category.banner.isNotEmpty
                          ? Colors.transparent
                          : AppColors.PRIMARY_COLOR,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.category.banner,
                        ),
                        // colorFilter: ColorFilter.mode(
                        //   Colors.black.withOpacity(0.3),
                        //   BlendMode.darken,
                        // ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PositionedDirectional(
                            end: 0, child: _buildRegisterButton()),
                      ],
                    ),
                  ),
                  context.read<UserCubit>().isLoggedIn
                      ? widget.removeFavorite
                          ? Container()
                          : PositionedDirectional(
                              top: 10.h,
                              end: 10.w,
                              child: IconAppButton(
                                icon: widget.category.isFavorite == false
                                    ? Icons.favorite_outline
                                    : Icons.favorite,
                                onPressed: () async {
                                  final result =
                                      await widget.onFavorite();
                                  print("resutlt=$result");
                                  if (result == true) {
                                    print(result);
                                    setState(() {
                                      widget.category.isFavorite =
                                          !widget.category.isFavorite!;
                                      print(widget.category.isFavorite);
                                      widget.isFavorite = result;
                                      print("===================$result");
                                    });
                                  }
                                },
                                color: AppColors.SECONDARY_COLOR,
                              ),
                            )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Label(
                overflow: TextOverflow.ellipsis,
                text: context.locale == Locales.english
                    ? widget.category.nameEn!
                    : widget.category.name ?? "",
                style: TextStyle(
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize ?? 30.sp),
              ),
            ),
          ],
        ),
        placeholder: (context, u) => Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.white24,
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.08,
            decoration: BoxDecoration(
              color: AppColors.AUTH_CONTAINER_COLOR,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PositionedDirectional(
                  end: 0, child: _buildRegisterButton()),
              Label(
                text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize ?? 45.sp),
              ),
              // PositionedDirectional(
              //   start: 0,
              //   child: Column(
              //     children: [
              //       context.read<UserCubit>().isLoggedIn
              //           ? InkWell(
              //               onTap: () async {
              //                 final result = await widget.onFavorite();
              //                 if (result != null &&
              //                     result != widget.isFavorite) {
              //                   setState(() {
              //                     widget.isFavorite = result;
              //                     print("===================$result");
              //                   });
              //                 }
              //               },
              //               child: Icon(
              //                 widget.isFavorite == true
              //                     ? Icons.favorite
              //                     : Icons.favorite_border,
              //                 color: AppColors.SECONDARY_COLOR,
              //               ),
              //             )
              //           : const SizedBox.shrink(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    )
        : CachedNetworkImage(
      imageUrl: widget.category.banner,
      width: double.infinity,
      height: 70,
      imageBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.category.banner.isNotEmpty
              ? Colors.transparent
              : AppColors.PRIMARY_COLOR,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              widget.category.banner,
            ),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black38,
              width: double.infinity,
            ),
            PositionedDirectional(end: 16, child: _buildRegisterButton()),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Label(
                text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
                style: Styles.headerText(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      placeholder: (context, u) => Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.white24,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.08,
          decoration: BoxDecoration(
            color: AppColors.AUTH_CONTAINER_COLOR,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.PRIMARY_COLOR,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PositionedDirectional(end: 0, child: _buildRegisterButton()),
            Label(
              text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45.sp),
            ),
            // PositionedDirectional(
            //   start: 0,
            //   // top: 0,
            //   child: Column(
            //     children: [
            //       context.read<UserCubit>().isLoggedIn
            //           ?
            //       InkWell(
            //               onTap: () async => await widget.onFavorite(),
            //               child: const Icon(
            //                 Icons.favorite,
            //                 color: AppColors.SECONDARY_COLOR,
            //               ),
            //             )
            //           : const SizedBox.shrink(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    if (widget.canRegister) {
      return GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          log('88888888888888888888888888');
          widget.onRegister?.call();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.c0B1035,
            gradient: const LinearGradient(
              colors: [AppColors.SECONDARY_COLOR_DARK2,AppColors.c90242B],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0.h,horizontal: 32.h),
              child: Text(
                LocaleKeys.register.localize,
                style: Styles.mediumText(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class HomeMainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  bool? isFavorite;
  final double? fontSize;
  double? imageHeight;
  final bool removeFavorite;
  final bool? fromHome;
  final bool? fromFavorite;

  HomeMainCategoryBanner({
    super.key,
    this.canRegister = false,
    this.fromHome = true,
    this.onRegister,
    this.fontSize,
    this.imageHeight,
    required this.category,
    this.removeFavorite = false,
    this.fromFavorite = false,
    required this.onFavorite,
    this.isFavorite,
  });

  @override
  State<HomeMainCategoryBanner> createState() => _HomeMainCategoryBannerState();
}

class _HomeMainCategoryBannerState extends State<HomeMainCategoryBanner> {
  // late bool _isFavorite;

  @override
  void initState() {
    if (widget.fromFavorite ?? false) {
      widget.isFavorite = true;
      widget.category.isFavorite = true;
    } else {
      widget.isFavorite = widget.category.isFavorite ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fromHome == true
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child:CachedNetworkImage(
              width: double.infinity,
              imageUrl: widget.category.banner,
              height: widget.imageHeight,
              imageBuilder: (context, i) => Stack(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: widget.imageHeight,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: widget.category.banner.isNotEmpty
                              ? Colors.transparent
                              : AppColors.PRIMARY_COLOR,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              widget.category.banner,
                            ),
                            // colorFilter: ColorFilter.mode(
                            //   Colors.black.withOpacity(0.3),
                            //   BlendMode.darken,
                            // ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                            color: Colors.black38
                          ),
                          child: Center(
                            child: Label(
                              overflow: TextOverflow.ellipsis,
                              text: !context.isArabic
                                  ? widget.category.nameEn!
                                  : widget.category.name ?? "",
                              style: Styles.mediumText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PositionedDirectional(
                            end: 0, child: _buildRegisterButton()),
                      ],
                    ),
                  ),
                  context.read<UserCubit>().isLoggedIn
                      ? widget.removeFavorite
                      ? Container()
                      : PositionedDirectional(
                    // top: 10.h,
                    top: 10,
                    bottom: 10,
                    start: 10.w,
                    child: IconAppButton(
                      icon: widget.category.isFavorite == false
                          ? Icons.favorite_outline
                          : Icons.favorite,
                      shadows: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                        )
                      ],
                      onPressed: () async {
                        ManageVibration.vibrate();
                        final result =
                        await widget.onFavorite();
                        print("resutlt=$result");
                        if (result == true) {
                          print(result);
                          setState(() {
                            widget.category.isFavorite =
                            !widget.category.isFavorite!;
                            print(widget.category.isFavorite);
                            widget.isFavorite = result;
                            print("===================$result");
                          });
                        }
                      },
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
              placeholder: (context, u) => Shimmer.fromColors(
                baseColor: Colors.grey[100]!,
                highlightColor: Colors.white24,
                child: Container(
                  height: widget.imageHeight,
                  padding: EdgeInsets.symmetric(
                      vertical: 10.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: widget.category.banner.isNotEmpty
                        ? Colors.transparent
                        : AppColors.PRIMARY_COLOR,

                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.PRIMARY_COLOR,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PositionedDirectional(
                        end: 0, child: _buildRegisterButton()),
                    Label(
                      text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize ?? 45.sp),
                    ),
                  ],
                ),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: widget.category.banner,
            width: double.infinity,
            height: 70,
            imageBuilder: (context, i) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.category.banner.isNotEmpty
                    ? Colors.transparent
                    : AppColors.PRIMARY_COLOR,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.category.banner,
                  ),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black38,
                    width: double.infinity,
                  ),
                  PositionedDirectional(end: 16, child: _buildRegisterButton()),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Label(
                      text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
                      style: Styles.headerText(
                        fontSize: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            placeholder: (context, u) => Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.white24,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.08,
                decoration: BoxDecoration(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.PRIMARY_COLOR,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PositionedDirectional(end: 0, child: _buildRegisterButton()),
                  Label(
                    text: context.isArabic ? widget.category.name??'' : widget.category.nameEn ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.sp),
                  ),
                  // PositionedDirectional(
                  //   start: 0,
                  //   // top: 0,
                  //   child: Column(
                  //     children: [
                  //       context.read<UserCubit>().isLoggedIn
                  //           ?
                  //       InkWell(
                  //               onTap: () async => await widget.onFavorite(),
                  //               child: const Icon(
                  //                 Icons.favorite,
                  //                 color: AppColors.SECONDARY_COLOR,
                  //               ),
                  //             )
                  //           : const SizedBox.shrink(),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
  }

  Widget _buildRegisterButton() {
    if (widget.canRegister) {
      return GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
            log('88888888888888888888888888');
            widget.onRegister?.call();
          },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.c0B1035,
            gradient: const LinearGradient(
              colors: [AppColors.SECONDARY_COLOR_DARK2,AppColors.c90242B],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0.h,horizontal: 32.h),
              child: Text(
                LocaleKeys.register.localize,
                style: Styles.mediumText(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}