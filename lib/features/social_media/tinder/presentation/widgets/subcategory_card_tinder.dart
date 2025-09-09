import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/functions/helper/auth_helper.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../ads_feature/ads/presentation/pages/ads_view.dart';
import '../../../../ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../fourty_nine/domain/entities/main_category_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../helpers/manage_vibration.dart';

class SubcategoryCardTinder extends StatefulWidget {
  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;
  final Function() onFav;
  const SubcategoryCardTinder(
      {super.key,
      required this.item,
      required this.mainCategory,
      required this.onFav});

  @override
  State<SubcategoryCardTinder> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubcategoryCardTinder> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADS,
          extra: AdsViewParams(
              mainCategory: widget.mainCategory, subCategory: widget.item)),
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
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
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.cover,
                      radius: 5,
                      url: widget.item.image,
                    ),
                  ),
                  if (context.read<UserCubit>().isLoggedIn)
                    PositionedDirectional(
                        top: 2.h,
                        child: IconAppButton(
                          icon: widget.item.isFavorite == false
                              ? Icons.favorite_outline
                              : Icons.favorite,
                          size: 50.sp,
                          onPressed: () async {
                            ManageVibration.vibrate();
                            var result = await widget.onFav();
                            if (result == true) {
                              widget.item.isFavorite = !widget.item.isFavorite!;
                              setState(() {});
                            }
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
                    child: Label(
                      text: context.isArabic
                          ? widget.item.nameAr
                          : widget.item.nameEn,
                      style: Styles.smallText(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  IconAppButton(
                      icon: Icons.add_box_rounded,
                      size: 40.h,
                      onPressed: () {
                        ManageVibration.vibrate();
                        if (AuthHelper().isLoggedIn()) {
                          context.push(Routes.CREATEAD,
                              extra: CategorizationEntity(
                                  mainCategory: widget.mainCategory,
                                  subCategory: widget.item));
                        } else {
                          return pleaseLoginDialog(context);
                          // context.push(Routes.LOGIN);
                        }
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
