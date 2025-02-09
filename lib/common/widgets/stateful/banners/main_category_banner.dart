import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

class MainCategoryBanner extends StatefulWidget {
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  bool? isFavorite;
  final double? fontSize;
  final bool removeFavorite;
  final bool? fromHome;

  MainCategoryBanner({
    super.key,
    this.canRegister = false,
    this.fromHome = true,
    this.onRegister,
    this.fontSize,
    required this.category,
    this.removeFavorite = false,
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
    widget.isFavorite = widget.category.isFavorite ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fromHome == true
        ? Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(30.r),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: widget.category.banner,
              height: MediaQuery.sizeOf(context).height * 0.13.h,
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
                                : Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      color: AppColors.SECONDARY_COLOR,
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
                                      icon: Icon(
                                        widget.category.isFavorite == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                      ),
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
                          color: AppColors.PRIMARY_COLOR,
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
                      text: widget.category.name ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize ?? 45.sp),
                    ),
                    PositionedDirectional(
                      start: 0,
                      child: Column(
                        children: [
                          context.read<UserCubit>().isLoggedIn
                              ? InkWell(
                                  onTap: () async {
                                    final result = await widget.onFavorite();
                                    if (result != null &&
                                        result != widget.isFavorite) {
                                      setState(() {
                                        widget.isFavorite = result;
                                        print("===================$result");
                                      });
                                    }
                                  },
                                  child: Icon(
                                    widget.isFavorite == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          // Sizer(
                          //   height: 15.h,
                          // ),
                          // Label(
                          //   text: '${widget.category.total.toShortScale} ${Labels.ads}',
                          //   style: Styles.mediumText(
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: widget.category.banner,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.09,
            imageBuilder: (context, i) => Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: widget.category.banner.isNotEmpty
                    ? Colors.transparent
                    : AppColors.PRIMARY_COLOR,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.category.banner,
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PositionedDirectional(end: 0, child: _buildRegisterButton()),
                  Label(
                    text: widget.category.name ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.sp),
                  ),
                  PositionedDirectional(
                    start: 0,
                    child: Column(
                      children: [
                        context.read<UserCubit>().isLoggedIn
                            ? InkWell(
                                onTap: () async => await widget.onFavorite(),
                                child: Icon(
                                  widget.category.isFavorite == true
                                      ? Icons.favorite
                                      : Icons.favorite,
                                  color: widget.category.isFavorite == true
                                      ? AppColors.SECONDARY_COLOR
                                      : AppColors.LIGHT_GRAY_COLOR2,
                                ),
                              )
                            : const SizedBox.shrink(),
                        // Sizer(
                        //   height: 15.h,
                        // ),
                        // Label(
                        //   text:
                        //       '${widget.category.numberOfAds.toShortScale} ${LocaleKeys.ad.localize}',
                        //   style: Styles.mediumText(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        // )
                      ],
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
                    text: widget.category.name ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.sp),
                  ),
                  PositionedDirectional(
                    start: 0,
                    // top: 0,
                    child: Column(
                      children: [
                        context.read<UserCubit>().isLoggedIn
                            ? InkWell(
                                onTap: () async => await widget.onFavorite(),
                                child: const Icon(
                                  Icons.favorite,
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildRegisterButton() {
    if (widget.canRegister) {
      return TextButton(
        onPressed: () {
          log('88888888888888888888888888');
          widget.onRegister?.call();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(0),
          minimumSize: const Size(70, 30),
          maximumSize: const Size(70, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(LocaleKeys.register.tr(),
            style: Styles.mediumText(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
