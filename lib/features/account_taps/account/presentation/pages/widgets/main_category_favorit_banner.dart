import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/favouite_category_model/favouite_category_model.dart';

class MainCategoryFavoriteBanner extends StatefulWidget {
  final FavouriteCategoryModel category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  final double? fontSize;
  final bool removeFavorite;

  MainCategoryFavoriteBanner({
    super.key,
    this.canRegister = false,
    this.onRegister,
    this.fontSize,
    required this.category,
    this.removeFavorite = false,
    required this.onFavorite,
  });

  @override
  State<MainCategoryFavoriteBanner> createState() =>
      _MainCategoryFavoriteBannerState();
}

class _MainCategoryFavoriteBannerState
    extends State<MainCategoryFavoriteBanner> {
  // late bool _isFavorite;

  @override
  void initState() {
    // if (widget.fromFavorite ?? false) {
    //   widget.isFavorite = true;
    //   widget.category.isFavorite = true;
    // } else {
    //   widget.isFavorite = widget.category.isFavorite ?? false;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.category.categoryId!.banner!,
      width: double.infinity,
      height: 70,
      imageBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.category.categoryId!.banner!.isNotEmpty
              ? Colors.transparent
              : AppColors.PRIMARY_COLOR,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              widget.category.categoryId!.banner!,
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
                    color: Colors.black.withValues(alpha: .6),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Label(
                text: context.isArabic
                    ? widget.category.categoryId!.nameAr ?? ''
                    : widget.category.categoryId!.nameEn ?? "",
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
              text: context.isArabic
                  ? widget.category.categoryId!.nameAr ?? ''
                  : widget.category.categoryId!.nameEn ?? "",
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
          log('88888888888888888888888888');
          widget.onRegister?.call();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.c0B1035,
            gradient: const LinearGradient(
              colors: [AppColors.SECONDARY_COLOR_DARK2, AppColors.c90242B],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 32.h),
              child: Text(
                LocaleKeys.register.localize,
                style: Styles.mediumText(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
