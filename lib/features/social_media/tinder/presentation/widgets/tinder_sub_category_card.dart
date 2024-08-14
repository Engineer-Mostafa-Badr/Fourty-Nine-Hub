

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_sub_category_ads_view.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TinderSubCategoryCard extends StatefulWidget {
  final SubCategoryData subCategoryCardData;

  // final bool activeFav;
  // final TinderViewCubit tinderCubit;
  final UserCubit userCubit;
  final int index;

  // final bool isFavCard;

  const TinderSubCategoryCard({
    super.key,
    required this.subCategoryCardData,
    // required this.activeFav,
    required this.index,
    // required this.isFavCard,
    // required TinderViewCubit tinderCubit,
    // required this.tinderCubit,
    required this.userCubit,
  });

  @override
  State<TinderSubCategoryCard> createState() => _TinderSubCategoryCardState();
}

class _TinderSubCategoryCardState extends State<TinderSubCategoryCard> {
  bool containsSpecificId(List<FavoriteItem> favorites, String specificId) {
    return favorites.any((favorite) {
      // log("${favorite.subCategoryId.id == specificId} is faaaaaaaaaaaaaaaaaav");

      return favorite.subCategoryId.id == specificId;
    });
    // .any((favorite) => favorite.id == '66b83154240d94d7787125c3');
    // for (var element in favorites) {
    //   return element.category!.id == specificId;
    // }
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();

    // log(widget.isFavCard.toString()+" ${widget.subCategoryCardData.sId}");
    // // log(context
    //     .watch<TinderViewCubit>()
    //     .state
    //     .getFavCategoryModel
    //     .data!
    //     .favorites!
    //     .first
    //     .id.toString());
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 2,
          child: Column(
            children: [
              _buildImageSection(context,
                  tinderCubit: tinderCubit, userCubit: widget.userCubit),
              const Sizer(),
              _buildInfoSection(context,
                  tinderCubit: tinderCubit, userCubit: widget.userCubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SquareImage(
                fit: BoxFit.fitWidth,
                radius: 10,
                url: widget
                    .subCategoryCardData.picture, //شوية وخدها من الكيوبت ستيت
              ),
            ),
//--------------------------
            // log(containsSpecificId(state.getFavCategoryModel!.favorites,
            //             widget.subCategoryCardData.sId.toString())
            //         .toString() +
            //     " ${widget.subCategoryCardData.sId} ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
            // state.getFavCategoryModel!.favorites.forEach((element) {
            //   log(element.id +
            //       ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
            // });
            // log('${containsSpecificId(state.getFavCategoryModel!.data!.favorites!, widget.subCategoryCardData.sId.toString())} ${widget.subCategoryCardData.sId} 7777777777777777777777777777');
            //
            // state.getFavCategoryModel!.data!.favorites!.forEach((element) {
            //   if (element.id == widget.subCategoryCardData.sId) {
            // //     log("truetruetruetruetruetruetruetruetruetruetruetruetruetruetruetrue=================");
            //   }
            // });
            // widget.subCategoryCardData.sId
            // ?

            // // log(state.getFavCategoryModel!.data!.favorites![widget.index]
            //         .id! +
            //     "fffffffffffffffffffffffffff" +
            //     widget.subCategoryCardData.sId.toString());
            Positioned(
                top: 5,
                right: 5,
                child: IconAppButton(
                  size: 25,
                  icon: Icons.favorite,
                  color: containsSpecificId(
                          tinderCubit.state.getFavCategoryModel!.data,
                          widget.subCategoryCardData.sId.toString())
                      ? Colors.redAccent
                      : Colors.grey,
                  onPressed: () {
                    // context
                    //     .read<TinderViewCubit>()
                    //     .fetchFavorites(TinderSharedUtils.token);
                    // log('from add fav ---------------------------');
                    //
                    // context.read<TinderViewCubit>().addFavoriteCategory(
                    //     accessToken: TinderSharedUtils.token,
                    //     categoryId: subCategoryCardData.sId!);
                    //

                    // setState(() {
                    tinderCubit
                        .addFavoriteCategory(
                            accessToken: userCubit.state.token!.accessToken,
                            categoryId: widget.subCategoryCardData.sId!)
                        .then((value) => tinderCubit.fetchFavorites(
                            userCubit.state.token!.accessToken));
                    // });
                  },
                  // onPressed: () => _navigateToDynamicGridView(context),
                )

                //     FutureBuilder(
                //   builder: (context, state) {
                // //     log('${state.data}2222222222222222222222222222222222222222222');
                //     // for (var element in state.data!) {
                //     //   element.id == widget.subCategoryCardData.sId
                //     //       ? const Icon(
                //     //           size: 25,
                //     //           Icons.favorite_border,
                //     //           color: Colors.green,
                //     //         )
                //     //       : const Icon(
                //     //           size: 25,
                //     //           Icons.favorite_border,
                //     //           color: Colors.grey,
                //     //         );
                //     // }
                //     return const Sizer();
                //   },
                //   future: context
                //       .read<TinderViewCubit>()
                //       .fetchFavorites(TinderSharedUtils.token)
                //     ..then((value) {
                // //       log('${value!.first.id}999999999999999999999999999999999999');
                //     }),
                // ),
                )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: widget.subCategoryCardData.nameEn ?? '',
                style: Styles.headerText(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Label(
                text: '${9355.toShortScale} ads',
                style: Styles.mediumText(fontSize: 14),
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
                    builder: (context) => TinderSubCategoryAdsView(
                      params: TinderSubAdsViewParams(
                          mainCategory: MainCategoryEntity(
                            id: widget.subCategoryCardData.sId!,
                            name: widget.subCategoryCardData.nameEn!,
                            image: widget.subCategoryCardData.picture!,
                            banner: widget.subCategoryCardData.picture!,
                            cover: widget.subCategoryCardData.picture!,
                            isFavorite: containsSpecificId(
                                tinderCubit.state.getFavCategoryModel!.data,
                                widget.subCategoryCardData.sId.toString()),
                            total: 2,
                          ),
                          subCategory: SubCategoryEntity(
                              id: widget.subCategoryCardData.sId!,
                              name: widget.subCategoryCardData.nameEn!,
                              image: widget.subCategoryCardData.picture!,
                              isFavorite: containsSpecificId(
                                  tinderCubit.state.getFavCategoryModel!.data,
                                  widget.subCategoryCardData.sId.toString()))),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

}
