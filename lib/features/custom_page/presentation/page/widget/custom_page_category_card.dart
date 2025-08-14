import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../domain/entity/custom_page_categories_entity.dart';
import '../../../../../helpers/manage_vibration.dart';

class CustomPageCategoryCard extends StatefulWidget {
  final CustomPageCategoriesEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  bool? isSelected;
  final double? fontSize;
  final bool removeFavorite;
  final bool? fromHome;

  CustomPageCategoryCard({
    super.key,
    this.canRegister = false,
    this.fromHome = true,
    this.onRegister,
    this.fontSize,
    required this.category,
    this.removeFavorite = false,
    required this.onFavorite,
    this.isSelected,
  });

  @override
  State<CustomPageCategoryCard> createState() => _MainCategoryBannerState();
}

class _MainCategoryBannerState extends State<CustomPageCategoryCard> {
  // late bool _isFavorite;

  @override
  void initState() {
    widget.isSelected = widget.category.enabled ?? false;
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
                        widget.removeFavorite
                            ? Container()
                            : PositionedDirectional(
                                top: 10.h,
                                end: 10.w,
                                child: IconAppButton(
                                  icon: widget.category.selected == false
                                      ? Icons.favorite_outline
                                      : Icons.favorite,
                                  onPressed: () async {
      ManageVibration.vibrate();
                                    final result = await widget.onFavorite();
                                    print("resutlt=$result");
                                    print(result);
                                    setState(() {
                                      widget.category.selected =
                                          !widget.category.selected;
                                      print(widget.category.selected);
                                      widget.isSelected = result;
                                      print("===================$result");
                                    });
                                  },
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Label(
                      overflow: TextOverflow.ellipsis,
                      text: context.isArabic
                          ? widget.category.nameAr
                          : widget.category.nameEn,
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
                      text: context.isArabic
                          ? widget.category.nameAr
                          : widget.category.nameEn,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize ?? 45.sp),
                    ),
                    PositionedDirectional(
                      start: 0,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
      ManageVibration.vibrate();
                              final result = await widget.onFavorite();
                              if (result != null &&
                                  result != widget.isSelected) {
                                setState(() {
                                  widget.isSelected = result;
                                  print("===================$result");
                                });
                              }
                            },
                            child: Icon(
                              widget.category.selected == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.SECONDARY_COLOR,
                            ),
                          ),
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
                    text: context.isArabic
                        ? widget.category.nameAr
                        : widget.category.nameEn,
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
                                  widget.category.selected == true
                                      ? Icons.favorite
                                      : Icons.favorite,
                                  color: widget.category.selected == true
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
                    text: context.isArabic
                        ? widget.category.nameAr
                        : widget.category.nameEn,
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
      ManageVibration.vibrate();
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