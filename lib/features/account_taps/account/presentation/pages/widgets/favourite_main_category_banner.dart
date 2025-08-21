import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteMainCategoryBanner extends StatefulWidget {
  const FavouriteMainCategoryBanner(
      {super.key,
      required this.category,
      required this.canRegister,
      this.onRegister,
      required this.onFavorite,
      this.isFavorite = false});
  final MainCategoryEntity category;
  final bool canRegister;
  final Function()? onRegister;
  final Function() onFavorite;
  final bool? isFavorite;

  @override
  State<FavouriteMainCategoryBanner> createState() =>
      _FavouriteMainCategoryBannerState();
}

class _FavouriteMainCategoryBannerState
    extends State<FavouriteMainCategoryBanner> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.category.banner,
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
                          onTap: () async {
                            ManageVibration.vibrate();
                             await widget.onFavorite();},
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.SECONDARY_COLOR,
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
              child: Column(
                children: [
                  context.read<UserCubit>().isLoggedIn
                      ? InkWell(
                          onTap: () async {
                            ManageVibration.vibrate();
                             await widget.onFavorite();},
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
      return InkWell(
        onTap: () async {
          ManageVibration.vibrate();
          await widget.onRegister?.call();},
        child: Text(Labels.register,
            style: Styles.mediumText(
                color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
