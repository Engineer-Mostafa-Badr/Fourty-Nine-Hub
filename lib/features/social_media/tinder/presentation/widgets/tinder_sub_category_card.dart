import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class TinderSubCategoryCard extends StatefulWidget {
  final SubCategoryEntity subCategoryCardData;
  final int index;
  final MainCategoryEntity mainCategory;

  const TinderSubCategoryCard({
    super.key,
    required this.subCategoryCardData,
    required this.index, required this.mainCategory,
  });

  @override
  State<TinderSubCategoryCard> createState() => _TinderSubCategoryCardState();
}

class _TinderSubCategoryCardState extends State<TinderSubCategoryCard> {
  bool containsSpecificId(List<FavoriteItem> favorites, String specificId) {
    return favorites.any((favorite) => favorite.subCategoryId.id == specificId);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(Routes.ADS, extra: AdsViewParams(subCategory: widget.subCategoryCardData,mainCategory: widget.mainCategory));
      },
      child: Container(
        width: 350.h,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 2,
          child: Column(
            children: [
              _buildImageSection(context),
              const Sizer(),
              _buildInfoSection(context, widget.mainCategory),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
  ) {
    final subCategoryId = widget.subCategoryCardData.id;

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SquareImage(
                fit: BoxFit.fitWidth,
                radius: 10,
                url: widget.subCategoryCardData.image,
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: BlocBuilder<TinderViewCubit, TinderViewState>(
                builder: (context, state) {
                  return IconAppButton(
                    size: 25,
                    icon: Icons.favorite,
                    color: containsSpecificId(
                            state.getFavCategoryModel?.data ?? [],
                            subCategoryId)
                        ? Colors.redAccent
                        : Colors.grey,
                    onPressed: () {
                      context
                          .read<TinderViewCubit>()
                          .addFavoriteCategory(categoryId: subCategoryId)
                          .then((value) =>
                              context.read<TinderViewCubit>().fetchFavorites());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
  final MainCategoryEntity mainCategory

  ) {
    final subCategoryId = widget.subCategoryCardData.id;
    final subCategoryName = widget.subCategoryCardData.name;
    final subCategoryPicture = widget.subCategoryCardData.image;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              subCategoryName.toString(),
              maxLines: 1,
              softWrap: true,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: 45.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: IconAppButton(
              icon: Icons.add,
              isCircle: true,
              color: Colors.white,
              backColor: AppColors.PRIMARY_COLOR,
              onPressed: () {
                context.push(Routes.CREATEAD,extra: CategorizationEntity(mainCategory: mainCategory, subCategory: widget.subCategoryCardData));
              },
            ),
          ),
        ],
      ),
    );
  }
}
