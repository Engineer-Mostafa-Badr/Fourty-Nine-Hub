import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class SubCategorySearchView extends StatelessWidget {
  const SubCategorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: GridView.builder(
        itemCount: 10,
        //      controller: controller.scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemBuilder: (context, index) {
          return buildItem(context);
          // final subCategory = state.subCategories![index];
          // return SubCategoryCard(
          //   mainCategory: controller.selectedCategory,
          //   item: subCategory,
          //   onFav: () {
          //     print("object");
          //     return controller.toggleSubCategoryToFavorites(
          //         state.subCategories![index].id);
          //   },
          // );
        },
      ),
    );
  }

  Widget buildItem(context) => InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5.r),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    offset: Offset(-1, 1),
                    blurRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: SquareImage(
                        fit: BoxFit.cover,
                        radius: 5,
                        url:
                            'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg',
                      ),
                    ),
                    Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: IconAppButton(
                          icon: Icons.favorite_outline,
                          onPressed: () async {
                            // var result = await widget.onFav();
                            // if (result == true) {
                            //   widget.item.isFavorite = !widget.item.isFavorite!;
                            //   setState(() {});
                            // }
                          },
                          color: AppColors.SECONDARY_COLOR,
                        ))
                  ],
                ),
              ),
              const Sizer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: 'Craft',
                            style:
                                Styles.mediumText(fontWeight: FontWeight.bold),
                          ),
                          Label(
                            text: '0 ${LocaleKeys.ads.localize}',
                            style: Styles.smallText(fontSize: 25),
                          )
                        ],
                      ),
                    ),
                    IconAppButton(
                        icon: Icons.add_box_rounded,
                        size: 40.h,
                        onPressed: () {
                          // if (AuthHelper().isLoggedIn()) {
                          //   context.push(Routes.CREATEAD,
                          //       extra: CategorizationEntity(
                          //           mainCategory: widget.mainCategory,
                          //           subCategory: widget.item));
                          // } else {
                          //   context.push(Routes.LOGIN);
                          // }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
