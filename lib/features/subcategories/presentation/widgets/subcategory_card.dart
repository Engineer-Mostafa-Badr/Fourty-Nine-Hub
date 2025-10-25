import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/functions/helper/auth_helper.dart';
import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../ads_feature/ads/presentation/pages/ads_view.dart';
import '../../../ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../../../fourty_nine/domain/entities/main_category_entity.dart';
import '../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../../../helpers/manage_vibration.dart';

class SubCategoryCard extends StatefulWidget {
  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;
  final Function() onFav;

  const SubCategoryCard(
      {super.key,
      required this.item,
      required this.mainCategory,
      required this.onFav});

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADS,
          extra: AdsViewParams(
              mainCategory: widget.mainCategory, subCategory: widget.item)),
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.white24 : Colors.black26,
          borderRadius: BorderRadius.circular(30.r),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.fill,
                      radius: 30.r,
                      url: widget.item.image,
                    ),
                  ),
                  if (context.read<UserCubit>().isLoggedIn)
                    PositionedDirectional(
                        top: 10.h,
                        start: 10.w,
                        child: IconAppButton(
                          icon: widget.item.isFavorite == false
                              ? Icons.favorite_outline
                              : Icons.favorite,
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
            Row(
              children: [
                IconAppButton(
                    icon: Icons.add_circle_outline_rounded,
                    size: 40.h,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      ManageVibration.vibrate();
                      if (AuthHelper().isLoggedIn()) {
                        context.push(Routes.CREATEAD,
                            extra: CategorizationEntity(
                                mainCategory: widget.mainCategory,
                                subCategory: widget.item));
                      } else {
                        // context.push(Routes.LOGIN);

                        return pleaseLoginDialog(context);
                      }
                    }),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Label(
                    text: context.isArabic
                        ? widget.item.nameAr
                        : widget.item.nameEn,
                    style: Styles.smallText(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
