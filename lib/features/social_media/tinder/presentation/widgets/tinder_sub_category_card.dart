import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_sub_category_ads_view.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TinderSubCategoryCard extends StatefulWidget {
  final SubCategoryData subCategoryCardData;
  final int index;

  const TinderSubCategoryCard({
    super.key,
    required this.subCategoryCardData,
    required this.index,
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
    final subCategoryId = widget.subCategoryCardData.sId ?? '';
    final subCategoryName = context.isArabic
        ? widget.subCategoryCardData.nameAr
        : widget.subCategoryCardData.nameEn;
    final subCategoryPicture = widget.subCategoryCardData.picture ?? '';
    return InkWell(
      onTap: () {},
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        child: Container(
          width: 0.35.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    const Spacer(),
                    BlocBuilder<TinderViewCubit, TinderViewState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconAppButton(
                            size: 20,
                            icon: containsSpecificId(
                                    state.getFavCategoryModel?.data ?? [],
                                    widget.subCategoryCardData.sId ?? '')
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: containsSpecificId(
                                    state.getFavCategoryModel?.data ?? [],
                                    widget.subCategoryCardData.sId ?? '')
                                ? Colors.redAccent
                                : Colors.grey,
                            onPressed: () {
                              context
                                  .read<TinderViewCubit>()
                                  .addFavoriteCategory(
                                      categoryId:
                                          widget.subCategoryCardData.sId ?? '')
                                  .then((value) => context
                                      .read<TinderViewCubit>()
                                      .fetchFavorites());
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.subCategoryCardData.picture ?? '',
                        fit: BoxFit.cover,
                        // radius: 10,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: IconAppButton(
                        icon: Icons.add,
                        padding: 0,
                        margin: 0,
                        isCircle: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: serviceLocator<TinderViewCubit>(),
                                child: BlocBuilder<TinderViewCubit,
                                    TinderViewState>(
                                  builder: (context, state) {
                                    return TinderSubCategoryAdsView(
                                      params: TinderSubAdsViewParams(
                                        subCategory: SubCategoryEntity(
                                          id: subCategoryId,
                                          name: subCategoryName.toString(),
                                          image: subCategoryPicture,
                                          isFavorite: containsSpecificId(
                                              state.getFavCategoryModel?.data ??
                                                  [],
                                              subCategoryId),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Sizer(),
              _buildInfoSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
  ) {
    final subCategoryId = widget.subCategoryCardData.sId ?? '';

    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              BlocBuilder<TinderViewCubit, TinderViewState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconAppButton(
                      size: 20,
                      icon: containsSpecificId(
                              state.getFavCategoryModel?.data ?? [],
                              subCategoryId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: containsSpecificId(
                              state.getFavCategoryModel?.data ?? [],
                              subCategoryId)
                          ? Colors.redAccent
                          : Colors.grey,
                      onPressed: () {
                        context
                            .read<TinderViewCubit>()
                            .addFavoriteCategory(categoryId: subCategoryId)
                            .then((value) => context
                                .read<TinderViewCubit>()
                                .fetchFavorites());
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SquareImage(
            fit: BoxFit.fitWidth,
            radius: 10,
            url: widget.subCategoryCardData.picture ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
  ) {
    final subCategoryName = context.isArabic
        ? widget.subCategoryCardData.nameAr
        : widget.subCategoryCardData.nameEn;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subCategoryName.toString(),
              maxLines: 1,
              softWrap: true,
              textScaler: TextScaler.noScaling,
              style: Styles.headerText(),
            ),
            Text(
              '${9355.toShortScale} ${context.isArabic ? "إعلان" : "ads"}',
              textScaler: TextScaler.noScaling,
              style: Styles.mediumText(),
            ),
          ],
        ),
      ),
    );
  }
}
