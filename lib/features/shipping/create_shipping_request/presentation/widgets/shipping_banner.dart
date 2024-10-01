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

class ShippingBanner extends StatefulWidget {
  const ShippingBanner({
    super.key,
    required this.model,
    this.favoriteName,
    this.onRegister,
  });

  final BannerModel model;
  final String? favoriteName;
  final dynamic Function()? onRegister;

  @override
  State<ShippingBanner> createState() => _ShippingBannerState();
}

class _ShippingBannerState extends State<ShippingBanner> {
  bool isFavrote = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavrote = widget.model.mainCategory?.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MainCategoryBanner(
      // noCount: true,
      onFavorite: () {
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
          context.push(Routes.SHIPPING_REGISTER);
        } else {
          // context.push(Routes.SHIPPING_REGISTER);
          context.push(Routes.LOGIN);
        }
      },
      // canRegister: true,
      canRegister: !(widget.model.mainCategory?.isDriver ?? false) &&
          !(widget.model.mainCategory?.isDriverApproved ?? false),
      category: MainCategoryEntity(
        id: widget.model.mainCategory?.mainCategoryId ?? '',
        name: getLang() == 'ar'
            ? widget.model.mainCategory?.nameAr ?? ''
            : widget.model.mainCategory?.nameEn ?? '',
        banner: widget.model.mainCategory?.banner ?? UIConst.imagePlaceHolder,
        cover: widget.model.mainCategory?.cover ?? UIConst.imagePlaceHolder,
        image: UIConst.imagePlaceHolder,
        total: widget.model.mainCategory?.driverLength ?? 0,
        // favoriteName: widget.favoriteName,
        isFavorite: widget.model.mainCategory?.isFavorite ?? false, nameEn: '',
      ),
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
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
    //           Sizer
    //             height: 20.h,
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
