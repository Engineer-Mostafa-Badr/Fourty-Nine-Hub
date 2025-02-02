import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/ride_shipping_button_sheet.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/favorite_main_cateogry_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class RiderBanner extends StatefulWidget {
  const RiderBanner({
    super.key,
    required this.model,
    this.deleteReqeust,
    this.favoriteName,
  });

  final BannerModel model;
  final String? favoriteName;
  final bool? deleteReqeust;

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
    return GestureDetector(
      onTap: () {
        if (context.read<UserCubit>().isLoggedIn) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (context) =>
                    serviceLocator<ShippingCubit>()..getBannerData(),
                child: RideShippingButtonSheet(
                  model: widget.model,
                ),
              );
            },
          );
        } else {
          context.push(Routes.REGISTER);
        }
      },
      child: MainCategoryBanner(
        fromHome: false,
        removeFavorite: true,
        onFavorite: () {
          log("message");
          if (isFavrote) {
            log("messageTrue");
            context
                .read<FavoriteMainCateogryCubit>()
                .favorite(widget.model.mainCategory?.mainCategoryId ?? "");
            widget.model.mainCategory?.isFavorite = false;
            isFavrote = false;
            setState(() {});
            return isFavrote;
          } else {
            log("messageFalse");
            context
                .read<FavoriteMainCateogryCubit>()
                .favorite(widget.model.mainCategory?.mainCategoryId ?? "");
            widget.model.mainCategory?.isFavorite = true;
            isFavrote = true;
            setState(() {});
            return isFavrote;
          }
        },
        onRegister: () {},
        canRegister: false,
        category: MainCategoryEntity(
          nameEn:
              context.isArabic ? "تسجيل سائق سيارة/نقل" : "Car/Truck Register",
          id: widget.model.mainCategory?.mainCategoryId ?? '',
          name:
              context.isArabic ? "تسجيل سائق سيارة/نقل" : "Car/Truck Register",
          banner: widget.model.mainCategory?.banner ?? UIConst.imagePlaceHolder,
          cover: widget.model.mainCategory?.cover ?? UIConst.imagePlaceHolder,
          image: UIConst.imagePlaceHolder,
          total: widget.model.mainCategory?.driverLength ?? 0,
          isFavorite: widget.model.mainCategory?.isFavorite ?? false,
        ),
      ),
    );
  }
}
