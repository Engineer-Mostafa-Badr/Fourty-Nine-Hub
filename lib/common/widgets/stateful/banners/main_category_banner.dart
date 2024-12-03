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

  MainCategoryBanner({
    super.key,
    this.canRegister = false,
    this.onRegister,
    required this.category,
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
    return CachedNetworkImage(
      width: double.infinity,
      imageUrl: widget.category.banner,
      height: MediaQuery.sizeOf(context).height * 0.13.h,
      imageBuilder: (context, i) => Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.category.banner.isNotEmpty
              ? Colors.transparent
              : AppColors.PRIMARY_COLOR,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
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
              text: context.locale == Locales.english?widget.category.nameEn!:widget.category.name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45.sp),
            ),
            PositionedDirectional(
              start: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.read<UserCubit>().isLoggedIn
                      ? IconButton(
                          color: AppColors.SECONDARY_COLOR,
                          onPressed: () async {
                            final result = await widget.onFavorite();
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
                          icon: Icon(widget.category.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border),
                        )
                      : const SizedBox.shrink(),
                  // Label(
                  //   text:
                  //       '${widget.category.total.toShortScale} ${LocaleKeys.ads.localize}',
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
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.PRIMARY_COLOR,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PositionedDirectional(end: 0, child: _buildRegisterButton()),
            Label(
              text: widget.category.name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45.sp),
            ),
            PositionedDirectional(
              start: 0,
              child: Column(
                children: [
                  context.read<UserCubit>().isLoggedIn
                      ? InkWell(
                          onTap: () async {
                            final result = await widget.onFavorite();
                            if (result != null && result != widget.isFavorite) {
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
    );
  }

  Widget _buildRegisterButton() {
    if (widget.canRegister) {
      return InkWell(
        onTap: () {
          log('88888888888888888888888888');
          widget.onRegister?.call();
        },
        child: Text(LocaleKeys.register.tr(),
            style: Styles.mediumText(
                color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
