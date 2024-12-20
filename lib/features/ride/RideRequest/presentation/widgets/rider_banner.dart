import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/favorite_main_cateogry_cubit.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/lang_helper.dart';

class RiderBanner extends StatefulWidget {
  const RiderBanner({
    super.key,
    required this.model,
    this.favoriteName,
  });

  final BannerModel model;
  final String? favoriteName;

  @override
  State<RiderBanner> createState() => _RiderBannerState();
}

class _RiderBannerState extends State<RiderBanner> {
  bool isFavrote = false;
  @override
  void initState() {
    super.initState();
    isFavrote = widget.model.mainCategory?.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MainCategoryBanner(
      removeFavorite: true,
      onFavorite: () {
        log("message");
        if (isFavrote) {
          context
              .read<FavoriteMainCateogryCubit>()
              .favorite(widget.model.mainCategory?.mainCategoryId ?? "");
          isFavrote = false;
          return isFavrote;
        } else {
          context
              .read<FavoriteMainCateogryCubit>()
              .favorite(widget.model.mainCategory?.mainCategoryId ?? "");
          isFavrote = true;
          return isFavrote;
        }
        // setState(() {
        //   isFavrote = !isFavrote!;
        // });
        // log("Slkdfjld");
        // return true;
      },
      onRegister: () {
        if (context.read<UserCubit>().isLoggedIn) {
          context.push(Routes.RIDERREGISTER);
        } else {
          context.push(Routes.REGISTER);
        }
      },
      // canRegister: true,
      // canRegister: true,
      canRegister: !(widget.model.mainCategory?.isDriver ?? false) &&
          !(widget.model.mainCategory?.isDriverApproved ?? false),
      category: MainCategoryEntity(
        nameEn: widget.model.mainCategory?.nameEn,
        id: widget.model.mainCategory?.mainCategoryId ?? '',
        name: getLang() == 'ar'
            ? widget.model.mainCategory?.nameAr ?? ''
            : widget.model.mainCategory?.nameEn ?? '',
        banner: widget.model.mainCategory?.banner ?? UIConst.imagePlaceHolder,
        cover: widget.model.mainCategory?.cover ?? UIConst.imagePlaceHolder,
        image: UIConst.imagePlaceHolder,
        total: widget.model.mainCategory?.driverLength ?? 0,
        // favoriteName: widget.favoriteName,
        isFavorite: widget.model.mainCategory?.isFavorite ?? false,
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //   decoration: BoxDecoration(
    //     color: AppColors.YELLOW_COLOR,
    //     borderRadius: BorderRadius.circular(5),
    //     image: DecorationImage(
    //       fit: BoxFit.cover,
    //       image: CachedNetworkImageProvider(model.mainCategory?.banner ?? ""),
    //     ),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         children: [
    //           const Icon(
    //             Icons.favorite_border,
    //             color: AppColors.SECONDARY_COLOR,
    //           ),
    //           const Sizer(
    //             height: 20,
    //           ),
    //           Text(
    //             '${model.mainCategory?.driverLength?.toShortScale} ${"Driver"}',
    //             style: Styles.mediumText(
    //               color: Colors.white,
    //             ),
    //           )
    //         ],
    //       ),
    //       Text(
    //         "Shipping",
    //         style: Styles.headerText(color: Colors.white),
    //       ),
    //       InkWell(
    //         onTap: () {
    // if (context.read<UserCubit>().isLoggedIn) {
    //   context.push(Routes.SHIPPING_REGISTER);
    // } else {
    //   context.push(Routes.SHIPPING_REGISTER);
    //   // context.push(Routes.LOGIN);
    // }
    //         },
    //         child: Text(
    //           Labels.register,
    //           style: Styles.mediumText(color: Colors.white),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
