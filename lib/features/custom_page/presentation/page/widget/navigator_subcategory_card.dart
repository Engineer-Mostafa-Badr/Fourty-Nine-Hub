import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/custom_page_sub_categories_entity.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/style/styles.dart';
import '../../../domain/entity/custom_page_categories_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class NavigatorSubCategoryCard extends StatefulWidget {
  final CustomPageSubCategoriesEntity item;
  final CustomPageCategoriesEntity mainCategory;
  final Function() onFav;
  bool? isSelected;

  NavigatorSubCategoryCard({
    super.key,
    required this.item,
    required this.mainCategory,
    required this.onFav,
    this.isSelected,
  });

  @override
  State<NavigatorSubCategoryCard> createState() =>
      _NavigatorSubCategoryCardState();
}

class _NavigatorSubCategoryCardState extends State<NavigatorSubCategoryCard> {
  @override
  void initState() {
    widget.isSelected = widget.item.enabled ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                    fit: BoxFit.cover,
                    radius: 30.r,
                    url: widget.item.picture,
                  ),
                ),
                PositionedDirectional(
                    top: 10.h,
                    start: 10.w,
                    child: BlocBuilder<CustomPageCubit, CustomPageState>(
                      builder: (context, state) {
                        return IconAppButton(
                          icon: widget.item.selected == false
                              ? Icons.favorite_outline
                              : Icons.favorite,
                          onPressed: () async {
      ManageVibration.vibrate();
                            var result = await widget.onFav();
                            print("resutlt=$result");
                            print(result);
                            if (result == null) return;
                            setState(() {
                              widget.item.selected = !widget.item.selected;
                              print(widget.item.selected);
                              widget.isSelected = result;
                              print("===================$result");
                            });
                            context.read<CustomPageCubit>().updateCategoryModel(
                                  subCategoryId: widget.item.id,
                                  categoryId: widget.mainCategory.id,
                                );
                          },
                          color: AppColors.SECONDARY_COLOR,
                        );
                      },
                    ))
              ],
            ),
          ),
          Label(
            text: context.isArabic ? widget.item.nameAr : widget.item.nameEn,
            style: Styles.smallText(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      ),
    );
  }
}