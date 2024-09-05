import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/favorite_shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SubcategoryCardSelected extends StatefulWidget {
  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;
  final bool selected;
  final void Function(bool?)? onChanged;
  const SubcategoryCardSelected(
      {super.key,
      this.onChanged,
      required this.item,
      required this.mainCategory,
      required this.selected});

  @override
  State<SubcategoryCardSelected> createState() =>
      _SubcategoryCardSelectedState();
}

class _SubcategoryCardSelectedState extends State<SubcategoryCardSelected> {
  bool isFav = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav = widget.item.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kToolbarHeight * 2.5,
      height: kToolbarHeight * 3,
      margin: const EdgeInsets.only(bottom: 5, top: 5, right: 5, left: 5),
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.selected ? Colors.red : Colors.transparent,
              width: 1),
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
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconAppButton(
                        icon: isFav ? Icons.favorite : Icons.favorite_outline,
                        color: isFav ? Colors.red : Colors.black,
                        onPressed: () {
                          log('llllll');
                          setState(() {
                            context
                                .read<FavoriteShippingCubit>()
                                .favorite(widget.item.id);
                            isFav = !isFav;
                            log(widget.item.isFavorite.toString());
                          });
                        }))
              ],
            ),
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: widget.item.name,
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                      Label(text: '${widget.item.numberOfContent ?? 0} Driver')
                    ],
                  ),
                ),
                Checkbox(value: widget.selected, onChanged: widget.onChanged)
                // IconAppButton(
                //     icon: Icons.,
                //     size: 20,
                //     onPressed: () {
                //       if (AuthHelper().isLoggedIn()) {
                //         context.push(Routes.CREATEAD,
                //             extra: CategorizationEntity(
                //                 mainCategory: mainCategory,
                //                 subCategory: item));
                //       } else {
                //         context.push(Routes.LOGIN);
                //       }
                //     })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
