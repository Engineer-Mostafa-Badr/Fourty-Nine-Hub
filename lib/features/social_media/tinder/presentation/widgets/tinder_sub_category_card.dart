import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
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
    return InkWell(
      onTap: () {},
      child: Container(
        width: 225,
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

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SquareImage(
                fit: BoxFit.fitWidth,
                radius: 10,
                url: widget.subCategoryCardData.picture ?? '',
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
  ) {
    final subCategoryId = widget.subCategoryCardData.sId ?? '';
    final subCategoryName = widget.subCategoryCardData.nameEn ?? '';
    final subCategoryPicture = widget.subCategoryCardData.picture ?? '';

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: subCategoryName,
                style: Styles.headerText(
                  fontSize: MediaQuery.of(context).size.width * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Label(
                text: '${9355.toShortScale} ads',
                style: Styles.mediumText(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ],
          ),
          IconAppButton(
            icon: Icons.add,
            isCircle: true,
            color: Colors.white,
            backColor: AppColors.PRIMARY_COLOR,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: serviceLocator<TinderViewCubit>(),
                    child: BlocBuilder<TinderViewCubit, TinderViewState>(
                      builder: (context, state) {
                        return TinderSubCategoryAdsView(
                          params: TinderSubAdsViewParams(
                            subCategory: SubCategoryEntity(
                              id: subCategoryId,
                              name: subCategoryName,
                              image: subCategoryPicture,
                              isFavorite: containsSpecificId(
                                  state.getFavCategoryModel?.data ?? [],
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
        ],
      ),
    );
  }
}
